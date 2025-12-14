import 'package:deeply_app/ui/screens/home_screen.dart';
import 'package:deeply_app/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Importer le package pour utiliser Future

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('user_answers');
  await EasyLocalization.ensureInitialized();

  // Ajouter un délai de 2 secondes
  Future.delayed(const Duration(seconds: 2), () {
    runApp(
      ChangeNotifierProvider(
        create: (context) => ValueNotifier<ThemeMode>(ThemeMode.system),
        child: EasyLocalization(
          supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
          path: 'assets/translations',
          saveLocale: true,
          fallbackLocale: const Locale('en', 'US'),
          child: const DeeplyDraft(),
        ),
      ),
    );
  });
}

class DeeplyDraft extends StatelessWidget {
  const DeeplyDraft({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ValueNotifier<ThemeMode>>(
      builder: (context, themeModeProvider, _) => MaterialApp(
        theme: themeModeProvider.value == ThemeMode.dark
            ? DeeplyDraftTheme.dark
            : DeeplyDraftTheme.light,
        themeMode: themeModeProvider.value,
        darkTheme: DeeplyDraftTheme.dark,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Deeply Draft',
        home: const HomeScreen(),
      ),
    );
  }
}
