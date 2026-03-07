import DialogBox from "@/components/DialogBox";
import RoundedButton from "@/components/RoundedButton";
import { useApp } from "@/context/AppContext";
import { deleteCommitteeFromCloud } from "@/services/cloudStorage";
import * as storage from "@/services/localStorage";
import type { Committee } from "@/types/committee";
import { Edit, Trash2 } from "lucide-react";
import { useState } from "react";
import { useNavigate } from "react-router-dom";

const COMMITTEE_COLORS: Record<string, string> = {
  AIPPM: "rgba(233, 55, 10, 0.7)",
  ASEAN: "rgba(237, 41, 57, 0.7)",
  AU: "rgba(192, 162, 101, 0.7)",
  Custom: "#0d1520",
  ECOSOC: "rgba(214, 157, 54, 0.7)",
  EU: "#003A94",
  G20: "rgba(83, 106, 125, 0.7)",
  NATO: "rgba(0, 36, 125, 0.7)",
  UNGA: "rgba(36, 134, 205, 0.7)",
  UNHCR: "rgba(115, 110, 176, 0.7)",
  UNHRC: "rgba(25, 113, 177, 0.84)",
  UNICEF: "rgba(71, 136, 200, 0.7)",
  UNSC: "rgba(115, 197, 255, 0.7)",
  WHO: "rgba(7, 152, 255, 0.7)",
};

function formatDate(value: unknown): string {
  const date =
    value instanceof Date ? value : new Date(value as number | string);
  return `${date.getDate()}/${date.getMonth() + 1}/${date.getFullYear()}`;
}

function datePlaceholder(days: (Date | null)[]): string {
  const now = new Date();
  for (let i = 0; i < days.length; i++) {
    if (days[i] == null) continue;
    const dayDate = days[i]!;

    if (now > dayDate) {
      const nextDay = new Date(dayDate);
      nextDay.setDate(nextDay.getDate() + 1);
      if (now < nextDay) return `Continue Day ${i + 1}`;
    } else {
      return `Day ${i + 1} starts on ${formatDate(dayDate)}`;
    }
  }
  return days.length > 0 && days[days.length - 1] != null
    ? `Ended on ${formatDate(new Date(days[days.length - 1]!))}`
    : "";
}

export default function CommitteeCard({ committee }: { committee: Committee }) {
  const navigate = useNavigate();
  const { deleteCommittee, user } = useApp();
  const [isDeleting, setIsDeleting] = useState(false);
  const [hovered, setHovered] = useState(false);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);

  const bgColor = COMMITTEE_COLORS[committee.type] ?? "#0d1520";

  const handleOpen = () => {
    if (isDeleting) return;
    storage.saveCommitteeData(
      committee.id,
      committee as unknown as Record<string, unknown>,
    );
    navigate(`/gsl?id=${committee.id}`);
  };

  const handleDelete = async () => {
    setDeleteDialogOpen(false);
    setIsDeleting(true);
    deleteCommittee(committee.id);
    if (user) await deleteCommitteeFromCloud(committee, user);
    setIsDeleting(false);
  };

  return (
    <div
      className="flex items-stretch transition-transform duration-150 origin-left"
      style={{ transform: hovered ? "scale(1.05)" : "scale(1)" }}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
    >
      <button
        onClick={handleOpen}
        disabled={isDeleting}
        className="relative w-64 h-44 rounded-xl overflow-hidden text-white text-left"
        style={{ backgroundColor: bgColor }}
      >
        <img
          src={`/logos/${committee.type}.png`}
          alt=""
          className="absolute -right-[40%] top-0 h-full opacity-40 pointer-events-none"
          onError={(e) => {
            (e.target as HTMLImageElement).style.display = "none";
          }}
        />
        <div className="absolute inset-0 p-3 flex flex-col">
          <h3 className="text-lg font-semibold">{committee.name}</h3>
          <p className="text-sm">{datePlaceholder(committee.days)}</p>
          <div className="flex-1" />
          <p className="text-base opacity-70">{committee.type}</p>
        </div>
        {isDeleting && (
          <div className="absolute inset-0 bg-white/50 flex items-center justify-center">
            <div className="animate-spin h-8 w-8 border-4 border-secondary border-t-transparent rounded-full" />
          </div>
        )}
      </button>
      {hovered && (
        <div className="ml-2 bg-white rounded-xl shadow p-2 flex flex-col justify-evenly transition-opacity">
          <button
            onClick={() => navigate(`/setup?id=${committee.id}`)}
            className="p-2 hover:bg-gray-100 rounded-lg"
          >
            <Edit size={22} />
          </button>
          <hr className="border-gray-300" />
          <button
            onClick={() => setDeleteDialogOpen(true)}
            className="p-2 hover:bg-gray-100 rounded-lg"
          >
            <Trash2 size={22} className="text-red-400" />
          </button>
        </div>
      )}

      <DialogBox
        open={deleteDialogOpen}
        onClose={() => setDeleteDialogOpen(false)}
        heading="Delete Committee"
      >
        <p className="text-center mb-6">
          Are you sure you want to delete this committee?
        </p>
        <div className="flex gap-8">
          <RoundedButton
            style="border"
            className="flex-1"
            onClick={() => setDeleteDialogOpen(false)}
          >
            No
          </RoundedButton>
          <RoundedButton className="flex-1" onClick={handleDelete}>
            Yes
          </RoundedButton>
        </div>
      </DialogBox>
    </div>
  );
}
