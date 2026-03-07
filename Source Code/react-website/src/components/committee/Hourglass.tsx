import DialogBox from "@/components/DialogBox";
import RoundedButton from "@/components/RoundedButton";
import SpeechSettingsDialog from "@/components/committee/SpeechSettingsDialog";
import YieldSpeakerDialog from "@/components/committee/YieldSpeakerDialog";
import { createSpeechState, useCommittee } from "@/context/CommitteeContext";
import { getPresentDelegates } from "@/types/committee";
import { Edit, Play, RotateCcw, Settings, Square, User } from "lucide-react";
import { useCallback, useEffect, useRef, useState } from "react";

interface HourglassProps {
  tag: string;
  canYield?: boolean;
}

function formatTime(seconds: number): string {
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m.toString().padStart(2, "0")}:${s.toString().padStart(2, "0")}`;
}

export default function Hourglass({ tag, canYield = false }: HourglassProps) {
  const { speeches, updateSpeech, committee } = useCommittee();
  const speech = speeches[tag] ?? createSpeechState();
  const [settingsOpen, setSettingsOpen] = useState(false);
  const [yieldOpen, setYieldOpen] = useState(false);
  const [editTitleOpen, setEditTitleOpen] = useState(false);
  const [tempTitle, setTempTitle] = useState("");
  const intervalRef = useRef<number | null>(null);

  const timeLeft = Math.max(0, speech.duration - speech.stopwatchElapsed);
  const overallTimeLeft =
    speech.overallDuration > 0
      ? Math.max(0, speech.overallDuration - speech.overallElapsed)
      : null;
  const percent = speech.duration > 0 ? timeLeft / speech.duration : 0;

  const tick = useCallback(() => {
    updateSpeech(tag, (prev) => {
      const newElapsed = prev.stopwatchElapsed + 1;
      const newOverall = prev.overallElapsed + 1;
      if (newElapsed >= prev.duration) {
        return {
          ...prev,
          stopwatchElapsed: prev.duration,
          overallElapsed: newOverall,
          isSpeaking: false,
        };
      }
      return {
        ...prev,
        stopwatchElapsed: newElapsed,
        overallElapsed: newOverall,
      };
    });
  }, [tag, updateSpeech]);

  useEffect(() => {
    if (speech.isSpeaking && timeLeft > 0) {
      intervalRef.current = window.setInterval(tick, 1000);
    }
    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current);
    };
  }, [speech.isSpeaking, timeLeft, tick]);

  const toggleSpeaking = () => {
    updateSpeech(tag, (prev) => ({ ...prev, isSpeaking: !prev.isSpeaking }));
  };

  const reset = () => {
    updateSpeech(tag, (prev) => ({
      ...prev,
      stopwatchElapsed: 0,
      isSpeaking: false,
    }));
  };

  const subtopicKey = Object.keys(speech.subtopic)[0] ?? "";
  const subtopicValue = speech.subtopic[subtopicKey] ?? "";

  return (
    <div className="flex flex-col">
      {subtopicKey && (
        <div className="flex items-center gap-2 mb-2">
          <p>
            <strong>{subtopicKey}: </strong>
            <span className="font-medium">{subtopicValue}</span>
          </p>
          <button
            onClick={() => {
              setTempTitle(subtopicValue);
              setEditTitleOpen(true);
            }}
            className="p-1 border border-amber-400 rounded-lg hover:bg-amber-50"
            title={`Edit ${subtopicKey}`}
          >
            <Edit size={14} className="text-amber-400" />
          </button>
        </div>
      )}
      <div className="flex items-center gap-6">
        {/* Circular timer */}
        <div className="relative w-48 h-48">
          <svg viewBox="0 0 100 100" className="w-full h-full -rotate-90">
            <circle
              cx="50"
              cy="50"
              r="42"
              fill="none"
              stroke="#e5e7eb"
              strokeWidth="6"
            />
            <circle
              cx="50"
              cy="50"
              r="42"
              fill="none"
              stroke="#0d1520"
              strokeWidth="6"
              strokeLinecap="round"
              strokeDasharray={`${percent * 263.89} 263.89`}
              className="transition-all duration-1000"
            />
          </svg>
          <div className="absolute inset-0 flex flex-col items-center justify-center">
            {overallTimeLeft !== null && (
              <span className="text-sm font-medium">
                {formatTime(overallTimeLeft)}
              </span>
            )}
            <span className="text-2xl font-bold">{formatTime(timeLeft)}</span>
          </div>
        </div>

        {/* Controls */}
        <div className="flex flex-col gap-3">
          <RoundedButton onClick={toggleSpeaking} color="#546e7a">
            {speech.isSpeaking ? <Square size={18} /> : <Play size={18} />}
          </RoundedButton>
          <RoundedButton onClick={reset} color="var(--color-tertiary)">
            <RotateCcw size={18} />
          </RoundedButton>
          <RoundedButton
            onClick={() => {
              updateSpeech(tag, (prev) => ({ ...prev, isSpeaking: false }));
              setSettingsOpen(true);
            }}
            color="#fbbf24"
          >
            <Settings size={18} />
          </RoundedButton>
          {canYield && (
            <RoundedButton onClick={() => setYieldOpen(true)} color="#1f2937">
              <User size={18} />
            </RoundedButton>
          )}
        </div>
      </div>

      <SpeechSettingsDialog
        open={settingsOpen}
        onClose={() => setSettingsOpen(false)}
        tag={tag}
      />
      {canYield && (
        <YieldSpeakerDialog
          open={yieldOpen}
          onClose={() => setYieldOpen(false)}
          tag={tag}
          delegates={getPresentDelegates(committee).filter(
            (d) => d !== speech.currentSpeaker,
          )}
        />
      )}

      <DialogBox
        open={editTitleOpen}
        onClose={() => setEditTitleOpen(false)}
        heading={`Edit ${subtopicKey}`}
      >
        <input
          className="w-full border rounded-lg px-3 py-2 mb-4"
          value={tempTitle}
          onChange={(e) => setTempTitle(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter") {
              updateSpeech(tag, (prev) => ({
                ...prev,
                subtopic: { [subtopicKey]: tempTitle },
              }));
              setEditTitleOpen(false);
            }
          }}
          autoFocus
          placeholder={subtopicKey}
        />
        <RoundedButton
          style="border"
          color="#f59e0b"
          onClick={() => {
            updateSpeech(tag, (prev) => ({
              ...prev,
              subtopic: { [subtopicKey]: tempTitle },
            }));
            setEditTitleOpen(false);
          }}
        >
          Save
        </RoundedButton>
      </DialogBox>
    </div>
  );
}
