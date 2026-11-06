import { getDailyHistory } from './twelveData.service.js';
import { generateStockAnalysis } from './gemini.service.js';
import { calculateIndicators } from '../utils/indicators.js';
import { readCache, writeCache } from '../utils/cache.js';

// if warm-up and a user ask for the same stock together, both wait on one request
const inProgress = new Map();

export function getStockAnalysis(symbol) {
  const cached = readCache(analysisCacheName(symbol));
  if (cached) return Promise.resolve(cached);

  if (!inProgress.has(symbol)) {
    const request = buildAnalysis(symbol).finally(() => inProgress.delete(symbol));
    inProgress.set(symbol, request);
  }
  return inProgress.get(symbol);
}

export function hasCachedAnalysis(symbol) {
  return readCache(analysisCacheName(symbol)) !== null;
}

function analysisCacheName(symbol) {
  return `analysis-${symbol}`;
}

async function buildAnalysis(symbol) {
  const history = await getDailyHistory(symbol);
  const indicators = calculateIndicators(history);
  const analysis = await generateStockAnalysis(symbol, indicators, history);

  const result = {
    symbol,
    dataAsOf: history[history.length - 1].date,
    generatedAt: new Date().toISOString(),
    indicators,
    priceHistory: history.map((day) => ({ date: day.date, close: day.close })),
    analysis,
    sources: {
      historicalData: 'Twelve Data',
      analysis: 'Google Gemini',
    },
    disclaimer:
      'AI-generated analysis for educational purposes only. Not financial advice.',
  };

  writeCache(analysisCacheName(symbol), result);
  return result;
}
