import fs from 'node:fs';
import path from 'node:path';

/// Very small file cache that keeps data for one day.
///
/// Alpha Vantage free plan allows only 25 requests per day, so we save
/// each response in server/cache/<name>-<date>.json and reuse it.
/// Files survive server restarts. Files from older days are deleted.

const cacheFolder = path.join(import.meta.dirname, '..', '..', 'cache');

function todayDate() {
  return new Date().toISOString().slice(0, 10); // e.g. 2026-11-05
}

function cacheFilePath(name) {
  return path.join(cacheFolder, `${name}-${todayDate()}.json`);
}

export function readCache(name) {
  const filePath = cacheFilePath(name);
  if (!fs.existsSync(filePath)) return null;
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

export function writeCache(name, data) {
  fs.mkdirSync(cacheFolder, { recursive: true });
  fs.writeFileSync(cacheFilePath(name), JSON.stringify(data, null, 2));
  deleteOldCacheFiles();
}

/// Removes files that are not from today, e.g. history-AAPL-2026-11-04.json
function deleteOldCacheFiles() {
  const todaySuffix = `-${todayDate()}.json`;

  for (const fileName of fs.readdirSync(cacheFolder)) {
    if (!fileName.endsWith(todaySuffix)) {
      fs.unlinkSync(path.join(cacheFolder, fileName));
    }
  }
}
