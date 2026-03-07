import DelegateTile from "@/components/DelegateTile";
import { createSpeechState, useCommittee } from "@/context/CommitteeContext";

function formatDuration(seconds: number): string {
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m}m ${s}s`;
}

interface Props {
  tag: string;
}

export default function PastSpeakersCard({ tag }: Props) {
  const { speeches } = useCommittee();
  const speech = speeches[tag] ?? createSpeechState();

  return (
    <div className="bg-white rounded-xl shadow p-4 flex flex-col flex-1 min-h-0">
      <h3 className="font-semibold mb-2">Past Speakers</h3>
      {speech.pastSpeakers.length > 0 ? (
        <div className="flex-1 overflow-y-auto">
          {speech.pastSpeakers.map((entry, index) => (
            <div
              key={`${entry.delegate}-${index}`}
              className="flex items-center justify-between"
            >
              <DelegateTile delegate={entry.delegate} />
              <span className="text-sm text-gray-500">
                {formatDuration(entry.duration)}
              </span>
            </div>
          ))}
        </div>
      ) : (
        <p className="text-gray-500 text-sm">No past speakers</p>
      )}
    </div>
  );
}
