import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/constants/api_constants.dart';

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

    // Finnhub also sends pings, skip those
    if (json['type'] != 'trade') return;

    // one message can carry several trades, we only need the latest per symbol
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
    // cancel first so onDisconnected doesn't fire when we close on purpose
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
  }
}
