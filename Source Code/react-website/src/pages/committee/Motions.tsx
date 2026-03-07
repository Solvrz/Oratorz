import AddSpeaker from "@/components/committee/AddSpeaker";
import Body from "@/components/committee/Body";
import Hourglass from "@/components/committee/Hourglass";
import PastVotersCard from "@/components/committee/PastVotersCard";
import ResultCard from "@/components/committee/ResultCard";
import SpeakersInfo from "@/components/committee/SpeakersInfo";
import VoteSettingsDialog from "@/components/committee/VoteSettingsDialog";
import VotingCard from "@/components/committee/VotingCard";
import DelegateTile from "@/components/DelegateTile";
import DialogBox from "@/components/DialogBox";
import RoundedButton from "@/components/RoundedButton";
import {
  createSpeechState,
  createVoteState,
  useCommittee,
  type Motion,
} from "@/context/CommitteeContext";
import {
  getPresentAndVotingDelegates,
  getPresentDelegates,
} from "@/types/committee";
import { formatDuration } from "@/utils/helpers";
import {
  Ban,
  Check,
  Church,
  Circle,
  Clock,
  Edit,
  Layers,
  MessageSquare,
  Pause,
  RefreshCw,
  Sliders,
  Square,
  Timer,
  Vote,
  X,
} from "lucide-react";
import { useEffect, useState, type ReactNode } from "react";

const DEBATE_TAG = "motionDebate";

interface MotionType {
  type: string;
  icon: ReactNode;
  widgets: string[];
  topic?: Record<string, string>;
}

const MOTION_TYPES: MotionType[] = [
  {
    type: "Moderated Caucus",
    icon: <MessageSquare size={18} />,
    widgets: ["topic", "duration", "overallDuration"],
    topic: { Topic: "Your Topic" },
  },
  {
    type: "Unmoderated Caucus",
    icon: <Layers size={18} />,
    widgets: ["duration"],
  },
  {
    type: "Consultation",
    icon: <Circle size={18} />,
    widgets: ["topic", "duration"],
    topic: { Topic: "Your Topic" },
  },
  {
    type: "Adjourn Meeting",
    icon: <Pause size={18} />,
    widgets: ["duration"],
  },
  {
    type: "Change GSL Time",
    icon: <Timer size={18} />,
    widgets: ["duration"],
  },
  {
    type: "Prayer",
    icon: <Church size={18} />,
    widgets: ["topic", "duration"],
    topic: { Cause: "Your Cause" },
  },
  {
    type: "End Meeting",
    icon: <Square size={18} />,
    widgets: [],
  },
  {
    type: "Set Agenda",
    icon: <Sliders size={18} />,
    widgets: ["topic"],
    topic: { Agenda: "" },
  },
  {
    type: "Tour de Table",
    icon: <RefreshCw size={18} />,
    widgets: ["topic", "duration"],
    topic: { Topic: "Your Topic" },
  },
  {
    type: "Appeal Chair's Decision",
    icon: <Ban size={18} />,
    widgets: ["topic"],
    topic: { Decision: "Your Decision" },
  },
  {
    type: "Custom",
    icon: <Edit size={18} />,
    widgets: ["topic", "duration"],
    topic: { Title: "Your Title" },
  },
];

function formatTime12(date: Date): string {
  let h = date.getHours();
  const m = date.getMinutes().toString().padStart(2, "0");
  const ampm = h >= 12 ? "PM" : "AM";
  h = h % 12 || 12;
  return `${h}:${m} ${ampm}`;
}

