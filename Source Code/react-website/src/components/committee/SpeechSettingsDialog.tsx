import DialogBox from '@/components/DialogBox';
import RoundedButton from '@/components/RoundedButton';
import TimerButton from '@/components/committee/TimerButton';
import { createSpeechState, useCommittee } from '@/context/CommitteeContext';
import { useState } from 'react';

interface Props {
  open: boolean;
  onClose: () => void;
  tag: string;
}

export default function SpeechSettingsDialog({ open, onClose, tag }: Props) {
  const { speeches, updateSpeech } = useCommittee();
  const speech = speeches[tag] ?? createSpeechState();
  const subtopicKey = Object.keys(speech.subtopic)[0] ?? '';
  const [subtopicValue, setSubtopicValue] = useState(speech.subtopic[subtopicKey] ?? '');

  const durationMinutes = Math.floor(speech.duration / 60);
  const durationSeconds = speech.duration % 60;
  const overallMinutes = Math.floor(speech.overallDuration / 60);
  const overallSeconds = speech.overallDuration % 60;

  const changeDuration = (delta: number) => {
    updateSpeech(tag, (prev) => ({
      ...prev,
      duration: Math.max(0, prev.duration + delta),
    }));
  };

  const changeOverallDuration = (delta: number) => {
    updateSpeech(tag, (prev) => ({
      ...prev,
      overallDuration: Math.max(0, prev.overallDuration + delta),
    }));
  };

  const handleSave = () => {
    if (subtopicKey) {
      updateSpeech(tag, (prev) => ({
        ...prev,
        subtopic: { [subtopicKey]: subtopicValue.trim() },
      }));
    }
    onClose();
  };

  return (
    <DialogBox open={open} onClose={onClose} heading="Settings">
      {subtopicKey && (
        <>
          <h4 className="font-semibold mb-2">{subtopicKey}</h4>
          <input
            className="w-full border rounded-lg px-3 py-2 mb-4"
            value={subtopicValue}
            onChange={(e) => setSubtopicValue(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleSave()}
            placeholder={subtopicKey}
            autoFocus
          />
        </>
      )}

      <h4 className="font-semibold mb-2">Speaker Time</h4>
      <div className="flex gap-4 mb-4 ml-2">
        <TimerButton
          value={durationMinutes}
          subtitle="MINUTES"
          onChange={(delta) => {
            if (durationMinutes + delta >= 0 && durationMinutes + delta <= 60) changeDuration(delta * 60);
          }}
        />
        <TimerButton
          value={durationSeconds}
          subtitle="SECONDS"
          onChange={(delta) => changeDuration(delta)}
        />
      </div>

      {speech.overallDuration > 0 && (
        <>
          <h4 className="font-semibold mb-2">Caucus Time</h4>
          <div className="flex gap-4 mb-4 ml-2">
            <TimerButton
              value={overallMinutes}
              subtitle="MINUTES"
              onChange={(delta) => {
                if (overallMinutes + delta >= 0 && overallMinutes + delta <= 60) changeOverallDuration(delta * 60);
              }}
            />
            <TimerButton
              value={overallSeconds}
              subtitle="SECONDS"
              onChange={(delta) => changeOverallDuration(delta)}
            />
          </div>
        </>
      )}

      <div className="flex justify-end">
        <RoundedButton style="border" className="border-amber-400 text-amber-400" onClick={handleSave}>
          Change
        </RoundedButton>
      </div>
    </DialogBox>
  );
}
