export function formatDuration(totalSeconds: number): string {
  const hours = Math.floor(totalSeconds / 3600);
  const minutes = Math.floor((totalSeconds % 3600) / 60);
  const seconds = totalSeconds % 60;

  const hh = hours > 0 ? `${String(hours).padStart(2, "0")}:` : "";
  const mm = `${String(minutes).padStart(2, "0")}:`;
  const ss = String(seconds).padStart(2, "0");

  return `${hh}${mm}${ss}`;
}

export function formatDate(timestamp: number): string {
  const d = new Date(timestamp);
  return `${d.getDate()}/${d.getMonth() + 1}/${d.getFullYear()}`;
}

export function capitalize(s: string): string {
  if (!s) return s;
  return s[0].toUpperCase() + s.slice(1);
}
