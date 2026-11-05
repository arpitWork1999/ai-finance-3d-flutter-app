import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API settings, read from the .env file (loaded in main.dart).
class ApiConstants {
  static String get apiKey => _read('FINNHUB_API_KEY');

  static const String baseUrl = 'https://finnhub.io/api/v1';
  static const String socketUrl = 'wss://ws.finnhub.io';

  /// Our own Node.js server (server/ folder) for the AI analysis.
  static String get analysisServerUrl {
    final url = _read('ANALYSIS_SERVER_URL');
    // The Android emulator reaches the computer's localhost via 10.0.2.2
    if (Platform.isAndroid) return url.replaceFirst('localhost', '10.0.2.2');
    return url;
  }

  static String _read(String name) =>
      dotenv.isInitialized ? dotenv.maybeGet(name) ?? '' : '';
}
