import 'package:flutter/material.dart';

class GameContent extends StatelessWidget {
  final String? imagePath;
  final String? text;
  final String? description;
  final String? subtitle;
  const GameContent(
      {super.key, this.imagePath, this.text, this.description, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.background,
      body: Column(
        children: [
          Text(
            "Deeply",
            style: TextStyle(
                color: theme.onBackground,
                fontFamily: "PlayfairDispaly",
                fontSize: 36,
                fontWeight: FontWeight.w100),
          ),
          Text(
            text ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontStyle: FontStyle.italic,
                fontFamily: "PlayfairDispaly",
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: theme.onBackground),
          ),
          const Spacer(),
          Image.asset(
            imagePath ?? '',
            width: size.width * 0.80,
            // height: 200,
          ),
          const Spacer(),
          Text(
            subtitle ?? '',
            style: TextStyle(
                fontFamily: "PlayfairDispalyNormal",
                color: theme.onBackground,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w800,
                fontSize: 33),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              description ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "PlayfairDispalyNormal",
                color: theme.onBackground,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Spacer()
        ],
      ),
    );
  }
}

class Onboarding {
  final String imagePath;
  final String title;
  final String description;
  Onboarding(
      {required this.description,
      required this.imagePath,
      required this.title});
}

class DotIndicator extends StatelessWidget {
  final bool isActive;
  const DotIndicator({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    // Utilisez Theme.of(context) pour respecter les paramètres de couleur de votre app
    final Color activeColor = Theme.of(context).primaryColor;
    final Color inactiveColor = activeColor.withOpacity(0.3);  // ou une autre couleur moins visible

    return Container(
      width: 8,  // Taille modérée pour les points
      height: 8,  // Forme carrée pour commencer, mais le borderRadius va rendre le point rond
      margin: const EdgeInsets.symmetric(horizontal: 4),  // Espace entre les points
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(4),  // BorderRadius de la moitié de width/height pour un cercle parfait
      ),
    );
  }
}


class GameSelectionContent {
  String? title;
  String? subtitle;
  String? imageUrl;
  String? description;
  GameSelectionContent(
      {this.description, this.imageUrl, this.subtitle, this.title});
}
