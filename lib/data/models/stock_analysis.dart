/// AI analysis of one stock, returned by our Node server.
class StockAnalysis {
  final String symbol;
  final String dataAsOf;
  final String trend; // Bullish / Bearish / Neutral
  final String riskLevel; // Low / Medium / High
  final String summary;
  final List<String> keyPoints;
  final String outlook;
  final StockIndicators indicators;
  final List<PricePoint> priceHistory;
  final String disclaimer;

  const StockAnalysis({
    required this.symbol,
    required this.dataAsOf,
    required this.trend,
    required this.riskLevel,
    required this.summary,
    required this.keyPoints,
    required this.outlook,
    required this.indicators,
    required this.priceHistory,
    required this.disclaimer,
  });

  factory StockAnalysis.fromJson(Map<String, dynamic> json) {
    final analysis = json['analysis'] as Map<String, dynamic>;

    return StockAnalysis(
      symbol: json['symbol'] as String,
      dataAsOf: json['dataAsOf'] as String,
      trend: analysis['trend'] as String,
      riskLevel: analysis['riskLevel'] as String,
      summary: analysis['summary'] as String,
      keyPoints: List<String>.from(analysis['keyPoints'] as List),
      outlook: analysis['outlook'] as String,
      indicators: StockIndicators.fromJson(
        json['indicators'] as Map<String, dynamic>,
      ),
      priceHistory: (json['priceHistory'] as List)
          .map((point) => PricePoint.fromJson(point as Map<String, dynamic>))
          .toList(),
      disclaimer: json['disclaimer'] as String,
    );
  }
}

/// Numbers calculated by the server from the last 100 trading days.
class StockIndicators {
  final double? sma20;
  final double? sma50;
  final double? rsi14;
  final double? change1Week;
  final double? change1Month;
  final double? change3Months;
  final double volatility;
  final double periodHigh;
  final double periodLow;

  const StockIndicators({
    required this.sma20,
    required this.sma50,
    required this.rsi14,
    required this.change1Week,
    required this.change1Month,
    required this.change3Months,
    required this.volatility,
    required this.periodHigh,
    required this.periodLow,
  });

  factory StockIndicators.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic value) => (value as num?)?.toDouble();

    return StockIndicators(
      sma20: toDouble(json['sma20']),
      sma50: toDouble(json['sma50']),
      rsi14: toDouble(json['rsi14']),
      change1Week: toDouble(json['change1Week']),
      change1Month: toDouble(json['change1Month']),
      change3Months: toDouble(json['change3Months']),
      volatility: toDouble(json['volatility']) ?? 0,
      periodHigh: toDouble(json['periodHigh']) ?? 0,
      periodLow: toDouble(json['periodLow']) ?? 0,
    );
  }
}

/// One day's closing price, used for the chart.
class PricePoint {
  final String date;
  final double close;

  const PricePoint({required this.date, required this.close});

  factory PricePoint.fromJson(Map<String, dynamic> json) {
    return PricePoint(
      date: json['date'] as String,
      close: (json['close'] as num).toDouble(),
    );
  }
}
