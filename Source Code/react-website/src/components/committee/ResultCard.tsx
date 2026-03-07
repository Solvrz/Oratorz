import RoundedButton from '@/components/RoundedButton';
import { getAgainst, getInFavor, getMajorityValue, useCommittee } from '@/context/CommitteeContext';
import { Settings } from 'lucide-react';

const MAJORITY_LABELS = ['Simple', '2/3 Majority', 'Unanimous'];

interface ResultCardProps {
  onOpenSettings: () => void;
  onReset: () => void;
}

export default function ResultCard({ onOpenSettings, onReset }: ResultCardProps) {
  const { vote } = useCommittee();
  const total = vote.voters.length + vote.pastVoters.length;
  const inFavor = getInFavor(vote.pastVoters);
  const against = getAgainst(vote.pastVoters);
  const majorityValue = getMajorityValue(vote.majority, total);
  const passed = inFavor >= majorityValue && total > 0;
  const progress = total > 0 ? (inFavor / majorityValue) * 100 : 0;

  return (
    <div className="bg-white rounded-xl shadow p-6 flex flex-col gap-4">
      <div className="flex items-center justify-between">
        <h3 className="font-bold text-lg">{vote.topic}</h3>
        <div className="flex gap-2">
          <button onClick={onOpenSettings} className="p-2 hover:bg-gray-100 rounded-lg" title="Settings">
            <Settings size={18} />
          </button>
        </div>
      </div>
      <div className="text-sm text-gray-500">{MAJORITY_LABELS[vote.majority]}</div>
      <div className="flex gap-6">
        <div className="text-center">
          <div className="text-2xl font-bold text-green-500">{inFavor}</div>
          <div className="text-xs text-gray-400">In Favor</div>
        </div>
        <div className="text-center">
          <div className="text-2xl font-bold text-red-500">{against}</div>
          <div className="text-xs text-gray-400">Against</div>
        </div>
        <div className="text-center">
          <div className="text-2xl font-bold text-tertiary">{majorityValue}</div>
          <div className="text-xs text-gray-400">Required</div>
        </div>
      </div>
      {/* Progress bar */}
      <div className="w-full bg-gray-200 rounded-full h-3">
        <div
          className={`h-3 rounded-full transition-all ${passed ? 'bg-green-500' : 'bg-tertiary'}`}
          style={{ width: `${Math.min(progress, 100)}%` }}
        />
      </div>
      {vote.voters.length === 0 && vote.pastVoters.length > 0 && (
        <div className={`text-center font-bold text-lg ${passed ? 'text-green-500' : 'text-red-500'}`}>
          {passed ? 'PASSED' : 'NOT PASSED'}
        </div>
      )}
      <RoundedButton style="border" onClick={onReset}>
        Reset Vote
      </RoundedButton>
    </div>
  );
}
