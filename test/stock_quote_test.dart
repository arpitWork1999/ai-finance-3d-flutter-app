import 'package:flutter_test/flutter_test.dart';

import 'package:ai_finance_app/data/models/stock_quote.dart';

void main() {
  final quote = StockQuote.fromJson(
    symbol: 'AAPL',
    companyName: 'Apple',
    json: {
      'c': 105.0,
      'd': 5.0,
      'dp': 5.0,
      'h': 110.0,
      'l': 95.0,
      'o': 100.0,
      'pc': 100.0,
      't': 1793826000,
    },
  );

  test('fromJson reads the Finnhub quote fields', () {
    expect(quote.currentPrice, 105.0);
    expect(quote.previousClose, 100.0);
    expect(quote.isPositive, true);
  });

  test('updatePrice recalculates change from previous close', () {
    final updated = quote.updatePrice(90.0, DateTime(2026));

    expect(updated.currentPrice, 90.0);
    expect(updated.change, -10.0);
    expect(updated.changePercent, -10.0);
    expect(updated.lowPrice, 90.0); // new day low
    expect(updated.highPrice, 110.0); // unchanged
    expect(updated.isPositive, false);
  });
}
