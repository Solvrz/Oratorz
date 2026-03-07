import Hourglass from '@/components/committee/Hourglass';
import { createSpeechState, useCommittee } from '@/context/CommitteeContext';
import { useEffect } from 'react';

const TAG = 'prayer';

export default function PrayerMode() {
  const { speeches, updateSpeech } = useCommittee();

  useEffect(() => {
    if (!speeches[TAG]) {
      updateSpeech(TAG, () => ({
        ...createSpeechState(),
        subtopic: { Cause: 'Your Cause' },
      }));
    }
  }, []);

  return (
    <div className="flex items-center justify-center h-full">
      <div className="bg-white rounded-xl shadow p-6">
        <Hourglass tag={TAG} />
      </div>
    </div>
  );
}
