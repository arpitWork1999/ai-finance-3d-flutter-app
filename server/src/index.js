import express from 'express';

import { config } from './config.js';
import { startKeepAwakeJob } from './jobs/keepAwake.job.js';
import { startWarmUpJob } from './jobs/warmUp.job.js';
import { analysisRouter } from './routes/analysis.routes.js';

if (!config.twelveDataApiKey || !config.geminiApiKey) {
  console.error('Missing API keys. Add them to server/.env (see .env.example)');
  process.exit(1);
}

const app = express();

app.get('/health', (req, res) => res.json({ status: 'ok' }));
app.use('/api/analysis', analysisRouter);

app.listen(config.port, () => {
  console.log(`Server running on http://localhost:${config.port}`);
  startWarmUpJob();
  startKeepAwakeJob();
});
