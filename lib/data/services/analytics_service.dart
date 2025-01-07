import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  void logScore(int score) {
    _analytics.logEvent(name: 'quiz_score', parameters: {'score': score});
  }

  void setFavoriteTheme(String theme) {
    _analytics.setUserProperty(name: 'favorite_theme', value: theme);
  }
}
