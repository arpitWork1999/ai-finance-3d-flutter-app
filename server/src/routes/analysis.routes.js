import { Router } from 'express';

import { getStockAnalysis } from '../services/analysis.service.js';

export const analysisRouter = Router();

/// GET /api/analysis/AAPL
/// Returns indicators, price history (for the chart) and the AI analysis.
/// Usually served from cache, because the warm-up job prepares it in advance.
analysisRouter.get('/:symbol', async (req, res) => {
  const symbol = req.params.symbol.toUpperCase();

  if (!/^[A-Z.]{1,10}$/.test(symbol)) {
    return res.status(400).json({ error: 'Invalid stock symbol' });
  }

  try {
    res.json(await getStockAnalysis(symbol));
  } catch (error) {
    console.error(`Analysis failed for ${symbol}:`, error.message);
    res.status(502).json({ error: error.message });
  }
});
