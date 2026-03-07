import DelegateTile from '@/components/DelegateTile';
import { createSpeechState, useCommittee } from '@/context/CommitteeContext';
import { getPresentDelegates } from '@/types/committee';

interface Props {
  tag: string;
}

export default function AddSpeaker({ tag }: Props) {
  const { committee, speeches, updateSpeech } = useCommittee();
  const speech = speeches[tag] ?? createSpeechState();
  const speakers = getPresentDelegates(committee);

  const addSpeaker = (delegate: string) => {
    updateSpeech(tag, (prev) => {
      if (prev.currentSpeaker === '' && prev.nextSpeakers.length === 0) {
        return { ...prev, currentSpeaker: delegate };
      }
      if (prev.nextSpeakers.includes(delegate) || prev.currentSpeaker === delegate) return prev;
      return { ...prev, nextSpeakers: [...prev.nextSpeakers, delegate] };
    });
  };

  const isAdded = (delegate: string) =>
    speech.currentSpeaker === delegate || speech.nextSpeakers.includes(delegate);

  return (
    <div className="flex flex-col overflow-hidden">
      <h3 className="font-semibold mb-2">Add Speaker</h3>
      {speakers.length > 0 ? (
        <div className="flex-1 overflow-y-auto">
          {speakers.map((delegate) => (
            <div
              key={delegate}
              className={`${isAdded(delegate) ? 'opacity-60' : 'cursor-pointer'}`}
              onClick={() => !isAdded(delegate) && addSpeaker(delegate)}
            >
              <DelegateTile delegate={delegate} />
            </div>
          ))}
        </div>
      ) : (
        <p className="text-gray-500 text-sm">Conduct a roll call before adding speakers</p>
      )}
    </div>
  );
}
