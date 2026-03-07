import DialogBox from "@/components/DialogBox";
import RoundedButton from "@/components/RoundedButton";
import { useCommittee } from "@/context/CommitteeContext";
import { Edit } from "lucide-react";
import { useState, type ReactNode } from "react";
import { useNavigate } from "react-router-dom";

interface BodyProps {
  children: ReactNode;
  trailing?: ReactNode;
  footer?: ReactNode;
}

export default function Body({ children, trailing, footer }: BodyProps) {
  const navigate = useNavigate();
  const { committee, setAgenda } = useCommittee();
  const [agendaDialogOpen, setAgendaDialogOpen] = useState(false);
  const [tempAgenda, setTempAgenda] = useState(committee.agenda);

  return (
    <div className="flex flex-col h-full">
      <div className="flex-1 p-4">
        <div className="flex items-center h-12 mb-6">
          <div className="flex items-center gap-3">
            <span>
              <strong>Agenda: </strong>
              {committee.agenda}
            </span>
            <button
              onClick={() => {
                setTempAgenda(committee.agenda);
                setAgendaDialogOpen(true);
              }}
              className="p-1 border border-amber-400 rounded-lg hover:bg-amber-50"
              title="Set Agenda"
            >
              <Edit size={16} className="text-amber-400" />
            </button>
          </div>
          <div className="flex-1" />
          {trailing}
          <div className="w-3" />
          <RoundedButton onClick={() => {}}>Save</RoundedButton>
          <div className="w-3" />
          <RoundedButton
            onClick={() => navigate("/", { replace: true })}
            color="#f87171"
          >
            End
          </RoundedButton>
        </div>
        {children}
      </div>
      {footer}

      <DialogBox
        open={agendaDialogOpen}
        onClose={() => setAgendaDialogOpen(false)}
        heading="Set Agenda"
      >
        <input
          className="w-full border rounded-lg px-3 py-2 mb-4"
          value={tempAgenda}
          onChange={(e) => setTempAgenda(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter") {
              setAgenda(tempAgenda);
              setAgendaDialogOpen(false);
            }
          }}
          autoFocus
          placeholder="Agenda"
        />
        <RoundedButton
          style="border"
          className="border-amber-400 text-amber-400"
          onClick={() => {
            setAgenda(tempAgenda);
            setAgendaDialogOpen(false);
          }}
        >
          Select
        </RoundedButton>
      </DialogBox>
    </div>
  );
}
