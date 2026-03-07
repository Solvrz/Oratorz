import AddSpeaker from '@/components/committee/AddSpeaker';
import Hourglass from '@/components/committee/Hourglass';
import SpeakersInfo from '@/components/committee/SpeakersInfo';
import { createSpeechState, useCommittee } from '@/context/CommitteeContext';
import { useEffect } from 'react';

const TAG = 'single';

export default function SingleMode() {
  const { speeches, updateSpeech } = useCommittee();

  useEffect(() => {
    if (!speeches[TAG]) {
      updateSpeech(TAG, () => createSpeechState());
    }
  }, []);

  return (
    <div className="flex gap-9 h-full">
      <div className="w-1/2">
        <div className="bg-white rounded-xl shadow p-6 flex gap-12">
          <Hourglass tag={TAG} canYield />
          <SpeakersInfo tag={TAG} />
        </div>
      </div>
      <div className="flex-1 bg-white rounded-xl shadow p-6 overflow-hidden">
        <AddSpeaker tag={TAG} />
      </div>
    </div>
  );
}
