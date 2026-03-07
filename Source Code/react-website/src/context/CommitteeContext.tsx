import * as storage from "@/services/localStorage";
import {
  RollCall,
  getPresentAndVotingDelegates,
  type Committee,
  type RollCallValue,
} from "@/types/committee";
import {
  createScorecard,
  scorecardFromJson,
  type Parameter,
  type Scorecard,
} from "@/types/scorecard";
import {
  createContext,
  useCallback,
  useContext,
  useState,
  type ReactNode,
} from "react";

// ---- Speech State ----
export interface SpeechState {
  subtopic: Record<string, string>;
  overallDuration: number; // seconds
  duration: number; // seconds
  currentSpeaker: string;
  pastSpeakers: { delegate: string; duration: number }[];
  nextSpeakers: string[];
  isSpeaking: boolean;
  stopwatchElapsed: number;
  overallElapsed: number;
}

export function createSpeechState(): SpeechState {
  return {
    subtopic: { "": "" },
    overallDuration: 0,
    duration: 60,
    currentSpeaker: "",
    pastSpeakers: [],
    nextSpeakers: [],
    isSpeaking: false,
    stopwatchElapsed: 0,
    overallElapsed: 0,
  };
}

// ---- Vote State ----
export interface VoteState {
  topic: string;
  majority: number;
  voters: string[];
  pastVoters: { delegate: string; vote: boolean }[];
}

export function createVoteState(presentAndVoting: string[] = []): VoteState {
  return {
    topic: "Your Topic",
    majority: 0,
    voters: [...presentAndVoting],
    pastVoters: [],
  };
}

// ---- Motions State ----
export interface Motion {
  type: string;
  delegate?: string;
  topic?: string;
  duration?: number;
  [key: string]: unknown;
}

export interface MotionsState {
  mode: number;
  currentMotion: Motion | null;
  nextMotions: Motion[];
  pastMotions: (Motion & { passed: boolean })[];
}

export function createMotionsState(): MotionsState {
  return { mode: 0, currentMotion: null, nextMotions: [], pastMotions: [] };
}

// ---- Committee Context ----
interface CommitteeContextType {
  committee: Committee;
  setCommittee: (c: Committee) => void;
  tab: number;
  setTab: (t: number) => void;

  // Roll call
  setRollCall: (delegate: string, attendance: RollCallValue) => void;
  setAllPresentAndVoting: () => void;
  setAllPresent: () => void;
  setAllAbsent: () => void;
  setAgenda: (agenda: string) => void;

  // Speech (keyed by tag like "gsl", "mod", etc.)
  speeches: Record<string, SpeechState>;
  updateSpeech: (
    tag: string,
    updater: (prev: SpeechState) => SpeechState,
  ) => void;

  // Vote
  vote: VoteState;
  setVote: (updater: (prev: VoteState) => VoteState) => void;

  // Motions
  motions: MotionsState;
  setMotions: (updater: (prev: MotionsState) => MotionsState) => void;

  // Day
  selectedDay: number;
  prevDay: () => void;
  nextDay: () => void;
  resetDay: () => void;

  // Scorecard
  scorecard: Scorecard;
  setScorecard: (updater: (prev: Scorecard) => Scorecard) => void;
}

const CommitteeContext = createContext<CommitteeContextType | null>(null);

interface CommitteeProviderProps {
  children: ReactNode;
  initialCommittee: Committee;
}

