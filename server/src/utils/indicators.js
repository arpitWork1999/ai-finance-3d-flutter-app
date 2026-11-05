/// Technical indicators calculated from daily history.
/// We calculate the numbers here (exact math) and let the AI
/// explain them, so the AI never has to guess numbers.

function round(value) {
  return Math.round(value * 100) / 100;
}

/// Simple Moving Average: average close of the last `days` days.
function simpleMovingAverage(closes, days) {
  if (closes.length < days) return null;
  const lastDays = closes.slice(-days);
  return lastDays.reduce((sum, close) => sum + close, 0) / days;
}

/// Relative Strength Index (14 days, Wilder's method).
/// Above 70 = overbought, below 30 = oversold.
function relativeStrengthIndex(closes, days = 14) {
  if (closes.length <= days) return null;

  let averageGain = 0;
  let averageLoss = 0;

  for (let i = 1; i <= days; i++) {
    const change = closes[i] - closes[i - 1];
    if (change > 0) averageGain += change;
    else averageLoss -= change;
  }
  averageGain /= days;
  averageLoss /= days;

  for (let i = days + 1; i < closes.length; i++) {
    const change = closes[i] - closes[i - 1];
    const gain = change > 0 ? change : 0;
    const loss = change < 0 ? -change : 0;
    averageGain = (averageGain * (days - 1) + gain) / days;
    averageLoss = (averageLoss * (days - 1) + loss) / days;
  }

  if (averageLoss === 0) return 100;
  const relativeStrength = averageGain / averageLoss;
  return 100 - 100 / (1 + relativeStrength);
}

/// % change between today and `days` trading days ago.
function percentChange(closes, days) {
  if (closes.length <= days) return null;
  const oldClose = closes[closes.length - 1 - days];
  const latestClose = closes[closes.length - 1];
  return ((latestClose - oldClose) / oldClose) * 100;
}

/// Annualized volatility in % (how much the price swings).
function annualizedVolatility(closes) {
  const dailyReturns = [];
  for (let i = 1; i < closes.length; i++) {
    dailyReturns.push((closes[i] - closes[i - 1]) / closes[i - 1]);
  }
  const mean = dailyReturns.reduce((sum, r) => sum + r, 0) / dailyReturns.length;
  const variance =
    dailyReturns.reduce((sum, r) => sum + (r - mean) ** 2, 0) / dailyReturns.length;
  return Math.sqrt(variance) * Math.sqrt(252) * 100; // 252 trading days/year
}

export function calculateIndicators(history) {
  const closes = history.map((day) => day.close);
  const volumes = history.map((day) => day.volume);

  const nullableRound = (value) => (value === null ? null : round(value));

  return {
    latestClose: round(closes[closes.length - 1]),
    sma20: nullableRound(simpleMovingAverage(closes, 20)),
    sma50: nullableRound(simpleMovingAverage(closes, 50)),
    rsi14: nullableRound(relativeStrengthIndex(closes)),
    change1Week: nullableRound(percentChange(closes, 5)),
    change1Month: nullableRound(percentChange(closes, 21)),
    change3Months: nullableRound(percentChange(closes, 63)),
    volatility: round(annualizedVolatility(closes)),
    periodHigh: round(Math.max(...history.map((day) => day.high))),
    periodLow: round(Math.min(...history.map((day) => day.low))),
    averageVolume20: Math.round(simpleMovingAverage(volumes, 20) ?? 0),
    latestVolume: volumes[volumes.length - 1],
  };
}
