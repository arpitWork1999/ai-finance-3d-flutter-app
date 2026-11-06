# AI Finance App

A Flutter app with two parts:

1. **Market**: live US stock prices with an AI analysis of each stock.
2. **Vastu 3D**: a 3D home that shows furniture placed as per Vastu Shastra, with a guided walkthrough.

📹 **Demo video:** [vastu_walkthrough.mp4](vastu_walkthrough.mp4)

---

## Features

### 📈 Market
- Live prices for NVIDIA, Microsoft, Apple, Amazon and Tesla
- Prices load once (REST API), then update in real time (WebSocket) during US market hours
- Shows the market status: **Live**, **Connecting** or **Market closed**
- Tap a stock to open its **AI analysis**:
  - Price chart of the last 100 trading days
  - Trend (Bullish / Bearish) and risk level
  - AI summary, key points and short-term outlook
  - Indicators: moving averages, RSI, volatility, 100-day high/low

### 🏠 Vastu 3D Home
- A 9-room home: each room is one of the 9 Vastu zones (NE, N, E, SE, S, SW, W, NW and the open centre, Brahmasthan)
- Compound wall, entry gate, stone path and a fountain in the front garden
- **Before / After Vastu**: furniture slides from common wrong places to its correct Vastu zone
- **Top view**: rotate and zoom around the whole home
- **Inside view**: walk through the home at eye level
- **Walkthrough**: the camera enters through the gate and walks room by room, explaining why each item belongs in its zone
- Tap any item to see its room, zone and Vastu reason

### ⚙️ General
- Offline dialog when Wi-Fi and mobile data are off; data reloads automatically when you're back online
- Clean, minimal theme with one indigo accent colour

---

## How the 3D works

The 3D home is drawn with **Flutter's `CustomPainter`**, using no 3D packages or 3D model files. The engine is a few small files in `lib/modules/vastu/scene/`:

| Step | What happens |
|------|--------------|
| **Projection** | Each 3D point is rotated by the camera angle, then divided by its depth, so far things look smaller |
| **Hiding faces** | A face is drawn only if it points towards the camera |
| **Draw order** | Far faces are drawn first and near faces on top (the painter's algorithm) |
| **Near-plane clipping** | Parts of a wall behind the camera are cut off, which makes the inside view work |

The same camera is used for both views: **top view** circles around the home, and **inside view** is the same camera at distance 0, so it only turns its head.

---

## Tech stack

| Part | Used |
|------|------|
| App | Flutter, GetX (state, routes, bindings) |
| Stock prices | [Finnhub](https://finnhub.io) REST + WebSocket |
| AI analysis | Node.js (Express) server, [Twelve Data](https://twelvedata.com) data, [Google Gemini](https://aistudio.google.com) |
| Charts | fl_chart |
| Network status | connectivity_plus |
| Config | flutter_dotenv (`.env` file) |

---

## Folder structure

```
lib/
  core/
    constants/     app colors, app strings, API & Vastu constants, furniture shapes
    theme/         app theme
    widgets/       shared widgets (offline dialog)
  data/
    models/        stock, analysis, furniture and Vastu zone models
    services/      Finnhub, analysis server and connectivity services
  modules/         one folder per screen (binding / controller / view)
    dashboard/     bottom tabs
    market/
    stock_analysis/
    vastu/
      scene/       3D engine: point, camera, faces, house layout, tour route
      widgets/     3D painter, info card, furniture list
  routes/

server/            Node.js server for the AI analysis
  src/
    routes/        /api/analysis/:symbol
    services/      Twelve Data, Gemini, analysis
    utils/         indicators and daily cache
```

---

## Setup

API keys are **not** in the repo. Copy the example files and add your own keys.

### 1. App keys

```bash
cp .env.example .env
```

Add your Finnhub key to `.env`.

> On a **real phone**, change `ANALYSIS_SERVER_URL` to your computer's Wi-Fi IP, e.g. `http://192.168.1.10:3000`. The phone and the computer must be on the same Wi-Fi.

### 2. AI analysis server

```bash
cd server
cp .env.example .env
npm install
npm start
```

Add your Twelve Data and Gemini keys to `server/.env`. The server runs on port `3000`.

### 3. Run the app

```bash
flutter pub get
flutter run
```

---

## Deploy the server (Render, free)

The repo has a `render.yaml`, so Render sets up the server for you.

1. Push this repo to GitHub.
2. On [render.com](https://render.com), go to **New → Blueprint** and pick this repo.
3. Enter your `TWELVE_DATA_API_KEY` and `GEMINI_API_KEY` when asked, then deploy.
4. Open `https://<your-service>.onrender.com/health`. It should show `{"status":"ok"}`.
5. In the app's `.env`, set:
   ```
   ANALYSIS_SERVER_URL=https://<your-service>.onrender.com
   ```

> The free plan sleeps after 15 minutes without traffic. To avoid that, the server pings its own `/health` page every 10 minutes when it runs on Render (`server/src/jobs/keepAwake.job.js`). Locally this job is off.

---

## Disclaimer

The AI analysis is for learning purposes only and is not financial advice. Vastu tips are general, commonly followed guidelines.
