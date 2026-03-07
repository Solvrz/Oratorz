import DelegateTile from '@/components/DelegateTile';
import DialogBox from '@/components/DialogBox';
import RoundedButton from '@/components/RoundedButton';
import { useCommittee } from '@/context/CommitteeContext';
import { useState } from 'react';

interface Props {
  open: boolean;
  onClose: () => void;
  tag: string;
  delegates: string[];
}

export default function YieldSpeakerDialog({ open, onClose, tag, delegates }: Props) {
  const { updateSpeech } = useCommittee();
  const [selected, setSelected] = useState(-1);

  const handleDone = () => {
    if (selected < 0 || selected >= delegates.length) return;
    const delegate = delegates[selected];
    updateSpeech(tag, (prev) => ({
      ...prev,
      currentSpeaker: delegate,
      nextSpeakers: prev.nextSpeakers.filter((s) => s !== delegate),
    }));
    onClose();
  };

  return (
    <DialogBox open={open} onClose={onClose} heading="Yield to Speaker">
      {delegates.length > 0 ? (
        <div className="max-h-[60vh] overflow-y-auto mb-4">
          {delegates.map((delegate, index) => (
            <button
              key={delegate}
              onClick={() => setSelected(index)}
              className={`w-full flex items-center p-1 rounded-lg mb-1 ${
                selected === index ? 'bg-gray-100' : ''
              }`}
            >
              <div className="flex-1"><DelegateTile delegate={delegate} /></div>
              <input
                type="radio"
                checked={selected === index}
                onChange={() => setSelected(index)}
                className="accent-gray-700"
              />
            </button>
          ))}
        </div>
      ) : (
        <p className="text-center py-8 text-gray-500">
          Conduct a roll call before yielding speakers
        </p>
      )}
      <RoundedButton className="w-full" onClick={handleDone} disabled={selected < 0}>
        DONE
      </RoundedButton>
    </DialogBox>
  );
}
