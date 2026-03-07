import Body from "@/components/committee/Body";
import PastVotersCard from "@/components/committee/PastVotersCard";
import ResultCard from "@/components/committee/ResultCard";
import VoteSettingsDialog from "@/components/committee/VoteSettingsDialog";
import VotingCard from "@/components/committee/VotingCard";
import { createVoteState, useCommittee } from "@/context/CommitteeContext";
import { getPresentAndVotingDelegates } from "@/types/committee";
import { useState } from "react";

export default function VotePage() {
  const { committee, setVote } = useCommittee();
  const [settingsOpen, setSettingsOpen] = useState(false);

  const handleReset = () => {
    setVote(() => createVoteState(getPresentAndVotingDelegates(committee)));
  };

  return (
    <Body>
      <div className="flex gap-6 h-full">
        <div className="w-1/3 flex flex-col gap-4 min-h-0">
          <ResultCard
            onOpenSettings={() => setSettingsOpen(true)}
            onReset={handleReset}
          />
          <PastVotersCard />
        </div>
        <div className="flex-1 min-h-0">
          <VotingCard />
        </div>
      </div>
      <VoteSettingsDialog
        open={settingsOpen}
        onClose={() => setSettingsOpen(false)}
      />
    </Body>
  );
}
