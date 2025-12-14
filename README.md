# Annexes numériques - VAE BTS SIO SLAM

Ce dépôt contient les ressources numériques complémentaires au Livret 2 de validation des acquis de l'expérience (VAE) pour le BTS Services Informatiques aux Organisations, option Solutions Logicielles et Applications Métiers (SLAM).

**Candidat** : HENRY Julien
**Diplôme visé** : BTS SIO option SLAM (RNCP 40792)
**Date de dépôt** : Décembre 2025

---

## Contenu du dépôt

### presentations/
Supports de présentation au format PDF :
- `presentation-alliance.pdf` : Présentation du bot RAG pour la formation des opérateurs (DossierFacile), présentée à l'incubateur ALLiaNCE
- `atelier-faux-documents.pdf` : Support de formation à la détection de faux documents (fiches de paie)
- `experience-faux-dossier.pdf` : Présentation de l'expérience du faux dossier test (séminaire DossierFacile)
- `sensibilisation-iban.pdf` : Document de sensibilisation aux risques liés à l'exposition des IBAN
- `documentation-technique-bot-rag.pdf` : Documentation technique du bot RAG (architecture, outils utilisés) — rédigée pour assurer la pérennité du projet

---

# Deeply - Application mobile d'introspection et de conversations authentiques

Application mobile cross-platform (iOS/Android) développée en Flutter, conçue pour faciliter l'introspection personnelle et les conversations profondes entre proches.

**Développeur** : Julien Henry
**Période de développement** : Mars 2024 → Juillet 2024
**Contexte** : Projet personnel, réalisé dans le cadre d'un apprentissage autodidacte du développement mobile

---

## Liens de téléchargement

- **iOS** : [App Store](https://apps.apple.com/fr/app/deeply-app/id6504491197)
- **Android** : [Google Play Store](https://play.google.com/store/apps/details?id=com.deeply.app)

---

## Présentation

Deeply propose des questions profondes pour :
- **Mode Introspection** : 122 questions pour mieux se connaître, avec possibilité d'enregistrer ses réponses (texte ou vocal)
- **Mode Couple** : Questions pour approfondir la relation amoureuse
- **Mode Général** : Questions variées pour des conversations entre amis ou en famille
- **Mode Débat** : Questions philosophiques et éthiques pour stimuler la réflexion

L'application est **100% gratuite**, sans publicité, et **respectueuse de la vie privée** : toutes les données restent stockées localement sur l'appareil de l'utilisateur.

---

## Stack technique

| Élément | Technologie |
|---------|-------------|
| **Framework** | Flutter SDK >=3.2.0 |
| **Langage** | Dart |
| **Base de données** | Hive (NoSQL local) |
| **State Management** | Provider + StatefulWidget |
| **Audio** | audio_waveforms, audioplayers, record |
| **Internationalisation** | easy_localization (FR/EN) |
| **Permissions** | permission_handler |

---

## Structure du projet
```
deeply_app/
├── lib/
│   ├── main.dart                     # Point d'entrée
│   └── ui/
│       ├── screens/                  # Écrans de l'application
│       │   ├── home_screen.dart
│       │   ├── menu_screen.dart
│       │   ├── question_screen.dart  # Logique principale
│       │   ├── archive_date.dart
│       │   └── archive_questions_details.dart
│       ├── widgets/                  # Composants réutilisables
│       └── theme/
│           └── theme.dart            # Thèmes light/dark
├── assets/
│   ├── questions/                    # 4 fichiers JSON (122+ questions)
│   ├── translations/                 # Fichiers i18n
│   └── images/
└── pubspec.yaml
```

**Total** : 12 fichiers Dart, ~1600 lignes de code

---

## Fonctionnalités techniques

### Stockage local (Hive)
Les réponses de l'utilisateur sont stockées localement :
```dart
{
  'question': String,      // Texte de la question
  'date': String,          // Date de la réponse
  'answerText': String?,   // Réponse textuelle (optionnel)
  'audioPath': String?     // Chemin du fichier audio (optionnel)
}
```

### Enregistrement audio
- Enregistrement vocal avec visualisation de la forme d'onde en temps réel
- Encodage adapté par plateforme : `.aac` (iOS), `.m4a` (Android)

### Dark mode
- Thème clair et sombre entièrement personnalisés
- Bascule instantanée via Provider

### Internationalisation
- Interface disponible en français et anglais
- Questions traduites dans les deux langues

---

## Confidentialité (RGPD)

- **Aucune collecte de données** : pas de compte utilisateur, pas de tracking, pas d'analytics
- **Stockage 100% local** : les réponses ne quittent jamais l'appareil
- **Aucun serveur** : l'application fonctionne entièrement hors ligne

---

## Contexte VAE

Ce projet a été réalisé dans le cadre d'une démarche de Validation des Acquis de l'Expérience (VAE) pour le BTS SIO option SLAM.

Il illustre les compétences suivantes :
- **U5-1** : Concevoir et développer une solution applicative
- **U5-2** : Assurer la maintenance corrective ou évolutive d'une solution applicative
- **U5-3** : Gérer les données
- **U6-1** : Protéger les données à caractère personnel
- **U4-4** : Travailler en mode projet
- **U4-5** : Mettre à disposition des utilisateurs un service informatique

---

## Contact

En cas de question concernant ce dépôt, merci de contacter le candidat via les coordonnées indiquées dans le Livret 2.

## Licence

Projet personnel — Tous droits réservés.
