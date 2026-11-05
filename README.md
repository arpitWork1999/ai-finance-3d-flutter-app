# AI Finance App

A Flutter app (GetX) with two parts:

- **Market** – live US stock prices (Finnhub) and an AI analysis of the last 100 days (Alpha Vantage + Google Gemini, through a small Node.js server).
- **Vastu 3D** – a 3D home drawn with a hand-written CustomPainter engine. Shows furniture placed as per Vastu, with a top view, an inside view and a guided walkthrough.

## Setup

API keys are not in the repo. Copy the example files and add your own keys.

### 1. App

```bash
cp .env.example .env
```

Add your Finnhub key (https://finnhub.io) to `.env`.

On a real phone, set `ANALYSIS_SERVER_URL` to your computer's Wi-Fi IP, e.g. `http://192.168.1.10:3000`.

### 2. AI analysis server

```bash
cd server
cp .env.example .env
npm install
npm start
```

Add your Alpha Vantage and Gemini keys to `server/.env`.

### 3. Run the app

```bash
flutter pub get
flutter run
```
