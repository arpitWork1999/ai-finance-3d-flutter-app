import { config } from '../config.js';
import { readCache, writeCache } from '../utils/cache.js';

const BASE_URL = 'https://www.alphavantage.co/query';

/// Gets the last 100 trading days of a stock (oldest first).
/// Each day: { date, open, high, low, close, volume }
export async function getDailyHistory(symbol) {
  const cacheName = `history-${symbol}`;
  const cached = readCache(cacheName);
  if (cached) return cached;

  const url = new URL(BASE_URL);
  url.searchParams.set('function', 'TIME_SERIES_DAILY');
  url.searchParams.set('symbol', symbol);
  url.searchParams.set('outputsize', 'compact'); // last 100 days (free)
  url.searchParams.set('apikey', config.alphaVantageApiKey);

  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Alpha Vantage request failed (${response.status})`);
  }

  const json = await response.json();

  // Alpha Vantage returns status 200 even for errors,
  // so we check the body for these fields.
  if (json['Error Message']) {
    throw new Error(`Unknown symbol: ${symbol}`);
  }
  // Used for rate limits and key problems, e.g. "25 requests per day".
  if (json['Note'] || json['Information']) {
    throw new Error(`Alpha Vantage: ${json['Note'] || json['Information']}`);
  }

  const timeSeries = json['Time Series (Daily)'];
  if (!timeSeries) {
    throw new Error('No historical data received from Alpha Vantage');
  }

  const history = Object.entries(timeSeries)
    .map(([date, day]) => ({
      date,
      open: Number(day['1. open']),
      high: Number(day['2. high']),
      low: Number(day['3. low']),
      close: Number(day['4. close']),
      volume: Number(day['5. volume']),
    }))
    .sort((a, b) => a.date.localeCompare(b.date));

  writeCache(cacheName, history);
  return history;
}
