import { db } from "@/config/firebase";
import {
  committeeFromJson,
  committeeToJson,
  type Committee,
} from "@/types/committee";
import type { User } from "@/types/user";
import { userToJson } from "@/types/user";
import { deleteDoc, doc, getDoc, setDoc } from "firebase/firestore";

export async function updateUserInCloud(user: User): Promise<void> {
  await setDoc(doc(db, "users", user.email), userToJson(user));
}

export async function createCommitteeInCloud(
  committee: Committee,
  user: User,
): Promise<void> {
  await setDoc(doc(db, "committees", committee.id), committeeToJson(committee));
  await updateUserInCloud(user);
}

export async function deleteCommitteeFromCloud(
  committee: Committee,
  user: User,
): Promise<void> {
  await deleteDoc(doc(db, "committees", committee.id));
  await updateUserInCloud(user);
}

export async function fetchCommittee(id: string): Promise<Committee | null> {
  const snap = await getDoc(doc(db, "committees", id));
  if (!snap.exists()) return null;
  return committeeFromJson(snap.data() as Record<string, unknown>);
}
