import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const DefaultAppBar({super.key, this.title});

  void _showLanguageDialog(BuildContext context) {
    final languageCode = context.locale.languageCode;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            "choose_language".tr(),
            style: const TextStyle(
              fontFamily: "PlayfairDispalyNormal",
            ),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                final audioPlayer = AudioPlayer();
                audioPlayer.play(AssetSource("audio.mp3"));
                _changeLanguage(context, "en");
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "English",
                    style: TextStyle(
                      fontFamily: "PlayfairDispalyNormal",
                      fontWeight: languageCode == 'en'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  if (languageCode == 'en') const Icon(Icons.check)
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                final audioPlayer = AudioPlayer();
                audioPlayer.play(AssetSource("audio.mp3"));
                _changeLanguage(context, "fr");
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Français",
                    style: TextStyle(
                      fontFamily: "PlayfairDispalyNormal",
                      fontWeight: languageCode == 'fr'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  if (languageCode == 'fr') const Icon(Icons.check)
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _changeLanguage(BuildContext context, String languageCode) {
    log("Locale switched to: ${context.locale}");
    if (languageCode == "en") {
      context.setLocale(const Locale('en', 'US'));
    } else {
      context.setLocale(const Locale('fr', 'FR'));
    }
  }

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
        InkWell(
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
            child: const Icon(Icons.dark_mode)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              final audioPlayer = AudioPlayer();
              audioPlayer.play(AssetSource("audio.mp3"));
              _showLanguageDialog(context);
            },
            child: SvgPicture.asset(
              "assets/images/language.svg",
              width: 20,
              // ignore: deprecated_member_use
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
