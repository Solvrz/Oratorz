import { Timestamp } from "firebase/firestore";
import type { Committee } from "./committee";

export interface User {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  createdAt: number;
  committees: Committee[];
  committeeIds: string[];
}

export function createUser(overrides: {
  firstName: string;
  lastName: string;
  email: string;
  id?: string;
  createdAt?: number;
  committees?: Committee[];
  committeeIds?: string[];
}): User {
  return {
    id: overrides.id ?? generateId(),
    firstName: overrides.firstName,
    lastName: overrides.lastName,
    email: overrides.email,
    createdAt: overrides.createdAt ?? Date.now(),
    committees: overrides.committees ?? [],
    committeeIds: overrides.committeeIds ?? [],
  };
}

export function userFromJson(data: Record<string, unknown>): User {
  const raw = data.createdAt;
  let createdAt: number;
  if (raw instanceof Timestamp) {
    createdAt = raw.toMillis();
  } else if (typeof raw === "number") {
    createdAt = raw;
  } else {
    createdAt = Date.now();
  }
  return {
    id: (data.id as string) ?? "",
    firstName: (data.firstName as string) ?? "",
    lastName: (data.lastName as string) ?? "",
    email: (data.email as string) ?? "",
    createdAt,
    committees: [],
    committeeIds: (data.committees as string[]) ?? [],
  };
}

export function userToJson(user: User): Record<string, unknown> {
  return {
    id: user.id,
    firstName: user.firstName,
    lastName: user.lastName,
    email: user.email,
    createdAt: Timestamp.fromMillis(user.createdAt),
    committees: user.committeeIds,
  };
}

function generateId(): string {
  return (Math.floor(Math.random() * 1e8) + 1e8).toString();
}
