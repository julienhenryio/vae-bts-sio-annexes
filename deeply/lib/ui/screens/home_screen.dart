import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:deeply_app/ui/screens/question_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:deeply_app/ui/screens/menu_screen.dart';
import 'package:deeply_app/ui/widgets/default_appbar.dart';
import 'package:deeply_app/ui/widgets/default_button.dart';
import 'package:deeply_app/ui/widgets/game_selection_content.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/links/links.json');
    return json.decode(jsonString);
  }

  int page = 0;
  final _pageConroller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: const DefaultAppBar(),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: 5,
              controller: _pageConroller,
              onPageChanged: (index) {
                setState(() {
                  page = index;
                });
              },
              itemBuilder: (context, index) {
                return index < 4
                    ? GameContent(
                        imagePath: "assets/images/img${index + 1}.png",
                        text: "game_selection.title-${index + 1}".tr(),
                        description:
                            "game_selection.description-${index + 1}".tr(),
                        subtitle: "game_selection.sub_title-${index + 1}".tr(),
                      )
                    : Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40.0), // Ajoute un padding horizontal
    child: Text(
      "url_launcher_text".tr(),
      textAlign: TextAlign.center, // Centre le texte horizontalement
      style: const TextStyle(
        fontFamily: "PlayfairDispaly",
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
  ),
),
const SizedBox(height: 45),
// Afficher l'image en fonction du thème
Image.asset(
  Theme.of(context).brightness == Brightness.light 
    ? 'assets/images/img6.png' 
    : 'assets/images/img7.png',
  height: 150,
  width: 150,
  fit: BoxFit.cover,
),
const SizedBox(height: 5),
// Ajout du @ Instagram
const Text(
  "@deeply.app",
  style: TextStyle(
    fontFamily: "PlayfairDispaly",
    fontSize: 18,
  ),
),
const SizedBox(height: 40),
      // Bouton Instagram
      FutureBuilder<Map<String, dynamic>>(
        future: loadJsonData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final socialMediaLinks = snapshot.data!;
          return Column(
            children: socialMediaLinks.keys.map((key) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: DefaultButton(
                  text: key,
                  width: 230,
                  onTap: () async {
                    final url = Uri.parse(socialMediaLinks[key]);
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    ],
  ),
);
              },
            ),
          ),
          

          if (page < 4)
            DefaultButton(
              text: "button.discover".tr(),
              width: 230,
              onTap: () {
                final audioPlayer = AudioPlayer();
                audioPlayer.play(AssetSource("audio.mp3"));

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _pageConroller.page?.round() == 0
                        ? const MenuScreen()
                        : QuestionScreen(
                            category:
                                "game_selection.sub_title-${page + 1}".tr(),
                          ),
                  ),
                );
              },
            ),
          const SizedBox(height: 45),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
          child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: List.generate(5, (index) {  
    return GestureDetector(
      onTap: () {
        _pageConroller.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      },
      child: DotIndicator(isActive: page == index),
    );
  }),
),
          )
        ],
      ),
      
    );
  }
}
