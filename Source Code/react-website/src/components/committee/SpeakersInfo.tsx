import DelegateTile from "@/components/DelegateTile";
import RoundedButton from "@/components/RoundedButton";
import { createSpeechState, useCommittee } from "@/context/CommitteeContext";
import { ArrowLeftRight, GripVertical, X } from "lucide-react";
import { useRef, useState } from "react";

interface Props {
  tag: string;
}

export default function SpeakersInfo({ tag }: Props) {
  const { speeches, updateSpeech } = useCommittee();
  const speech = speeches[tag] ?? createSpeechState();
  const [dragIndex, setDragIndex] = useState<number | null>(null);
  const [dragOverIndex, setDragOverIndex] = useState<number | null>(null);
  const dragNode = useRef<HTMLDivElement | null>(null);

  const nextSpeaker = () => {
    if (speech.stopwatchElapsed === 0) return;
    updateSpeech(tag, (prev) => {
      const pastEntry = prev.currentSpeaker
        ? { delegate: prev.currentSpeaker, duration: prev.stopwatchElapsed }
        : null;
      const next = prev.nextSpeakers[0] ?? "";
      return {
        ...prev,
        currentSpeaker: next,
        nextSpeakers: prev.nextSpeakers.slice(1),
        pastSpeakers: pastEntry
          ? [...prev.pastSpeakers, pastEntry]
          : prev.pastSpeakers,
        stopwatchElapsed: 0,
        isSpeaking: false,
      };
    });
  };

  const removeCurrentSpeaker = () => {
    updateSpeech(tag, (prev) => ({ ...prev, currentSpeaker: "" }));
  };

  const removeSpeaker = (delegate: string) => {
    updateSpeech(tag, (prev) => ({
      ...prev,
      nextSpeakers: prev.nextSpeakers.filter((s) => s !== delegate),
    }));
  };

  const swapWithCurrent = (index: number) => {
    updateSpeech(tag, (prev) => {
      const speaker = prev.nextSpeakers[index];
      const updated = [...prev.nextSpeakers];
      updated[index] = prev.currentSpeaker;
      return { ...prev, currentSpeaker: speaker, nextSpeakers: updated };
    });
  };

  const handleDragStart = (
    index: number,
    e: React.DragEvent<HTMLDivElement>,
  ) => {
    setDragIndex(index);
    dragNode.current = e.currentTarget;
    e.dataTransfer.effectAllowed = "move";
  };

  const handleDragOver = (index: number, e: React.DragEvent) => {
    e.preventDefault();
    if (dragIndex === null || dragIndex === index) return;
    setDragOverIndex(index);
  };

  const handleDrop = (index: number) => {
    if (dragIndex === null || dragIndex === index) return;
    updateSpeech(tag, (prev) => {
      const updated = [...prev.nextSpeakers];
      const [moved] = updated.splice(dragIndex, 1);
      updated.splice(index, 0, moved);
      return { ...prev, nextSpeakers: updated };
    });
    setDragIndex(null);
    setDragOverIndex(null);
  };

  const handleDragEnd = () => {
    setDragIndex(null);
    setDragOverIndex(null);
  };

  return (
    <div className="flex-1 flex flex-col overflow-hidden">
      <div className="flex items-center justify-between mb-2">
        <h3 className="font-semibold">Current Speaker</h3>
        <RoundedButton
          color="var(--color-tertiary)"
          className="text-xs px-3 py-1"
          onClick={nextSpeaker}
        >
          {speech.isSpeaking ? "Done" : "Next"}
        </RoundedButton>
      </div>
      {speech.currentSpeaker ? (
        <div className="flex items-center">
          <div className="flex-1">
            <DelegateTile delegate={speech.currentSpeaker} />
          </div>
          <RoundedButton
            color="#f87171"
            className="p-1"
            onClick={removeCurrentSpeaker}
          >
            <X size={14} />
          </RoundedButton>
        </div>
      ) : (
        <p className="text-gray-500 text-sm">No speaker currently added</p>
      )}

      <hr className="my-3" />

      <h3 className="font-semibold mb-2">Upcoming Speakers</h3>
      {speech.nextSpeakers.length > 0 ? (
        <div className="flex-1 overflow-y-auto">
          {speech.nextSpeakers.map((delegate, index) => (
            <div
              key={`${delegate}-${index}`}
              className={`flex items-center mb-1 rounded-lg transition-colors ${dragOverIndex === index ? "bg-gray-100" : ""}`}
              draggable
              onDragStart={(e) => handleDragStart(index, e)}
              onDragOver={(e) => handleDragOver(index, e)}
              onDrop={() => handleDrop(index)}
              onDragEnd={handleDragEnd}
            >
              <GripVertical
                size={16}
                className="text-gray-400 cursor-grab shrink-0 mr-1"
              />
              <div className="flex-1">
                <DelegateTile delegate={delegate} />
              </div>
              <div className="flex gap-1">
                <RoundedButton
                  color="var(--color-tertiary)"
                  className="p-1"
                  onClick={() => swapWithCurrent(index)}
                >
                  <ArrowLeftRight size={14} />
                </RoundedButton>
                <RoundedButton
                  color="#f87171"
                  className="p-1"
                  onClick={() => removeSpeaker(delegate)}
                >
                  <X size={14} />
                </RoundedButton>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <p className="text-gray-500 text-sm">No upcoming speakers</p>
      )}
    </div>
  );
}
