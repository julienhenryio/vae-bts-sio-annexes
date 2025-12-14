import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:deeply_app/ui/widgets/default_button.dart'; // Import de DefaultButton

class QuestionDisplay extends StatelessWidget {
  final String category;
  final String question;
  final VoidCallback onNextQuestion;

  const QuestionDisplay({
    Key? key,
    required this.category,
    required this.question,
    required this.onNextQuestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20), // Padding horizontal ajouté
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            category,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "PlayfairDispalyNormal",
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 36,
              color: theme.onBackground,
            ),
          ),
          const SizedBox(height: 15),
          Image.asset(
            "assets/images/img5.png",
            width: 30,
          ),
          SizedBox(height: size.height * 0.17), // Utilisation de la taille de l'écran pour le spacing
          Text(
            question,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "PlayfairDispalyNormal",
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: theme.onBackground,
            ),
          ),
          const Spacer(),
          Center(
            child: DefaultButton(
              onTap: onNextQuestion,
              text: "button.next_question".tr(),
              width: 230,
              textSize: 25,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}