import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:tp3_flutter/presentation/pages/add_quizz_page.dart';
import 'package:tp3_flutter/presentation/pages/theme_choice_page.dart';

// Pages
import 'presentation/pages/auth_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/edit_profile_page.dart';
import 'package:tp3_flutter/presentation/pages/profile_card_page.dart';
import 'package:tp3_flutter/presentation/pages/quiz_bloc_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialise Firebase
  await FirebaseAppCheck.instance.activate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP3 Flutter Firebase',
      theme: ThemeData(primarySwatch: Colors.blue),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics), // Observer Analytics
      ],
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => AuthPage(),
        '/home': (context) => HomePage(),
        '/quiz': (context) => ThemeChoicePage(),
        '/edit_profile': (context) => EditProfilePage(),
        '/profile': (context) => ProfileHomePage(),
        '/edit_quizz': (context) => AddQuizzPage(),
      },
    );
  }
}
