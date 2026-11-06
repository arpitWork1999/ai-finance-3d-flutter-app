import { config } from '../config.js';
import {
  getStockAnalysis,
  hasCachedAnalysis,
} from '../services/analysis.service.js';

// only stocks without today's cache, so this also retries after Gemini was busy

const CHECK_INTERVAL = 30 * 60 * 1000;
let isRunning = false;

export function startWarmUpJob() {
  warmUpMissingAnalyses();
  setInterval(warmUpMissingAnalyses, CHECK_INTERVAL);
}

async function warmUpMissingAnalyses() {
  if (isRunning) return;
  isRunning = true;

  const missing = config.trackedStocks.filter((s) => !hasCachedAnalysis(s));
  if (missing.length > 0) {
    console.log(`Warm-up: preparing analysis for ${missing.join(', ')}`);
  }

  // one at a time to stay within the free limits
  for (const symbol of missing) {
    try {
      await getStockAnalysis(symbol);
      console.log(`Warm-up: ${symbol} ready`);
    } catch (error) {
      console.warn(`Warm-up: ${symbol} failed, will retry later (${error.message})`);
    }
  }

  isRunning = false;
}
