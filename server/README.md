# AI Finance Server

Node.js backend that gives the Flutter app an AI analysis of a stock.

```
Twelve Data (last 100 daily prices)
      ↓
indicators.js (moving averages, RSI, % change, volatility)
      ↓
Google Gemini (writes the analysis as JSON)
      ↓
GET /api/analysis/:symbol  →  Flutter app
```

## Run

```bash
cd server
npm install
cp .env.example .env   # add your Twelve Data + Gemini keys
npm start              # http://localhost:3000
```

Try it: http://localhost:3000/api/analysis/AAPL

## Folder structure

```
src/
  index.js                     Express app + routes
  config.js                    reads .env
  routes/analysis.routes.js    GET /api/analysis/:symbol
  jobs/warmUp.job.js           prepares all analyses in advance
  jobs/keepAwake.job.js        keeps the server awake on Render
  services/analysis.service.js       builds + caches one analysis
  services/twelveData.service.js     historical daily prices
  services/gemini.service.js         AI analysis
  utils/indicators.js          technical indicators
  utils/cache.js               saves responses for the day
```

Responses are cached in `cache/` for one day, so each stock needs only
one Twelve Data request and one Gemini call per day. Older files are deleted automatically.

The warm-up job runs on start and every 30 minutes, and prepares any
stock whose analysis for today is missing. So users never wait for the AI,
and a failed attempt (e.g. Gemini busy) is retried automatically.
