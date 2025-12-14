import 'package:deeply_app/ui/screens/archive_questions_details.dart';
import 'package:deeply_app/ui/widgets/default_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:developer';

class ArchiveDate extends StatelessWidget {
  const ArchiveDate({super.key});

  @override
  Widget build(BuildContext context) {
    final userAnswers = Hive.box("user_answers");
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).colorScheme;

    if (userAnswers.isEmpty) {
      return Scaffold(
        appBar: const DefaultAppBar(
          title: "Archives",
        ),
        body: Center(
          child: Text(
            'archive.empty'.tr(),
            style: const TextStyle(
              fontFamily: "PlayfairDispalyNormal",
            ),
          ),
        ),
      );
    }

    // Récupérer les clés et les données
    final keyDataPairs = userAnswers.keys
        .where((key) => userAnswers.get(key) is Map)
        .map((key) => MapEntry(key, Map<String, dynamic>.from(userAnswers.get(key))))
        .toList();

    // Trier les paires clé-données
    keyDataPairs.sort((a, b) =>
        DateTime.parse(b.value['date']).compareTo(DateTime.parse(a.value['date'])));

    return Scaffold(
      appBar: const DefaultAppBar(
        title: "Archives",
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: size.height,
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: keyDataPairs.length,
          itemBuilder: (context, index) {
            final keyDataPair = keyDataPairs[index];
            final key = keyDataPair.key;
            final questionData = keyDataPair.value;
            final questionText = questionData["question"] as String;
            final hasAudio = questionData.containsKey("audioPath");

            log('Index: $index, Key: $key, Data: $questionData');

            return InkWell(
              onTap: () {
                final updatedQuestionData = {...questionData, 'key': key}; // Ajouter la clé aux données
                log('Navigating with Key: $key, Data: $updatedQuestionData'); // Log pour vérifier la navigation

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArchiveQuestionDetails(
                      questionData: updatedQuestionData, // Passer les données de la question avec la clé
                    ),
                  ),
                );
              },
              child: Card(
                color: theme.primary,
                child: ListTile(
                  title: Text(
                    questionText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "PlayfairDispalyNormal",
                    ),
                  ),
                  trailing: hasAudio
                      ? const Icon(
                          Icons.audiotrack,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}