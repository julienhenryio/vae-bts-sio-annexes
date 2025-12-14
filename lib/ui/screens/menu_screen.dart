import 'package:audioplayers/audioplayers.dart';
import 'package:deeply_app/ui/screens/archive_date.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:deeply_app/ui/screens/question_screen.dart';
import 'package:deeply_app/ui/widgets/default_appbar.dart';
import 'package:deeply_app/ui/widgets/default_button.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const DefaultAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Deeply",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: theme.onBackground,
                      fontFamily: "PlayfairDispaly",
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Center(
              child: Text(
                "game_selection.title-1".tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontStyle: FontStyle.italic,
                    fontFamily: "PlayfairDispaly",
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: theme.onBackground),
              ),
              ),
              const Spacer(),
              Center(
                child: DefaultButton(
                  onTap: () {
                    final audioPlayer = AudioPlayer();
                    audioPlayer.play(AssetSource("audio.mp3"));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QuestionScreen(
                                category: "Introspection",
                              )),
                    );
                  },
                  text: "button.play".tr(),
                  width: 200,
                ),
              ),
              const Spacer(),
              Center(
                child: DefaultButton(
                  onTap: () {
                    final audioPlayer = AudioPlayer();
                    audioPlayer.play(AssetSource("audio.mp3"));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ArchiveDate(),
                      ),
                    );
                  },
                  text: "${"button.archives".tr()} 📂",
                  width: 200,
                ),
              ),
              const Spacer(),
              Image.asset("assets/images/img1.png"),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
