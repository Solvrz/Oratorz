import RollCallDialog from "@/components/committee/RollCallDialog";
import { CommitteeProvider, useCommittee } from "@/context/CommitteeContext";
import * as storage from "@/services/localStorage";
import {
  committeeFromJson,
  createCommittee,
  type Committee,
} from "@/types/committee";
import {
  ArrowLeft,
  ArrowRight,
  ClipboardCheck,
  Home,
  RotateCcw,
  Scroll,
  Trophy,
  Users,
  Vote,
} from "lucide-react";
import { useEffect, useState } from "react";
import { Outlet, useNavigate, useSearchParams } from "react-router-dom";

const TABS = [
  { path: "/gsl", title: "Committee", icon: Users },
  { path: "/vote", title: "Vote", icon: Vote },
  { path: "/motions", title: "Motions", icon: Scroll },
  { path: "/score", title: "Scorecard", icon: Trophy },
];

function CommitteeShell() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const committeeId = searchParams.get("id") ?? "";
  const { committee, tab, setTab, selectedDay, prevDay, nextDay, resetDay } =
    useCommittee();
  const [rollCallOpen, setRollCallOpen] = useState(false);

  return (
    <div className="flex h-screen">
      {/* Sidebar */}
      <div className="w-52 bg-[#0F1825] text-white flex flex-col p-3 rounded-r-xl">
        <h2 className="text-center font-bold text-lg mb-2 px-2 break-words">
          {committee.name}
        </h2>
        {/* Day Picker */}
        <div className="flex items-center justify-center mb-6">
          <button
            onClick={prevDay}
            className="p-1 rounded-full hover:bg-white/10"
          >
            <ArrowLeft size={18} />
          </button>
          <span className="mx-1 text-base font-semibold">
            Day {selectedDay + 1}
          </span>
          <button
            onClick={nextDay}
            className="p-1 rounded-full hover:bg-white/10"
          >
            <ArrowRight size={18} />
          </button>
          {committee.days.length > 0 && (
            <button
              onClick={resetDay}
              className="p-1 rounded-full hover:bg-white/10 ml-1"
            >
              <RotateCcw size={16} />
            </button>
          )}
        </div>
        {TABS.map((t, index) => {
          const Icon = t.icon;
          const isActive = tab === index;
          return (
            <button
              key={t.path}
              onClick={() => {
                setTab(index);
                navigate(`${t.path}?id=${committeeId}`);
              }}
              className={`flex items-center gap-2 px-3 py-2 rounded-lg mb-1 text-sm ${
                isActive ? "bg-[#2a313b]" : "hover:bg-white/10"
              }`}
            >
              <Icon size={20} />
              <span>{t.title}</span>
            </button>
          );
        })}
        <button
          onClick={() => setRollCallOpen(true)}
          className="flex items-center gap-2 px-3 py-2 rounded-lg mb-1 text-sm hover:bg-white/10"
        >
          <ClipboardCheck size={20} />
          <span>Roll Call</span>
        </button>
        <div className="flex-1" />
        <button
          onClick={() => navigate("/home", { replace: true })}
          className="flex items-center gap-2 px-3 py-2 rounded-lg mb-4 text-sm hover:bg-white/10"
        >
          <Home size={20} />
          <span>Home</span>
        </button>
        <OratorzSection />
      </div>

      {/* Main Content */}
      <div className="flex-1 p-4 overflow-auto">
        <Outlet />
      </div>

      <RollCallDialog
        open={rollCallOpen}
        onClose={() => setRollCallOpen(false)}
      />
    </div>
  );
}

export default function CommitteePage() {
  const [searchParams] = useSearchParams();
  const committeeId = searchParams.get("id") ?? "";
  const [committee, setCommittee] = useState<Committee | null>(null);

  useEffect(() => {
    const data = storage.getCommitteeData(committeeId);
    if (data) {
      setCommittee(committeeFromJson(data));
    } else {
      setCommittee(createCommittee());
    }
  }, [committeeId]);

  if (!committee) {
    return (
      <div className="flex h-screen items-center justify-center">
        <div className="animate-spin h-8 w-8 border-4 border-secondary border-t-transparent rounded-full" />
      </div>
    );
  }

  return (
    <CommitteeProvider initialCommittee={committee}>
      <CommitteeShell />
    </CommitteeProvider>
  );
}

function OratorzSection() {
  return (
    <div className="flex flex-col items-center">
      <div className="flex items-center gap-1">
        <img
          src="/images/Logo.svg"
          alt="Oratorz"
          className="w-8 h-8 brightness-0 invert"
        />
        <span className="text-xl font-medium text-white">Oratorz</span>
      </div>
      <span className="text-sm text-white">A Unit of Solvrz Inc.</span>
    </div>
  );
}
