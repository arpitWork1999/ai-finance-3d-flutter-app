// Render's free plan sleeps after 15 min idle, so we ping our own /health.
// RENDER_EXTERNAL_URL isn't set locally, so this does nothing there.

const PING_INTERVAL = 10 * 60 * 1000;

export function startKeepAwakeJob() {
  const publicUrl = process.env.RENDER_EXTERNAL_URL;
  if (!publicUrl) return;

  console.log(`Keep-awake: pinging ${publicUrl}/health every 10 minutes`);
  setInterval(() => pingHealth(publicUrl), PING_INTERVAL);
}

async function pingHealth(publicUrl) {
  try {
    await fetch(`${publicUrl}/health`);
  } catch (error) {
    console.warn(`Keep-awake: ping failed (${error.message})`);
  }
}
