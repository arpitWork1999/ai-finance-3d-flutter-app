import dotenv from 'dotenv';

dotenv.config({ quiet: true });

/// All server settings, read from server/.env
export const config = {
  port: Number(process.env.PORT) || 3000,

  // Stocks shown in the app. Their analysis is prepared in advance.
  trackedStocks: ['NVDA', 'MSFT', 'AAPL', 'AMZN', 'TSLA'],

  alphaVantageApiKey: process.env.ALPHA_VANTAGE_API_KEY,
  geminiApiKey: process.env.GEMINI_API_KEY,
  // Tried in order: if one model is busy, the next one is used.
  geminiModels: (
    process.env.GEMINI_MODELS ||
    'gemini-flash-latest,gemini-3.5-flash,gemini-flash-lite-latest'
  )
    .split(',')
    .map((model) => model.trim()),
};
