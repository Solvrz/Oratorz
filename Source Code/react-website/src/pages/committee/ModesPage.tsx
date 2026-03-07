import Body from '@/components/committee/Body';
import {
    ChevronDown,
    Church,
    Circle,
    Edit2, Layers,
    MessageSquare,
    Mic,
    Pause, RefreshCw,
    Users,
} from 'lucide-react';
import { useEffect, useState } from 'react';
import { Outlet, useLocation, useNavigate, useSearchParams } from 'react-router-dom';

const MODES = [
  { path: '/gsl', title: 'GSL', icon: Users },
  { path: '/mod', title: 'Moderated Caucus', icon: MessageSquare },
  { path: '/unmod', title: 'Unmoderated Caucus', icon: Layers },
  { path: '/consultation', title: 'Consultation', icon: Circle },
  { path: '/prayer', title: 'Prayer', icon: Church },
  { path: '/adjournment', title: 'Adjourn Meeting', icon: Pause },
  { path: '/tourdetable', title: 'Tour de Table', icon: RefreshCw },
  { path: '/single', title: 'Single Speaker', icon: Mic },
  { path: '/custom', title: 'Custom', icon: Edit2 },
];

export default function ModesPage() {
  const navigate = useNavigate();
  const location = useLocation();
  const [searchParams] = useSearchParams();
  const committeeId = searchParams.get('id') ?? '';

  const [selected, setSelected] = useState(() => {
    const idx = MODES.findIndex((m) => location.pathname === m.path);
    return idx >= 0 ? idx : 0;
  });
  const [dropdownOpen, setDropdownOpen] = useState(false);

  useEffect(() => {
    const idx = MODES.findIndex((m) => location.pathname === m.path);
    if (idx >= 0) setSelected(idx);
  }, [location.pathname]);

  const Icon = MODES[selected].icon;

  return (
    <Body
      trailing={
        <div className="relative">
          <button
            onClick={() => setDropdownOpen(!dropdownOpen)}
            className="flex items-center gap-2 px-3 py-2 border border-secondary rounded-lg bg-gray-50"
          >
            <Icon size={18} className="text-tertiary" />
            <span>{MODES[selected].title}</span>
            <ChevronDown size={20} className="text-secondary ml-4" />
          </button>
          {dropdownOpen && (
            <div className="absolute right-0 top-full mt-1 bg-white rounded-xl shadow-lg border py-1 z-50 min-w-56">
              {MODES.map((mode, index) => {
                const ModeIcon = mode.icon;
                return (
                  <button
                    key={mode.path}
                    onClick={() => {
                      setSelected(index);
                      setDropdownOpen(false);
                      navigate(`${mode.path}?id=${committeeId}`);
                    }}
                    className="w-full flex items-center gap-2 px-4 py-2 hover:bg-gray-100 text-left"
                  >
                    <ModeIcon size={18} className="text-tertiary" />
                    <span>{mode.title}</span>
                  </button>
                );
              })}
            </div>
          )}
        </div>
      }
    >
      <Outlet />
    </Body>
  );
}
