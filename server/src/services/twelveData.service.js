import { config } from '../config.js';
import { readCache, writeCache } from '../utils/cache.js';

const BASE_URL = 'https://api.twelvedata.com/time_series';

/// Gets the last 100 trading days of a stock (oldest first).
/// Each day: { date, open, high, low, close, volume }
///
/// Free plan: 800 requests per day and 8 per minute, counted per key.
/// The warm-up asks for 5 stocks once a day, so this is plenty.
export async function getDailyHistory(symbol) {
  const cacheName = `history-${symbol}`;
  const cached = readCache(cacheName);
  if (cached) return cached;

  const url = new URL(BASE_URL);
  url.searchParams.set('symbol', symbol);
  url.searchParams.set('interval', '1day');
  url.searchParams.set('outputsize', '100');
  url.searchParams.set('apikey', config.twelveDataApiKey);

  const response = await fetch(url);
  const json = await response.json().catch(() => ({}));

  // Bad symbols, rate limits and key problems come back with
  // status "error" and a message explaining why.
  if (!response.ok || json.status === 'error') {
    if (!json.message) {
      throw new Error(`Twelve Data request failed (${response.status})`);
    }
    // Hide our API key in case it appears in the message.
    const safeMessage = String(json.message).replaceAll(
      config.twelveDataApiKey,
      '***',
    );
    throw new Error(`Twelve Data: ${safeMessage}`);
  }

  if (!Array.isArray(json.values) || json.values.length === 0) {
    throw new Error('No historical data received from Twelve Data');
  }

  const history = json.values
    .map((day) => ({
      date: day.datetime,
      open: Number(day.open),
      high: Number(day.high),
      low: Number(day.low),
      close: Number(day.close),
      volume: Number(day.volume),
    }))
    .sort((a, b) => a.date.localeCompare(b.date));

  writeCache(cacheName, history);
  return history;
}
