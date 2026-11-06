import { config } from '../config.js';
import { readCache, writeCache } from '../utils/cache.js';

const BASE_URL = 'https://api.twelvedata.com/time_series';

// free plan: 800 requests/day, counted per key
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

  // errors come back as status: 'error' with a message
  if (!response.ok || json.status === 'error') {
    if (!json.message) {
      throw new Error(`Twelve Data request failed (${response.status})`);
    }
    // just in case the key shows up in the message
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
