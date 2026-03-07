import DelegateTile from "@/components/DelegateTile";
import { useCommittee } from "@/context/CommitteeContext";
import { Check, X } from "lucide-react";

export default function PastVotersCard() {
  const { vote } = useCommittee();

  if (vote.pastVoters.length === 0) {
    return (
      <div className="bg-white rounded-xl shadow p-6 flex flex-col flex-1 min-h-0">
        <h3 className="font-bold text-sm text-gray-500 mb-3">Past Voters</h3>
        <p className="text-gray-500 text-sm">No delegates have voted yet</p>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-xl shadow p-6 flex flex-col flex-1 min-h-0">
      <h3 className="font-bold text-sm text-gray-500 mb-3">
        Past Voters ({vote.pastVoters.length})
      </h3>
      <div className="flex-1 overflow-y-auto">
        {vote.pastVoters.map((pv, index) => (
          <DelegateTile
            key={index}
            delegate={pv.delegate}
            trailing={
              pv.vote ? (
                <Check size={18} className="text-green-500" />
              ) : (
                <X size={18} className="text-red-500" />
              )
            }
          />
        ))}
      </div>
    </div>
  );
}
