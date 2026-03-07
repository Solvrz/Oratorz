import DelegateTile from "@/components/DelegateTile";
import DialogBox from "@/components/DialogBox";
import RoundedButton from "@/components/RoundedButton";
import RollCallButton from "@/components/committee/RollCallButton";
import { useCommittee } from "@/context/CommitteeContext";
import { RollCall } from "@/types/committee";

interface Props {
  open: boolean;
  onClose: () => void;
}

export default function RollCallDialog({ open, onClose }: Props) {
  const {
    committee,
    setRollCall,
    setAllPresent,
    setAllAbsent,
    setAllPresentAndVoting,
  } = useCommittee();

  return (
    <DialogBox open={open} onClose={onClose} heading="Roll Call">
      {committee.delegates.length > 0 ? (
        <div className="flex flex-col h-[60vh]">
          <div className="flex gap-4 mb-2">
            <RoundedButton
              style="border"
              className="flex-1"
              onClick={setAllPresent}
            >
              SET ALL PRESENT
            </RoundedButton>
            <RoundedButton
              style="border"
              className="flex-1"
              onClick={setAllAbsent}
            >
              SET ALL ABSENT
            </RoundedButton>
          </div>
          <RoundedButton
            style="border"
            className="w-full mb-3"
            onClick={setAllPresentAndVoting}
          >
            SET ALL PRESENT & VOTING
          </RoundedButton>
          <div className="flex-1 overflow-y-auto">
            {committee.delegates.map((delegate) => {
              const rollCall = committee.rollCall[delegate] ?? RollCall.absent;
              return (
                <div key={delegate} className="flex items-center mb-1">
                  <div className="flex-1">
                    <DelegateTile delegate={delegate} />
                  </div>
                  <div className="flex gap-1">
                    <RollCallButton
                      value="PV"
                      selected={rollCall === RollCall.presentAndVoting}
                      onClick={() =>
                        setRollCall(delegate, RollCall.presentAndVoting)
                      }
                    />
                    <RollCallButton
                      value="P"
                      selected={rollCall === RollCall.present}
                      onClick={() => setRollCall(delegate, RollCall.present)}
                    />
                    <RollCallButton
                      value="A"
                      selected={rollCall === RollCall.absent}
                      onClick={() => setRollCall(delegate, RollCall.absent)}
                    />
                  </div>
                </div>
              );
            })}
          </div>
          <RoundedButton className="w-full mt-3" onClick={onClose}>
            DONE
          </RoundedButton>
        </div>
      ) : (
        <p className="text-center py-8">No delegates in the committee.</p>
      )}
    </DialogBox>
  );
}
