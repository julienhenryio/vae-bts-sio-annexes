import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:deeply_app/ui/screens/archive_date.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

class ArchiveQuestionDetails extends StatefulWidget {
  final Map<String, dynamic> questionData;
  const ArchiveQuestionDetails({
    required this.questionData,
    super.key,
  });

  @override
  State<ArchiveQuestionDetails> createState() => _ArchiveQuestionDetailsState();
}

class _ArchiveQuestionDetailsState extends State<ArchiveQuestionDetails> {
  final TextEditingController answerController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // Ajout du ScrollController
  late final RecorderController recorderController;
  late final PlayerController playerController;
  late StreamSubscription<PlayerState> playerStateSubscription;

  @override
  void initState() {
    super.initState();
    log('Loaded questionData in initState: ${widget.questionData}');
    recorderController = RecorderController();
    playerController = PlayerController();
    playerStateSubscription = playerController.onPlayerStateChanged.listen((_) => setState(() {}));
    answerController.text = widget.questionData["answerText"] ?? "it's not answered by text";
    if (widget.questionData["audioPath"] != null) {
      _preparePlayer(widget.questionData["audioPath"]);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Ajout de la libération du ScrollController
    playerStateSubscription.cancel();
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              bool confirm = await _showConfirmationDialog(context);
              if (confirm) {
                _deleteQuestion();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Introspection",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "PlayfairDispalyNormal",
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: theme.onBackground,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Image.asset(
                    "assets/images/img5.png",
                    width: 30,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: theme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.questionData["question"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: "PlayfairDispalyNormal",
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const Divider(color: Colors.white),
                        SizedBox(
                          height: 350, // Ajuste la hauteur selon tes besoins
                          child: Scrollbar(
                            thumbVisibility: false,
                            controller: _scrollController, // Ajout du ScrollController
                            child: SingleChildScrollView(
                              controller: _scrollController, // Ajout du ScrollController
                              child: TextField(
                                enabled: false,
                                controller: answerController,
                                decoration: InputDecoration(
                                  hintText: "type_answer".tr(),
                                  border: InputBorder.none,
                                  hintStyle: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                                maxLines: null, // Permet le défilement
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                              ),
                            ),
                          ),
                        ),
                        if (widget.questionData["audioPath"] != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AudioFileWaveforms(
                                size: const Size(200, 30),
                                playerController: playerController,
                                playerWaveStyle: const PlayerWaveStyle(
                                  showSeekLine: false,
                                  showBottom: false,
                                  scaleFactor: 4000,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  if (playerController.playerState ==
                                      PlayerState.playing) {
                                    _pauseAudio();
                                  } else {
                                    _playAudio(widget.questionData["audioPath"]);
                                  }
                                },
                                child: SizedBox(
                                  child: Icon(
                                    playerController.playerState ==
                                            PlayerState.playing
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  _preparePlayer(String relativeAudioPath) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final absoluteAudioPath = '${documentsDirectory.path}/$relativeAudioPath';
    
    log("Preparing audio from path: $absoluteAudioPath");  // Log for debugging
    try {
      final audioFile = File(absoluteAudioPath);
      if (await audioFile.exists()) {
        log("Audio file exists at path: $absoluteAudioPath");
        await playerController.preparePlayer(path: absoluteAudioPath);
      } else {
        log("Audio file does not exist at path: $absoluteAudioPath");
      }
    } catch (e) {
      log("Error preparing or starting player: $e");
    }
  }

  void _playAudio(String relativeAudioPath) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final absoluteAudioPath = '${documentsDirectory.path}/$relativeAudioPath';

    log("Starting audio from path: $absoluteAudioPath");  // Log for debugging
    await playerController.startPlayer(finishMode: FinishMode.pause);
  }

  void _pauseAudio() async {
    await playerController.pausePlayer();
  }

  // Boîte de dialogue de confirmation
  Future<bool> _showConfirmationDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              tr('confirmation.message'),
              style: const TextStyle(
                fontFamily: "PlayfairDispalyNormal",
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  tr('confirmation.cancel'),
                  style: const TextStyle(
                    fontFamily: "PlayfairDispalyNormal",
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  tr('confirmation.delete'),
                  style: const TextStyle(
                    fontFamily: "PlayfairDispalyNormal",
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  ) ?? false;
}

  // Fonction de suppression de la question
  void _deleteQuestion() async {
    var box = Hive.box('user_answers');
    var key = widget.questionData['key'];

    log("Deleting question with key: $key");

    if (box.containsKey(key)) {
      await box.delete(key);
      log("Deleted question with key: $key");
    } else {
      log("Key not found in Hive box: $key");
    }

    // Vérifiez le contenu de la boîte après suppression
    log("After deletion:");
    for (var k in box.keys) {
      log("Remaining Key: $k, Value: ${box.get(k)}");
    }

    // Rediriger vers la page précédente
    if (mounted){
    Navigator.of(context).pushAndRemoveUntil(
      // ignore: prefer_const_constructors
      MaterialPageRoute(builder: (context) => ArchiveDate()),
      (Route<dynamic> route) => route.isFirst,
      );
  }
}
}
