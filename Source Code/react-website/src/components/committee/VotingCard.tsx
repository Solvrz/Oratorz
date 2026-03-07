import DelegateTile from "@/components/DelegateTile";
import RoundedButton from "@/components/RoundedButton";
import { useCommittee } from "@/context/CommitteeContext";

export default function VotingCard() {
  const { vote, setVote } = useCommittee();

  if (vote.voters.length === 0) {
    return (
      <div className="bg-white rounded-xl shadow p-6 flex items-center justify-center text-gray-400 text-sm">
        All delegates have voted.
      </div>
    );
  }

  const currentVoter = vote.voters[0];
  const remaining = vote.voters.slice(1);

  const handleVote = (inFavor: boolean) => {
    setVote((prev) => ({
      ...prev,
      voters: prev.voters.slice(1),
      pastVoters: [
        ...prev.pastVoters,
        { delegate: currentVoter, vote: inFavor },
      ],
    }));
  };

  return (
    <div className="bg-white rounded-xl shadow p-6 flex flex-col gap-4 h-full min-h-0">
      <h3 className="font-bold text-sm text-gray-500">Current Voter</h3>
      <DelegateTile delegate={currentVoter} />
      <div className="flex gap-3">
        <RoundedButton
          color="#22c55e"
          className="flex-1"
          onClick={() => handleVote(true)}
        >
          In Favor
        </RoundedButton>
        <RoundedButton
          color="#ef4444"
          className="flex-1"
          onClick={() => handleVote(false)}
        >
          Against
        </RoundedButton>
      </div>
      {remaining.length > 0 && (
        <>
          <h3 className="font-bold text-sm text-gray-500 mt-2">
            Remaining ({remaining.length})
          </h3>
          <div className="flex-1 overflow-y-auto">
            {remaining.map((delegate) => (
              <DelegateTile key={delegate} delegate={delegate} />
            ))}
          </div>
        </>
      )}
    </div>
  );
}
