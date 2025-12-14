import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const QuestionsAppBar({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      centerTitle: true,
      title: Text(
        title ?? "",
        style: TextStyle(
          fontFamily: "PlayfairDispalyNormal",
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w800,
          fontSize: 36,
          color: theme.colorScheme.onBackground,
        ),
      ),
      backgroundColor: theme.colorScheme.background,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10), // Ajout du padding horizontal
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              final audioPlayer = AudioPlayer();
              audioPlayer.play(AssetSource("audio.mp3"));
              final themeModeProvider =
                  Provider.of<ValueNotifier<ThemeMode>>(context, listen: false);
              if (themeModeProvider.value == ThemeMode.system) {
                themeModeProvider.value = ThemeMode.dark;
              } else {
                themeModeProvider.value = ThemeMode.system;
              }
            },
            child: const Icon(Icons.dark_mode),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}