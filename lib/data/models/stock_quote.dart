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

  // change is always measured from the previous close
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
