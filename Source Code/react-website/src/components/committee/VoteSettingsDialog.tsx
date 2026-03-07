import DialogBox from '@/components/DialogBox';
import RoundedButton from '@/components/RoundedButton';
import { useCommittee } from '@/context/CommitteeContext';
import { useState } from 'react';

const MAJORITY_LABELS = ['Simple Majority', 'Special Majority (2/3)', 'Unanimous'];

interface VoteSettingsDialogProps {
  open: boolean;
  onClose: () => void;
}

export default function VoteSettingsDialog({ open, onClose }: VoteSettingsDialogProps) {
  const { vote, setVote } = useCommittee();
  const [topic, setTopic] = useState(vote.topic);
  const [majority, setMajority] = useState(vote.majority);

  const handleDone = () => {
    setVote((prev) => ({ ...prev, topic, majority }));
    onClose();
  };

  return (
    <DialogBox open={open} onClose={onClose} heading="Vote Settings">
      <div className="flex flex-col gap-4 min-w-80">
        <div>
          <label className="text-sm font-medium mb-1 block">Topic</label>
          <input
            className="w-full border rounded-lg px-3 py-2"
            value={topic}
            onChange={(e) => setTopic(e.target.value)}
            placeholder="Topic"
          />
        </div>
        <div>
          <label className="text-sm font-medium mb-1 block">Majority</label>
          <div className="flex flex-col gap-2">
            {MAJORITY_LABELS.map((label, idx) => (
              <label key={idx} className="flex items-center gap-2 cursor-pointer">
                <input
                  type="radio"
                  name="majority"
                  checked={majority === idx}
                  onChange={() => setMajority(idx)}
                  className="accent-tertiary"
                />
                <span className="text-sm">{label}</span>
              </label>
            ))}
          </div>
        </div>
        <RoundedButton style="border" className="border-amber-400 text-amber-400" onClick={handleDone}>
          Done
        </RoundedButton>
      </div>
    </DialogBox>
  );
}
