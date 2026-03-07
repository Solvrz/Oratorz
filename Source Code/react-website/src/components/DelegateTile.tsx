import { DELEGATES } from "@/config/data";

interface DelegateTileProps {
  delegate: string;
  trailing?: React.ReactNode;
  onClick?: () => void;
  selected?: boolean;
}

export default function DelegateTile({
  delegate,
  trailing,
  onClick,
  selected,
}: DelegateTileProps) {
  const name = DELEGATES[delegate] ?? delegate;
  const flagCode = delegate.split(" ")[0];

  return (
    <div
      onClick={onClick}
      className={`flex items-center gap-3 px-3 py-2 rounded-lg cursor-pointer transition-colors ${
        selected ? "bg-tertiary/10" : "hover:bg-gray-100"
      }`}
    >
      <div className="w-10 h-10 rounded-full bg-white shadow flex items-center justify-center text-xs font-bold text-secondary overflow-hidden">
        <img
          src={`/flags/${flagCode}.png`}
          alt={flagCode}
          className="w-7 h-7 object-contain"
          onError={(e) => {
            (e.target as HTMLImageElement).style.display = "none";
          }}
        />
      </div>
      <span className="flex-1 text-sm font-medium truncate">{name}</span>
      {trailing}
    </div>
  );
}
