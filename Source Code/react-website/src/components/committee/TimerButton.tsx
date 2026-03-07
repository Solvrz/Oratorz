import { Minus, Plus } from 'lucide-react';

interface Props {
  value: number;
  subtitle: string;
  onChange: (delta: number) => void;
}

export default function TimerButton({ value, subtitle, onChange }: Props) {
  return (
    <div className="flex flex-col items-center">
      <div className="flex items-center bg-white rounded-lg border shadow-sm">
        <input
          type="text"
          className="w-14 text-center text-2xl font-bold py-2 border-none focus:outline-none text-gray-700"
          value={value.toString().padStart(2, '0')}
          onChange={(e) => {
            const val = parseInt(e.target.value) || 0;
            if (val >= 0 && val < 60) onChange(val - value);
          }}
        />
        <div className="flex flex-col border-l">
          <button
            onClick={() => onChange(1)}
            className="px-2 py-1 hover:bg-gray-100 border-b"
          >
            <Plus size={14} />
          </button>
          <button
            onClick={() => onChange(-1)}
            className="px-2 py-1 hover:bg-gray-100"
          >
            <Minus size={14} />
          </button>
        </div>
      </div>
      <span className="text-xs text-gray-500 tracking-widest mt-1">{subtitle}</span>
    </div>
  );
}
