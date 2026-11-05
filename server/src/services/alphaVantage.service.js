import { config } from '../config.js';
import { readCache, writeCache } from '../utils/cache.js';

const BASE_URL = 'https://www.alphavantage.co/query';

/// The free plan allows only 1 request per second, so we keep a gap
/// of 1.5 seconds between requests (warm-up asks for 5 stocks in a row).
const MIN_GAP_BETWEEN_REQUESTS = 1500; // milliseconds
let nextRequestTime = 0;

/// Waits until it is this request's turn.
/// The next time slot is reserved before waiting, so requests that
/// arrive at the same moment still go out one by one.
async function waitForTurn() {
  const now = Date.now();
  const waitTime = Math.max(0, nextRequestTime - now);
  nextRequestTime = Math.max(now, nextRequestTime) + MIN_GAP_BETWEEN_REQUESTS;

  if (waitTime > 0) {
    await new Promise((resolve) => setTimeout(resolve, waitTime));
  }
}

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

  await waitForTurn();
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
    const message = json['Note'] || json['Information'];
    // Alpha Vantage sometimes puts our API key in the message: hide it.
    const safeMessage = message.replaceAll(config.alphaVantageApiKey, '***');
    throw new Error(`Alpha Vantage: ${safeMessage}`);
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
