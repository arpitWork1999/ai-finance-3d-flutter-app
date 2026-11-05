/// All texts shown in the app, in one place.
///
/// Texts with a value inside them are small functions,
/// e.g. AppStrings.updatedAt('10:30').
class AppStrings {
  // ---------------- App ----------------
  static const String appName = 'AI Finance App';
  static const String retry = 'Retry';

  // ---------------- No internet dialog ----------------
  static const String offlineTitle = "You're offline";
  static const String offlineMessage =
      'Your mobile data or Wi-Fi is turned off. Please turn it on to '
      'continue.';
  static const String waitingForConnection =
      "Waiting for connection... We'll reload as soon as you're back online.";

  // ---------------- Bottom tabs ----------------
  static const String marketTab = 'Market';
  static const String vastuTab = 'Vastu 3D';

  // ---------------- Market ----------------
  static const String marketTitle = 'Market';
  static const String marketClosed = 'Market closed';
  static const String live = 'Live';
  static const String connecting = 'Connecting';
  static const String open = 'Open';
  static const String high = 'High';
  static const String low = 'Low';
  static const String previousClose = 'Prev close';
  static const String viewAiAnalysis = 'View AI analysis ›';
  static const String finnhubAttribution = 'Market data provided by Finnhub.io';
  static const String apiKeyMissing =
      'API key missing.\nAdd FINNHUB_API_KEY to the .env file.';
  static String updatedAt(String time) => 'Updated $time';

  // ---------------- Stock analysis ----------------
  static const String analysing = 'AI is analysing the last 100 days...';
  static const String last100Days = 'Last 100 trading days';
  static const String aiSummary = 'AI Summary';
  static const String keyPoints = 'Key Points';
  static const String outlook = 'Short-term Outlook';
  static const String indicators = 'Indicators';
  static String analysisTitle(String companyName) => '$companyName Analysis';
  static String riskLabel(String riskLevel) => '$riskLevel risk';
  static String bulletPoint(String text) => '•  $text';
  static String dataSources(String disclaimer, String dataAsOf) =>
      '$disclaimer\n'
      'Historical data: Alpha Vantage (as of $dataAsOf) · '
      'Analysis: Google Gemini';

  // Indicator names
  static const String average20Days = '20-day avg';
  static const String average50Days = '50-day avg';
  static const String rsi14 = 'RSI (14)';
  static const String oneWeek = '1 week';
  static const String oneMonth = '1 month';
  static const String threeMonths = '3 months';
  static const String volatility = 'Volatility';
  static const String high100Days = '100-day high';
  static const String low100Days = '100-day low';

  // ---------------- Errors ----------------
  static const String serverUnreachable =
      'Cannot reach the analysis server.\n'
      'Start it with: cd server && npm start';
  static const String analysisFailed = 'Analysis failed';
  static const String invalidApiKey = 'Invalid API key';
  static const String tooManyRequests =
      'Too many requests, please try again in a minute';
  static String noDataFound(String symbol) => 'No data found for $symbol';
  static String requestFailed(int statusCode) => 'Request failed ($statusCode)';

  // ---------------- Vastu ----------------
  static const String vastuTitle = 'Vastu 3D Home';
  static const String resetView = 'Reset view';
  static const String vastuApplied = 'Vastu Applied';
  static const String beforeVastu = 'Before Vastu';
  static const String topView = 'Top';
  static const String insideView = 'Inside';
  static const String topViewHint = 'Drag to rotate • Pinch to zoom';
  static const String insideViewHint =
      'Drag left/right to look • Drag up/down to walk';
  static const String applyVastu = 'Apply Vastu';
  static const String showBefore = 'Show Before';
  static const String walkthrough = 'Walkthrough';
  static const String stop = 'Stop';
  static const String walkingMessage = 'Walking through the home...';
  static const String vastuAppliedMessage =
      'All items are placed as per Vastu. Tap an item below to see why.';
  static const String beforeVastuMessage =
      'This is a normal layout. Tap "Apply Vastu" to move every item to '
      'its right zone.';
  static String roomAndZone(String roomName, String zoneName) =>
      '$roomName • $zoneName zone';
  static String stepCounter(int step, int total) => '$step/$total';

  // Compass letters
  static const String north = 'N';
  static const String east = 'E';
  static const String south = 'S';
  static const String west = 'W';
}