export function CommitteeProvider({
  children,
  initialCommittee,
}: CommitteeProviderProps) {
  const [committee, setCommitteeRaw] = useState<Committee>(initialCommittee);
  const [tab, setTab] = useState(0);
  const lastDay =
    initialCommittee.days.length > 0 ? initialCommittee.days.length - 1 : 0;
  const [selectedDay, setSelectedDay] = useState(lastDay);
  const [speeches, setSpeeches] = useState<Record<string, SpeechState>>({});
  const [vote, setVoteRaw] = useState<VoteState>(() =>
    createVoteState(getPresentAndVotingDelegates(initialCommittee)),
  );
  const [motions, setMotionsRaw] = useState<MotionsState>(createMotionsState);
  const [scorecard, setScorecardRaw] = useState<Scorecard>(() => {
    const saved = storage.loadScoreData(initialCommittee.id);
    return saved
      ? scorecardFromJson(saved)
      : createScorecard(initialCommittee.delegates);
  });

  const setCommittee = useCallback((c: Committee) => {
    setCommitteeRaw(c);
    storage.saveCommitteeData(c.id, c as unknown as Record<string, unknown>);
  }, []);

  const setRollCall = useCallback(
    (delegate: string, attendance: RollCallValue) => {
      setCommitteeRaw((prev) => {
        const updated = {
          ...prev,
          rollCall: { ...prev.rollCall, [delegate]: attendance },
        };
        return updated;
      });
    },
    [],
  );

  const setAllPresentAndVoting = useCallback(() => {
    setCommitteeRaw((prev) => ({
      ...prev,
      rollCall: Object.fromEntries(
        prev.delegates.map((d) => [d, RollCall.presentAndVoting]),
      ),
    }));
  }, []);

  const setAllPresent = useCallback(() => {
    setCommitteeRaw((prev) => ({
      ...prev,
      rollCall: Object.fromEntries(
        prev.delegates.map((d) => [d, RollCall.present]),
      ),
    }));
  }, []);

  const setAllAbsent = useCallback(() => {
    setCommitteeRaw((prev) => ({
      ...prev,
      rollCall: Object.fromEntries(
        prev.delegates.map((d) => [d, RollCall.absent]),
      ),
    }));
  }, []);

  const setAgenda = useCallback((agenda: string) => {
    setCommitteeRaw((prev) => ({ ...prev, agenda }));
  }, []);

  const prevDay = useCallback(() => {
    setSelectedDay((d) => Math.max(0, d - 1));
  }, []);

  const nextDay = useCallback(() => {
    setSelectedDay((d) => Math.min(lastDay, d + 1));
  }, [lastDay]);

  const resetDay = useCallback(() => {
    setSelectedDay(lastDay);
  }, [lastDay]);

  const updateSpeech = useCallback(
    (tag: string, updater: (prev: SpeechState) => SpeechState) => {
      setSpeeches((prev) => ({
        ...prev,
        [tag]: updater(prev[tag] ?? createSpeechState()),
      }));
    },
    [],
  );

  const setVote = useCallback((updater: (prev: VoteState) => VoteState) => {
    setVoteRaw(updater);
  }, []);

  const setMotions = useCallback(
    (updater: (prev: MotionsState) => MotionsState) => {
      setMotionsRaw(updater);
    },
    [],
  );

  const setScorecard = useCallback(
    (updater: (prev: Scorecard) => Scorecard) => {
      setScorecardRaw((prev) => {
        const next = updater(prev);
        storage.saveScore(committee.id, next);
        return next;
      });
    },
    [committee.id],
  );

  return (
    <CommitteeContext.Provider
      value={{
        committee,
        setCommittee,
        tab,
        setTab,
        setRollCall,
        setAllPresentAndVoting,
        setAllPresent,
        setAllAbsent,
        setAgenda,
        speeches,
        updateSpeech,
        selectedDay,
        prevDay,
        nextDay,
        resetDay,
        vote,
        setVote,
        motions,
        setMotions,
        scorecard,
        setScorecard,
      }}
    >
      {children}
    </CommitteeContext.Provider>
  );
}

export function useCommittee() {
  const context = useContext(CommitteeContext);
  if (!context)
    throw new Error("useCommittee must be used within CommitteeProvider");
  return context;
}

// Vote helpers
export function getInFavor(
  pastVoters: { delegate: string; vote: boolean }[],
): number {
  return pastVoters.filter((v) => v.vote).length;
}

export function getAgainst(
  pastVoters: { delegate: string; vote: boolean }[],
): number {
  return pastVoters.filter((v) => !v.vote).length;
}

export function getMajorityValue(
  majority: number,
  totalVoters: number,
): number {
  switch (majority) {
    case 0:
      return Math.floor(totalVoters / 2 + (totalVoters > 0 ? 1 : 0));
    case 1:
      return Math.ceil((2 / 3) * totalVoters);
    case 2:
      return totalVoters;
    default:
      return 0;
  }
}

// Scorecard helpers
export function addParameter(
  sc: Scorecard,
  title: string,
  maxScore: number,
): Scorecard {
  const id = Math.max(0, ...sc.parameters.map((p) => p.id)) + 1;
  const newParam: Parameter = { id, title, maxScore };
  return {
    parameters: [...sc.parameters, newParam],
    scores: Object.fromEntries(
      Object.entries(sc.scores).map(([k, v]) => [k, [...v, 0]]),
    ),
  };
}

export function deleteParameter(sc: Scorecard, index: number): Scorecard {
  return {
    parameters: sc.parameters.filter((_, i) => i !== index),
    scores: Object.fromEntries(
      Object.entries(sc.scores).map(([k, v]) => [
        k,
        v.filter((_, i) => i !== index),
      ]),
    ),
  };
}

export function updateScore(
  sc: Scorecard,
  delegate: string,
  index: number,
  score: number,
): Scorecard {
  return {
    ...sc,
    scores: {
      ...sc.scores,
      [delegate]: sc.scores[delegate].map((v, i) => (i === index ? score : v)),
    },
  };
}
