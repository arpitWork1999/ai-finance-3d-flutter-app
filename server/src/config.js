import dotenv from 'dotenv';

dotenv.config({ quiet: true });

export const config = {
  port: Number(process.env.PORT) || 3000,

  // analyses for these are prepared in advance
  trackedStocks: ['NVDA', 'MSFT', 'AAPL', 'AMZN', 'TSLA'],

  twelveDataApiKey: process.env.TWELVE_DATA_API_KEY,
  geminiApiKey: process.env.GEMINI_API_KEY,
  // tried in order if one is busy
  geminiModels: (
    process.env.GEMINI_MODELS ||
    'gemini-flash-latest,gemini-3.5-flash,gemini-flash-lite-latest'
  )
    .split(',')
    .map((model) => model.trim()),
};
