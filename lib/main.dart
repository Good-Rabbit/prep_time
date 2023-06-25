import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:preptime/auth/auth.dart';
import 'package:preptime/firebase_options.dart';
import 'package:preptime/l10n/l10n.dart';
import 'package:preptime/router/router.dart';
import 'package:preptime/services/course_provider.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:preptime/services/firebase_provider.dart';
import 'package:preptime/services/settings_provider.dart';
import 'package:preptime/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // * Initialize default firebase
  FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  setPathUrlStrategy();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CourseProvider()),
      ChangeNotifierProvider(create: (_) => ExamProvider()),
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => FbProvider(appInUse: app)),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FbProvider>().setInstanceFromStorage().then((value) {
      context.read<ExamProvider>().retrieveExams();
      context.read<CourseProvider>().retrieveCourses();
    });
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      locale: context.watch<SettingsProvider>().getLocale(),
      theme: myLightTheme,
      darkTheme: myDarkTheme,
      themeMode: context.watch<SettingsProvider>().getThemeMode(),
      routerConfig: router,
    );
  }
}
