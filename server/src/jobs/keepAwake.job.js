/// Keeps the server awake on Render's free plan.
///
/// Render puts a free server to sleep after 15 minutes without traffic.
/// When it sleeps, the first request is slow and today's cache is lost.
/// So the server opens its own /health page every 10 minutes.
///
/// Render sets RENDER_EXTERNAL_URL (e.g. https://my-app.onrender.com).
/// When running locally it is not set, so this job does nothing.

const PING_INTERVAL = 10 * 60 * 1000; // 10 minutes

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
