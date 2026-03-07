import AddSpeaker from "@/components/committee/AddSpeaker";
import Hourglass from "@/components/committee/Hourglass";
import PastSpeakersCard from "@/components/committee/PastSpeakersCard";
import SpeakersInfo from "@/components/committee/SpeakersInfo";
import { createSpeechState, useCommittee } from "@/context/CommitteeContext";
import { useEffect } from "react";

const TAG = "tourdetable";

export default function TourDeTableMode() {
  const { speeches, updateSpeech } = useCommittee();

  useEffect(() => {
    if (!speeches[TAG]) {
      updateSpeech(TAG, () => ({
        ...createSpeechState(),
        subtopic: { Topic: "Your Topic" },
      }));
    }
  }, []);

  return (
    <div className="flex gap-9 h-full">
      <div className="w-1/2 flex flex-col gap-3 min-h-0">
        <div className="bg-white rounded-xl shadow p-6 flex gap-12">
          <Hourglass tag={TAG} />
          <SpeakersInfo tag={TAG} />
        </div>
        <PastSpeakersCard tag={TAG} />
      </div>
      <div className="flex-1 bg-white rounded-xl shadow p-6 overflow-hidden">
        <AddSpeaker tag={TAG} />
      </div>
    </div>
  );
}
