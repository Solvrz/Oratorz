import type { Committee } from "@/types/committee";
import type { Scorecard } from "@/types/scorecard";

const STORAGE_PREFIX = "oratorz_";

function getKey(key: string): string {
  return `${STORAGE_PREFIX}${key}`;
}

function read<T>(key: string): T | null {
  const raw = localStorage.getItem(getKey(key));
  if (!raw) return null;
  try {
    return JSON.parse(raw) as T;
  } catch {
    return null;
  }
}

function write(key: string, value: unknown): void {
  localStorage.setItem(getKey(key), JSON.stringify(value));
}

function remove(key: string): void {
  localStorage.removeItem(getKey(key));
}

// Setup committee
export function loadSetup(): Committee | null {
  return read<Committee>("setup-committee");
}

export function saveSetup(committee: Committee): void {
  write("setup-committee", committee);
}

export function clearSetup(): void {
  remove("setup-committee");
}

// Pinned committees
export function getPinned(): string[] {
  return read<string[]>("pinned") ?? [];
}

export function setPinned(pinned: string[]): void {
  write("pinned", pinned);
}

// Committee data
export function committeeExists(id: string): boolean {
  return read(id) !== null;
}

export function getCommitteeData(id: string): Record<string, unknown> | null {
  return read<Record<string, unknown>>(id);
}

export function saveCommitteeData(
  id: string,
  data: Record<string, unknown>,
): void {
  write(id, data);
}

// Speech data
export function saveSpeech(
  committeeId: string,
  tag: string,
  speechData: unknown,
): void {
  const data = read<Record<string, unknown>>(committeeId) ?? {};
  data[tag] = speechData;
  write(committeeId, data);
}

export function updateSpeechField(
  committeeId: string,
  tag: string,
  key: string,
  value: unknown,
): void {
  const data = read<Record<string, unknown>>(committeeId);
  if (!data || !data[tag]) return;
  (data[tag] as Record<string, unknown>)[key] = value;
  write(committeeId, data);
}

export function loadSpeechData(
  committeeId: string,
  tag: string,
): Record<string, unknown> | null {
  const data = read<Record<string, unknown>>(committeeId);
  if (!data || !data[tag]) return null;
  return data[tag] as Record<string, unknown>;
}

// Vote data
export function saveVote(committeeId: string, voteData: unknown): void {
  const data = read<Record<string, unknown>>(committeeId) ?? {};
  data.vote = voteData;
  write(committeeId, data);
}

export function loadVoteData(
  committeeId: string,
): Record<string, unknown> | null {
  const data = read<Record<string, unknown>>(committeeId);
  if (!data || !data.vote) return null;
  return data.vote as Record<string, unknown>;
}

// Motions data
export function saveMotions(committeeId: string, motionsData: unknown): void {
  const data = read<Record<string, unknown>>(committeeId) ?? {};
  data.motions = motionsData;
  write(committeeId, data);
}

export function loadMotionsData(
  committeeId: string,
): Record<string, unknown> | null {
  const data = read<Record<string, unknown>>(committeeId);
  if (!data || !data.motions) return null;
  return data.motions as Record<string, unknown>;
}

// Scorecard data
export function saveScore(committeeId: string, scoreData: Scorecard): void {
  const data = read<Record<string, unknown>>(committeeId) ?? {};
  data.score = scoreData;
  write(committeeId, data);
}

export function loadScoreData(
  committeeId: string,
): Record<string, unknown> | null {
  const data = read<Record<string, unknown>>(committeeId);
  if (!data || !data.score) return null;
  return data.score as Record<string, unknown>;
}

// Clear all data
export function clearAllData(): void {
  const keys = Object.keys(localStorage).filter((k) =>
    k.startsWith(STORAGE_PREFIX),
  );
  keys.forEach((k) => localStorage.removeItem(k));
}
