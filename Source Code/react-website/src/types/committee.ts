export const RollCall = {
  presentAndVoting: 2,
  present: 1,
  absent: 0,
  none: -1,
} as const;

export type RollCallValue = (typeof RollCall)[keyof typeof RollCall];

export interface Committee {
  id: string;
  type: string;
  name: string;
  agenda: string;
  createdAt: Date | null;
  delegates: string[];
  rollCall: Record<string, RollCallValue>;
  members: string[];
  days: (Date | null)[];
}

export function createCommittee(overrides?: Partial<Committee>): Committee {
  const delegates = overrides?.delegates ?? [];
  return {
    id: overrides?.id ?? generateId(),
    type: overrides?.type ?? "Custom",
    name: overrides?.name ?? "Your Committee",
    agenda: overrides?.agenda ?? "Your Agenda",
    delegates,
    rollCall:
      overrides?.rollCall ??
      Object.fromEntries(delegates.map((d) => [d, RollCall.none])),
    members: overrides?.members ?? [],
    days: overrides?.days ?? [],
    createdAt: overrides?.createdAt ?? new Date(),
  };
}

export function initRollCall(
  committee: Committee,
): Record<string, RollCallValue> {
  return Object.fromEntries(committee.delegates.map((d) => [d, RollCall.none]));
}

export function getAbsentDelegates(committee: Committee): string[] {
  return committee.delegates.filter(
    (d) => committee.rollCall[d] === RollCall.absent,
  );
}

export function getPresentDelegates(committee: Committee): string[] {
  return committee.delegates.filter(
    (d) => committee.rollCall[d] >= RollCall.present,
  );
}

export function getPresentAndVotingDelegates(committee: Committee): string[] {
  return committee.delegates.filter(
    (d) => committee.rollCall[d] === RollCall.presentAndVoting,
  );
}

export function committeeToJson(committee: Committee): Record<string, unknown> {
  return {
    id: committee.id,
    name: committee.name,
    agenda: committee.agenda,
    delegates: committee.delegates,
    rollCall: committee.rollCall,
    type: committee.type,
    createdAt: committee.createdAt != null ? committee.createdAt : null,
    days: committee.days,
    members: committee.members,
  };
}

export function committeeFromJson(data: Record<string, unknown>): Committee {
  const delegates = (data.delegates as string[]) ?? [];
  const rawDays = (data.days as unknown[]) ?? [];

  return {
    id: (data.id as string) ?? "",
    type: (data.type as string) ?? "Custom",
    name: (data.name as string) ?? "Your Committee",
    agenda: (data.agenda as string) ?? "Your Agenda",
    delegates,
    members: (data.members as string[]) ?? [],
    days: rawDays.map((d) => Date.parse(d as string)) as any[],
    createdAt: Date.parse(data.createdAt as any) as any,
    rollCall: data.rollCall
      ? (data.rollCall as Record<string, RollCallValue>)
      : Object.fromEntries(delegates.map((d) => [d, RollCall.none])),
  };
}

function generateId(): string {
  return (Math.floor(Math.random() * 1e8) + 1e8).toString();
}
