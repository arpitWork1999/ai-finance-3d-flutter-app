import { config } from '../config.js';
import {
  getStockAnalysis,
  hasCachedAnalysis,
} from '../services/analysis.service.js';

/// Prepares the analysis of every tracked stock before users ask for it,
/// so tapping "View AI analysis" in the app opens instantly.
///
/// Runs when the server starts, then checks every 30 minutes.
/// A stock is only analysed if today's cache is missing, so this
/// covers both the new day and retrying when Gemini was busy.

const CHECK_INTERVAL = 30 * 60 * 1000; // 30 minutes
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

  // One at a time, to stay gentle on the free-tier limits.
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
