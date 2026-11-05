import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/constants/api_constants.dart';

/// Live trade prices from the Finnhub WebSocket.
///
/// Finnhub sends messages like:
/// {"type":"trade","data":[{"s":"AAPL","p":349.51,"t":1793878092287,"v":100}]}
/// The app connects only during regular US market hours.
class StockSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  Future<void> connect({
    required List<String> symbols,
    required void Function(String symbol, double price, DateTime time) onTrade,
    required void Function() onDisconnected,
  }) async {
    disconnect();

    final uri = Uri.parse(
      '${ApiConstants.socketUrl}?token=${ApiConstants.apiKey}',
    );
    _channel = WebSocketChannel.connect(uri);
    await _channel!.ready;

    for (final symbol in symbols) {
      _channel!.sink.add(jsonEncode({'type': 'subscribe', 'symbol': symbol}));
    }

    _subscription = _channel!.stream.listen(
      (message) => _handleMessage(message, onTrade),
      onError: (_) => onDisconnected(),
      onDone: onDisconnected,
    );
  }

  void _handleMessage(
    dynamic message,
    void Function(String symbol, double price, DateTime time) onTrade,
  ) {
    final json = jsonDecode(message as String) as Map<String, dynamic>;

    // Finnhub also sends {"type":"ping"} messages, which we skip.
    if (json['type'] != 'trade') return;

    // One message can hold many trades. We only need the
    // latest one of each stock, so later trades overwrite earlier ones.
    final latestTrades = <String, Map<String, dynamic>>{};
    for (final trade in json['data'] as List) {
      latestTrades[trade['s'] as String] = trade as Map<String, dynamic>;
    }

    latestTrades.forEach((symbol, trade) {
      onTrade(
        symbol,
        (trade['p'] as num).toDouble(),
        DateTime.fromMillisecondsSinceEpoch((trade['t'] as num).toInt()),
      );
    });
  }

  void disconnect() {
    // Cancel the listener first so onDisconnected is not called
    // when we close the socket on purpose.
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
  }
}
