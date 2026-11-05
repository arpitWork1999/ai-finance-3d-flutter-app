import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/stock_analysis.dart';
import '../../core/constants/app_strings.dart';

/// Calls our Node server (server/ folder) for the AI analysis.
class AnalysisApiService {
  // Gemini can take a while, and the server may try several models.
  static const Duration _timeout = Duration(seconds: 150);

  Future<StockAnalysis> getAnalysis(String symbol) async {
    final uri = Uri.parse(
      '${ApiConstants.analysisServerUrl}/api/analysis/$symbol',
    );

    final http.Response response;
    try {
      response = await http.get(uri).timeout(_timeout);
    } catch (_) {
      throw Exception(AppStrings.serverUnreachable);
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(json['error'] ?? AppStrings.analysisFailed);
    }

    return StockAnalysis.fromJson(json);
  }
}
