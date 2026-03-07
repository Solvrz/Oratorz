interface RollCallButtonProps {
  value: "PV" | "P" | "A";
  selected: boolean;
  onClick: () => void;
}

const COLORS = {
  PV: {
    filled: "bg-blue-500 text-white border-blue-500",
    outline: "border-blue-500 text-blue-500 bg-white",
  },
  P: {
    filled: "bg-amber-400 text-white border-amber-400",
    outline: "border-amber-400 text-amber-400 bg-white",
  },
  A: {
    filled: "bg-red-400 text-white border-red-400",
    outline: "border-red-400 text-red-400 bg-white",
  },
};

export default function RollCallButton({
  value,
  selected,
  onClick,
}: RollCallButtonProps) {
  const colorClass = selected ? COLORS[value].filled : COLORS[value].outline;
  return (
    <button
      className={`rounded-lg px-5 py-2 font-semibold text-sm border transition-colors ${colorClass}`}
      onClick={onClick}
      type="button"
    >
      {value}
    </button>
  );
}
