import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/stock_quote.dart';
import '../../core/constants/app_strings.dart';

class StockApiService {
  static const Duration _timeout = Duration(seconds: 30);

  Future<StockQuote> getQuote(String symbol, String companyName) async {
    final json = await _get('/quote', {'symbol': symbol});

    // Finnhub returns 0 for an unknown symbol instead of an error.
    if (json['c'] == 0) {
      throw Exception(AppStrings.noDataFound(symbol));
    }

    return StockQuote.fromJson(
      symbol: symbol,
      companyName: companyName,
      json: json,
    );
  }

  Future<List<StockQuote>> getQuotes(Map<String, String> stocks) {
    return Future.wait(
      stocks.entries.map((stock) => getQuote(stock.key, stock.value)),
    );
  }

  Future<bool> isMarketOpen() async {
    final json = await _get('/stock/market-status', {'exchange': 'US'});
    return json['isOpen'] == true;
  }

  Future<Map<String, dynamic>> _get(
    String path,
    Map<String, String> queryParams,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}$path',
    ).replace(queryParameters: {...queryParams, 'token': ApiConstants.apiKey});

    final response = await http.get(uri).timeout(_timeout);

    if (response.statusCode == 401) {
      throw Exception(AppStrings.invalidApiKey);
    }
    if (response.statusCode == 429) {
      throw Exception(AppStrings.tooManyRequests);
    }
    if (response.statusCode != 200) {
      throw Exception(AppStrings.requestFailed(response.statusCode));
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