export default function MotionsPage() {
  const { committee, motions, setMotions, speeches, updateSpeech, setVote } =
    useCommittee();
  const [dialogMotion, setDialogMotion] = useState<MotionType | null>(null);
  const [editMode, setEditMode] = useState(false);
  const [formDelegate, setFormDelegate] = useState("");
  const [formTopic, setFormTopic] = useState("");
  const [formDuration, setFormDuration] = useState(60);
  const [formOverallDuration, setFormOverallDuration] = useState(900);
  const [voteSettingsOpen, setVoteSettingsOpen] = useState(false);

  const presentDelegates = getPresentDelegates(committee);

  // Initialize speech state for debate mode
  useEffect(() => {
    if (motions.mode === 1 && !speeches[DEBATE_TAG]) {
      updateSpeech(DEBATE_TAG, () => createSpeechState());
    }
  }, [motions.mode, speeches, updateSpeech]);

  const openMotionDialog = (mt: MotionType, edit = false) => {
    setEditMode(edit);
    setDialogMotion(mt);
    setFormDelegate(
      edit && motions.currentMotion?.delegate
        ? (motions.currentMotion.delegate as string)
        : "",
    );
    const topicKey = mt.topic ? Object.keys(mt.topic)[0] : "";
    setFormTopic(
      edit && motions.currentMotion?.topic
        ? (motions.currentMotion.topic as string)
        : (mt.topic?.[topicKey] ?? ""),
    );
    setFormDuration(
      edit && motions.currentMotion?.duration
        ? (motions.currentMotion.duration as number)
        : 60,
    );
    setFormOverallDuration(
      edit && motions.currentMotion?.overallDuration
        ? (motions.currentMotion.overallDuration as number)
        : 900,
    );
  };

  const handleSubmitMotion = () => {
    if (!dialogMotion) return;
    const topicKey = dialogMotion.topic
      ? Object.keys(dialogMotion.topic)[0]
      : "";
    const motion: Motion = {
      type: dialogMotion.type,
      time: formatTime12(new Date()),
    };
    if (formDelegate) motion.delegate = formDelegate;
    if (topicKey && formTopic) motion.topic = formTopic;
    if (topicKey) motion.topicKey = topicKey;
    if (dialogMotion.widgets.includes("duration"))
      motion.duration = formDuration;
    if (dialogMotion.widgets.includes("overallDuration"))
      motion.overallDuration = formOverallDuration;

    if (editMode) {
      setMotions((prev) => ({ ...prev, currentMotion: motion }));
    } else {
      setMotions((prev) => ({ ...prev, currentMotion: motion }));
    }
    setDialogMotion(null);
  };

  const passMotion = () => {
    if (!motions.currentMotion) return;
    setMotions((prev) => ({
      ...prev,
      pastMotions: [
        { ...prev.currentMotion!, passed: true },
        ...prev.pastMotions,
      ],
      currentMotion: null,
    }));
  };

  const failMotion = () => {
    if (!motions.currentMotion) return;
    setMotions((prev) => ({
      ...prev,
      pastMotions: [
        { ...prev.currentMotion!, passed: false },
        ...prev.pastMotions,
      ],
      currentMotion: null,
    }));
  };

  const cm = motions.currentMotion;

  return (
    <Body>
      <div className="flex gap-9 h-full">
        {/* Left column */}
        <div className="w-1/3 flex flex-col gap-3 min-h-0">
          {/* Motion on Floor */}
          <div className="bg-white rounded-xl shadow p-4">
            <h3 className="font-bold text-lg mb-2">Motion on Floor</h3>
            {cm ? (
              <div className="border rounded-xl p-3 flex items-center gap-3">
                <div className="shrink-0">
                  {cm.delegate ? (
                    <img
                      src={`/flags/${cm.delegate.split(" ")[0]}.png`}
                      className="w-10 h-10 rounded-full object-cover"
                      alt=""
                    />
                  ) : (
                    <div className="w-10 h-10 rounded-full bg-gray-200" />
                  )}
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-xs text-gray-500">{cm.type}</p>
                  <p className="font-bold text-sm truncate">
                    {cm.delegate
                      ? cm.delegate.split(" ").slice(1).join(" ") || "Delegate"
                      : "Delegate"}
                  </p>
                </div>
                <div className="text-right shrink-0">
                  {cm.duration && (
                    <div className="flex items-center gap-1 text-xs text-gray-600">
                      <Clock size={12} />
                      <span>{formatDuration(cm.duration as number)}</span>
                    </div>
                  )}
                  <p className="text-xs text-gray-400">{cm.time as string}</p>
                </div>
                <button
                  onClick={() => {
                    const mt = MOTION_TYPES.find((m) => m.type === cm.type);
                    if (mt) openMotionDialog(mt, true);
                  }}
                  className="p-1 border border-green-400 rounded-lg hover:bg-green-50 shrink-0"
                >
                  <Edit size={14} className="text-green-500" />
                </button>
              </div>
            ) : (
              <p className="text-gray-400 text-sm py-8 text-center">
                No motions currently on the floor
              </p>
            )}
            <div className="flex justify-evenly mt-4">
              <RoundedButton
                color="#f59e0b"
                onClick={() => {
                  setMotions((prev) => ({
                    ...prev,
                    mode: prev.mode === 1 ? 0 : 1,
                  }));
                  if (motions.mode !== 1 && !speeches[DEBATE_TAG]) {
                    updateSpeech(DEBATE_TAG, () => createSpeechState());
                  }
                }}
                tooltip="Debate Motion"
              >
                <MessageSquare size={18} />
              </RoundedButton>
              <RoundedButton
                color="var(--color-tertiary)"
                onClick={() => {
                  if (motions.mode !== 2) {
                    setVote(() =>
                      createVoteState(getPresentAndVotingDelegates(committee)),
                    );
                  }
                  setMotions((prev) => ({
                    ...prev,
                    mode: prev.mode === 2 ? 0 : 2,
                  }));
                }}
                tooltip="Vote Motion"
              >
                <Vote size={18} />
              </RoundedButton>
              <RoundedButton
                color="#f87171"
                onClick={failMotion}
                tooltip="Fail Motion"
              >
                <X size={18} />
              </RoundedButton>
              <RoundedButton
                color="#22c55e"
                onClick={passMotion}
                tooltip="Pass Motion"
              >
                <Check size={18} />
              </RoundedButton>
            </div>
          </div>

          {/* Past Motions */}
          <div className="bg-white rounded-xl shadow p-4 flex flex-col flex-1 min-h-0">
            <h3 className="font-bold text-lg mb-2">Past Motions</h3>
            {motions.pastMotions.length > 0 ? (
              <div className="flex-1 overflow-y-auto flex flex-col gap-2">
                {motions.pastMotions.map((m, i) => (
                  <div
                    key={i}
                    className="border rounded-lg p-3 flex items-center gap-2"
                  >
                    <div className="flex-1 min-w-0">
                      <p className="text-xs text-gray-500">{m.type}</p>
                      {m.delegate && (
                        <p className="font-medium text-sm truncate">
                          {m.delegate.split(" ").slice(1).join(" ") ||
                            m.delegate}
                        </p>
                      )}
                    </div>
                    {m.passed ? (
                      <Check size={16} className="text-green-500 shrink-0" />
                    ) : (
                      <X size={16} className="text-red-500 shrink-0" />
                    )}
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-gray-500 text-sm">No motions added yet.</p>
            )}
          </div>
        </div>

        {/* Right column - mode dependent */}
        {motions.mode === 1 ? (
          <div className="flex-1 flex flex-col gap-3 min-h-0">
            <div className="bg-white rounded-xl shadow p-6 flex gap-12">
              <Hourglass tag={DEBATE_TAG} canYield />
              <SpeakersInfo tag={DEBATE_TAG} />
            </div>
            <div className="flex-1 bg-white rounded-xl shadow p-6 overflow-hidden min-h-0">
              <AddSpeaker tag={DEBATE_TAG} />
            </div>
          </div>
        ) : motions.mode === 2 ? (
          <div className="flex-1 flex gap-6 min-h-0">
            <div className="w-1/2 flex flex-col gap-4 min-h-0">
              <ResultCard
                onOpenSettings={() => setVoteSettingsOpen(true)}
                onReset={() =>
                  setVote(() =>
                    createVoteState(getPresentAndVotingDelegates(committee)),
                  )
                }
              />
              <PastVotersCard />
            </div>
            <div className="flex-1 min-h-0">
              <VotingCard />
            </div>
          </div>
        ) : (
          <div className="flex-1 bg-white rounded-xl shadow p-4 flex flex-col min-h-0">
            <h3 className="font-bold text-lg mb-3">Add Motion</h3>
            <div className="flex-1 overflow-y-auto flex flex-col gap-2">
              {MOTION_TYPES.map((mt) => (
                <button
                  key={mt.type}
                  onClick={() => openMotionDialog(mt)}
                  className="flex items-center justify-center gap-2 border rounded-xl px-4 py-3 hover:bg-gray-50 transition-colors"
                >
                  {mt.icon}
                  <span className="font-medium">{mt.type}</span>
                </button>
              ))}
            </div>
          </div>
        )}
      </div>

      {/* Motion Dialog */}
      <DialogBox
        open={dialogMotion !== null}
        onClose={() => setDialogMotion(null)}
        heading={dialogMotion?.type ?? ""}
      >
        {dialogMotion && (
          <div className="flex flex-col gap-4 min-w-80">
            {dialogMotion.widgets.includes("topic") && dialogMotion.topic && (
              <div>
                <label className="text-sm font-medium mb-1 block">
                  {Object.keys(dialogMotion.topic)[0]}
                </label>
                <input
                  className="w-full border rounded-lg px-3 py-2 text-sm"
                  value={formTopic}
                  onChange={(e) => setFormTopic(e.target.value)}
                  placeholder={Object.keys(dialogMotion.topic)[0]}
                />
              </div>
            )}

            {dialogMotion.widgets.includes("duration") && (
              <div>
                <label className="text-sm font-medium mb-1 block">
                  Speaker Time: {formatDuration(formDuration)}
                </label>
                <input
                  type="range"
                  min={10}
                  max={600}
                  step={10}
                  value={formDuration}
                  onChange={(e) => setFormDuration(Number(e.target.value))}
                  className="w-full accent-tertiary"
                />
              </div>
            )}

            {dialogMotion.widgets.includes("overallDuration") && (
              <div>
                <label className="text-sm font-medium mb-1 block">
                  Caucus Time: {formatDuration(formOverallDuration)}
                </label>
                <input
                  type="range"
                  min={60}
                  max={3600}
                  step={30}
                  value={formOverallDuration}
                  onChange={(e) =>
                    setFormOverallDuration(Number(e.target.value))
                  }
                  className="w-full accent-tertiary"
                />
              </div>
            )}

            <div>
              <label className="text-sm font-medium mb-1 block">
                Submitted By
              </label>
              <div className="max-h-40 overflow-y-auto border rounded-lg">
                <div
                  className={`cursor-pointer px-3 py-1.5 text-sm hover:bg-gray-50 ${
                    formDelegate === "" ? "bg-tertiary/10 font-medium" : ""
                  }`}
                  onClick={() => setFormDelegate("")}
                >
                  None
                </div>
                {presentDelegates.map((d) => (
                  <div
                    key={d}
                    className={`cursor-pointer hover:bg-gray-50 ${
                      formDelegate === d ? "bg-tertiary/10" : ""
                    }`}
                    onClick={() => setFormDelegate(d)}
                  >
                    <DelegateTile delegate={d} />
                  </div>
                ))}
              </div>
            </div>

            <RoundedButton
              style="border"
              color="#f59e0b"
              onClick={handleSubmitMotion}
            >
              {editMode ? "Update" : "Add"}
            </RoundedButton>
          </div>
        )}
      </DialogBox>

      <VoteSettingsDialog
        open={voteSettingsOpen}
        onClose={() => setVoteSettingsOpen(false)}
      />
    </Body>
  );
}
