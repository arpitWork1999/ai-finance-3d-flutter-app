/// Price details of one stock.
class StockQuote {
  final String symbol;
  final String companyName;
  final double currentPrice;
  final double change;
  final double changePercent;
  final double highPrice;
  final double lowPrice;
  final double openPrice;
  final double previousClose;
  final DateTime lastUpdated;

  const StockQuote({
    required this.symbol,
    required this.companyName,
    required this.currentPrice,
    required this.change,
    required this.changePercent,
    required this.highPrice,
    required this.lowPrice,
    required this.openPrice,
    required this.previousClose,
    required this.lastUpdated,
  });

  bool get isPositive => change >= 0;

  /// Builds a quote from the Finnhub /quote response.
  /// Example: {"c":349.51,"d":17.61,"dp":5.30,"h":354.5,"l":340.99,"o":341.56,"pc":331.9,"t":1793826000}
  factory StockQuote.fromJson({
    required String symbol,
    required String companyName,
    required Map<String, dynamic> json,
  }) {
    return StockQuote(
      symbol: symbol,
      companyName: companyName,
      currentPrice: _toDouble(json['c']),
      change: _toDouble(json['d']),
      changePercent: _toDouble(json['dp']),
      highPrice: _toDouble(json['h']),
      lowPrice: _toDouble(json['l']),
      openPrice: _toDouble(json['o']),
      previousClose: _toDouble(json['pc']),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(
        (json['t'] as num? ?? 0).toInt() * 1000,
      ),
    );
  }

  /// Returns a new quote with the latest live trade price.
  /// Change is always measured against the previous day's close.
  StockQuote updatePrice(double newPrice, DateTime tradeTime) {
    final newChange = newPrice - previousClose;
    return StockQuote(
      symbol: symbol,
      companyName: companyName,
      currentPrice: newPrice,
      change: newChange,
      changePercent: previousClose == 0 ? 0 : (newChange / previousClose) * 100,
      highPrice: newPrice > highPrice ? newPrice : highPrice,
      lowPrice: newPrice < lowPrice ? newPrice : lowPrice,
      openPrice: openPrice,
      previousClose: previousClose,
      lastUpdated: tradeTime,
    );
  }

  static double _toDouble(dynamic value) => (value as num? ?? 0).toDouble();
}
