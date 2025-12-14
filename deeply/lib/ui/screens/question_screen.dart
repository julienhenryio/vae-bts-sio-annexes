

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:deeply_app/ui/widgets/questions_appbar.dart';
import 'package:deeply_app/ui/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:deeply_app/ui/widgets/question_display.dart'; // Import du widget

class QuestionScreen extends StatefulWidget {
  final String category;
  const QuestionScreen({super.key, required this.category});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  bool answer = false;
  final pageController = PageController();
  final audioExtension = Platform.isIOS ? 'aac' : 'm4a';
  late final RecorderController recorderController;
  late Future<Map<String, List<String>>> _getQuestions;
  TextEditingController answerController = TextEditingController();
  final _userAnswers = Hive.box("user_answers");
  String audioPath = "";
  String jsonPath = "";
  bool audioRecorder = false;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    log(widget.category);
    answer = widget.category != 'Introspection';
    super.initState();
    getJsonPath();
    getPermission();
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
    _getQuestions = _loadQuestionsData();
    _getAudioFilePath();
  }

  void getJsonPath() {
    if (widget.category == "Introspection") {
      jsonPath = 'assets/questions/introspection.json';
    } else if (widget.category == "Couple") {
      jsonPath = 'assets/questions/couple.json';
    } else if (widget.category == "General" || widget.category == "Général") {
      jsonPath = 'assets/questions/generale.json';
    } else {
      jsonPath = 'assets/questions/debate.json';
    }
  }

  Future<void> getPermission() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      log("permission denied");
    }
  }

  Future<String> _getAudioFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    audioPath = directory.path;
    return audioPath;
  }

  Future<void> _saveAnswer(
    String question,
    String? answer,
    String? audioPath,
  ) async {
    final Map<String, dynamic> data = {
      'question': question,
      'date': DateTime.now().toString(),
    };

    if (answer != null) {
      data["answerText"] = answer;
    }

    if (audioPath != null) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final String uniqueKey = 'audio_${DateTime.now().millisecondsSinceEpoch}';
      final String uniqueAudioPath =
          '$uniqueKey.${audioPath.split('.').last}'; // Chemin relatif

      log("Original audio path: $audioPath");
      log("Unique audio path: ${documentsDirectory.path}/$uniqueAudioPath");

      data["audioPath"] = uniqueAudioPath;

      final parentDirectory = Directory(documentsDirectory.path);
      if (!parentDirectory.existsSync()) {
        parentDirectory.createSync(recursive: true);
      }

      File(audioPath).copySync('${documentsDirectory.path}/$uniqueAudioPath');
      log("Audio file copied to: ${documentsDirectory.path}/$uniqueAudioPath");
    }

    int newKey = await _userAnswers.add(data);
    log("Saved data with new key: $newKey, Data: $data");
    log("Amount of data is :${_userAnswers.length}");
  }

  Future<Map<String, List<String>>> _loadQuestionsData() async {
    final String jsonContent = await rootBundle.loadString(jsonPath);
    final questions = Map<String, dynamic>.from(jsonDecode(jsonContent));
    for (var entry in questions.entries) {
      entry.value.shuffle();
    }
    for (var entry in questions.entries) {
      entry.value.shuffle();
    }
    if (widget.category == "Introspection") {
      return questions.map(
        (key, value) => MapEntry(
          key,
          value.map<String>((e) => e.toString()).toList(),
        ),
      );
    }
    return questions.map(
      (key, value) => MapEntry(
        key,
        value.map<String>((e) => e.toString()).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;
    final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const QuestionsAppBar(),
        body: SafeArea(
          child: FutureBuilder(
            future: _getQuestions,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Icon(Icons.error));
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final questions = snapshot.data![languageCode]!;
              return PageView.builder(
                controller: pageController,
                itemCount: questions.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (widget.category == "Introspection") {
                    return buildIntrospectionView(context, questions[index], theme);
                  } else {
                    return QuestionDisplay(
                      category: widget.category,
                      question: questions[index],
                      onNextQuestion: () {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      },
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildIntrospectionView(BuildContext context, String question, ColorScheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.category,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "PlayfairDispalyNormal",
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: theme.onBackground),
              ),
              const SizedBox(width: 8),
              Image.asset(
                "assets/images/img5.png",
                width: 33,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              color: theme.primary,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      question,
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
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: Scrollbar(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: TextField(
                              cursorColor: Colors.white,
                              controller: answerController,
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                hintText: "type_answer".tr(),
                                border: InputBorder.none,
                                hintStyle: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AudioWaveforms(
                          shouldCalculateScrolledPosition: true,
                          enableGesture: true,
                          size: const Size(200, 20),
                          recorderController: recorderController,
                          waveStyle: const WaveStyle(
                            scaleFactor: 100,
                            waveColor: Colors.white,
                            extendWaveform: true,
                            showMiddleLine: false,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (recorderController.isRecording) {
                              await recorderController.stop(false);
                            } else {
                              recorderController.reset();
                              await recorderController.record(
                                path: "$audioPath/audio.$audioExtension}",
                              );
                              log("audio is recording into : $audioPath/audio.$audioExtension}");
                            }
                            setState(() {
                              audioRecorder = true;
                            });
                          },
                          child: SizedBox(
                            child: Icon(
                              recorderController.isRecording
                                  ? Icons.stop
                                  : audioRecorder
                                      ? Icons.refresh
                                      : Icons.mic,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          Center(
            child: DefaultButton(
              onTap: () async {
                if (recorderController.isRecording) {
                  await recorderController.stop();
                }
                if (audioRecorder) {
                  _saveAnswer(
                    question,
                    answerController.text,
                    "$audioPath/audio.$audioExtension}",
                  );
                } else {
                  _saveAnswer(
                    question,
                    answerController.text,
                    null,
                  );
                }
                answerController.text = "";
                audioRecorder = false;
                recorderController.reset();
                pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              },
              text: "button.answer".tr(),
width: 230,
),
),
const SizedBox(height: 10), // Ajouter un espace entre les boutons
Center(
child: InkWell(
onTap: () => pageController.nextPage(
duration: const Duration(milliseconds: 200),
curve: Curves.easeIn,
),
child: Text(
"button.next_question".tr(),
style: const TextStyle(
fontFamily: "PlayfairDispalyNormal",
decoration: TextDecoration.underline,
fontStyle: FontStyle.italic,
fontSize: 16,
),
),
),
),
const SizedBox(height: 20), // Ajuster l'espace en bas de la page
],
),
);
}
}
//code ends//
