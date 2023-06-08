import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:preptime/auth/auth.dart';
import 'package:preptime/l10n/l10n.dart';
import 'package:preptime/router/router.dart';
import 'package:preptime/services/course_provider.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:preptime/services/firebase_provider.dart';
import 'package:preptime/services/settings_provider.dart';
import 'package:preptime/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  // Initialize Firebase
  FirebaseApp app = await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyCH38zdmHoOLGop12VC2H4cg3Zj1MZBBZw',
    appId: '1:609123727992:web:c46ca5556a8ca2c4728b8d',
    messagingSenderId: '609123727992',
    projectId: 'preptime-bd',
    authDomain: "preptime-bd.firebaseapp.com",
    databaseURL:
        "https://preptime-bd-default-rtdb.asia-southeast1.firebasedatabase.app",
    storageBucket: "preptime-bd.appspot.com",
  ));
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
