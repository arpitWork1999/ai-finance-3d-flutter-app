import { GoogleGenAI, Type } from '@google/genai';

import { config } from '../config.js';

const ai = new GoogleGenAI({
  apiKey: config.geminiApiKey,
  // Don't keep retrying a busy model, switch to the fallback model instead.
  httpOptions: { timeout: 30000, retryOptions: { attempts: 1 } },
});

const systemInstruction = `
You are a stock market analyst writing for a mobile app.
Use ONLY the data given to you. Do not invent news, earnings or numbers.
Explain in simple English that a beginner can understand.
This is educational analysis, not financial advice:
never tell the user to buy or sell.
`;

const analysisSchema = {
  type: Type.OBJECT,
  properties: {
    trend: {
      type: Type.STRING,
      enum: ['Bullish', 'Bearish', 'Neutral'],
      description: 'Overall direction of the stock based on the data',
    },
    riskLevel: {
      type: Type.STRING,
      enum: ['Low', 'Medium', 'High'],
      description: 'Based mainly on volatility and recent price swings',
    },
    summary: {
      type: Type.STRING,
      description: '2-3 sentence overview of how the stock has been doing',
    },
    keyPoints: {
      type: Type.ARRAY,
      items: { type: Type.STRING },
      description: '3 to 4 short observations, each mentioning a number',
    },
    outlook: {
      type: Type.STRING,
      description: 'What to watch in the short term (1-2 sentences)',
    },
  },
  required: ['trend', 'riskLevel', 'summary', 'keyPoints', 'outlook'],
};

export async function generateStockAnalysis(symbol, indicators, history) {
  const last30Days = history
    .slice(-30)
    .map((day) => `${day.date}: ${day.close}`)
    .join('\n');

  const prompt = `
Analyse ${symbol} using this data from the last 100 trading days.

Indicators:
${JSON.stringify(indicators, null, 2)}

(sma = simple moving average in USD, rsi14 = 14-day RSI,
change values are in %, volatility is annualized %,
periodHigh/periodLow are the 100-day high and low)

Closing prices of the last 30 trading days:
${last30Days}
`;

  // free models are often busy, so fall back through the list and retry once
  const maxRounds = 2;
  let lastError;

  for (let round = 1; round <= maxRounds; round++) {
    if (round > 1) await wait(5000);

    for (const model of config.geminiModels) {
      try {
        const response = await ai.models.generateContent({
          model,
          contents: prompt,
          config: {
            systemInstruction,
            responseMimeType: 'application/json',
            responseSchema: analysisSchema,
          },
        });
        console.log(`Analysis for ${symbol} written by ${model}`);
        return JSON.parse(response.text);
      } catch (error) {
        lastError = error;
        console.warn(`Gemini model ${model} failed: ${readableError(error)}`);
      }
    }
  }

  const message = readableError(lastError);
  if (message.includes('high demand') || message.includes('Deadline')) {
    throw new Error('The AI service is busy right now. Please try again in a minute.');
  }
  throw new Error(`Gemini: ${message}`);
}

function wait(milliseconds) {
  return new Promise((resolve) => setTimeout(resolve, milliseconds));
}

// errors arrive as a JSON string
function readableError(error) {
  try {
    return JSON.parse(error.message).error.message;
  } catch {
    return error.message;
  }
}
