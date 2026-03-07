import Body from "@/components/committee/Body";
import DialogBox from "@/components/DialogBox";
import RoundedButton from "@/components/RoundedButton";
import { DELEGATES } from "@/config/data";
import {
  addParameter,
  deleteParameter,
  updateScore,
  useCommittee,
} from "@/context/CommitteeContext";
import { ChevronDown, ChevronUp } from "lucide-react";
import { useRef, useState } from "react";

const COL_DELEGATE = 240;
const COL_PARAM = 180;

export default function ScorecardPage() {
  const { committee, scorecard, setScorecard } = useCommittee();
  const [search, setSearch] = useState("");
  const [editing, setEditing] = useState(false);
  const [sort, setSort] = useState(0); // 0=none, positive id=asc, negative id=desc
  const [editDialogParam, setEditDialogParam] = useState<{
    index: number;
    title: string;
    maxScore: number;
  } | null>(null);

  // ---------- Derived ----------
  const params = scorecard.parameters;
  // Last parameter is always "Total" (maxScore 0)
  const scoreParams = params.slice(0, -1);
  const totalMaxScore = scoreParams.reduce((s, p) => s + p.maxScore, 0);

  const sortIndex = params.findIndex((p) => p.id === Math.abs(sort));

  const filteredDelegates = (() => {
    let list = [...committee.delegates];
    if (search) {
      const q = search.toLowerCase();
      list = list.filter((d) => {
        const name = DELEGATES[d] ?? d;
        return name.toLowerCase().includes(q) || d.toLowerCase().includes(q);
      });
    }
    if (sort !== 0 && sortIndex >= 0) {
      list.sort((a, b) => {
        const sa = scorecard.scores[a] ?? [];
        const sb = scorecard.scores[b] ?? [];
        const dir = sort > 0 ? 1 : -1;
        if (sortIndex === params.length - 1) {
          return (
            (sa.reduce((s, v) => s + v, 0) - sb.reduce((s, v) => s + v, 0)) *
            dir
          );
        }
        return ((sa[sortIndex] ?? 0) - (sb[sortIndex] ?? 0)) * dir;
      });
    }
    return list;
  })();

  const getTotal = (delegate: string): number =>
    (scorecard.scores[delegate] ?? []).reduce((s, v) => s + v, 0);

  // ---------- Sort helpers ----------
  const toggleSort = (paramId: number) => {
    if (Math.abs(sort) !== paramId) {
      setSort(-paramId); // descending first
    } else if (sort < 0) {
      setSort(paramId); // ascending
    } else {
      setSort(0); // reset
    }
  };

  // ---------- Parameter management ----------
  const handleAddParameter = () => {
    setScorecard((prev) => addParameter(prev, "New", 10));
  };

  const handleDeleteParameter = (index: number) => {
    setScorecard((prev) => deleteParameter(prev, index));
  };

  const handleEditParameterSubmit = () => {
    if (!editDialogParam) return;
    const { index, title, maxScore } = editDialogParam;
    setScorecard((prev) => {
      const updated = [...prev.parameters];
      updated[index] = {
        ...updated[index],
        title: title.trim() || updated[index].title,
        maxScore,
      };
      return { ...prev, parameters: updated };
    });
    setEditDialogParam(null);
  };

  const handleReorderParameter = (index: number) => {
    if (index >= scoreParams.length - 1) return;
    setScorecard((prev) => {
      const updated = [...prev.parameters];
      [updated[index], updated[index + 1]] = [
        updated[index + 1],
        updated[index],
      ];
      const newScores = Object.fromEntries(
        Object.entries(prev.scores).map(([k, v]) => {
          const arr = [...v];
          [arr[index], arr[index + 1]] = [arr[index + 1], arr[index]];
          return [k, arr];
        }),
      );
      return { parameters: updated, scores: newScores };
    });
  };

  // ---------- Table width ----------
  const tableWidth = COL_DELEGATE + COL_PARAM * (scoreParams.length + 1);

  // ---------- Footer ----------
  const footer = (
    <div className="flex items-center gap-3 px-4 py-3 bg-gray-100 rounded-lg mb-4">
      <input
        className="border rounded-lg px-3 py-2 text-sm bg-white"
        style={{ width: 350 }}
        placeholder="Search Delegate"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
      />
      <div className="flex-1" />
      {editing && (
        <>
          <RoundedButton style="border" onClick={handleAddParameter}>
            Add Parameter
          </RoundedButton>
          <div className="w-2" />
        </>
      )}
      <RoundedButton onClick={() => setEditing(!editing)}>
        {editing ? "Done" : "Edit Parameters"}
      </RoundedButton>
    </div>
  );

  return (
    <Body>
      {footer}
      <div className="flex flex-col flex-1 min-h-0">
        <div className="flex-1 overflow-auto">
          <div style={{ minWidth: tableWidth }}>
            {/* Header */}
            <div className="flex items-center" style={{ height: 50 }}>
              <div
                className="px-3 font-semibold text-lg border-r-2 border-gray-300 shrink-0"
                style={{ width: COL_DELEGATE }}
              >
                Delegate
              </div>
              {scoreParams.map((param, idx) => (
                <ParameterHeader
                  key={param.id}
                  label={`${param.title} (${param.maxScore})`}
                  isSorted={Math.abs(sort) === param.id}
                  sortDir={
                    Math.abs(sort) === param.id ? (sort > 0 ? 1 : -1) : 0
                  }
                  onSort={() => toggleSort(param.id)}
                  editing={editing}
                  onEdit={() =>
                    setEditDialogParam({
                      index: idx,
                      title: param.title,
                      maxScore: param.maxScore,
                    })
                  }
                  onReorder={() => handleReorderParameter(idx)}
                  onDelete={() => handleDeleteParameter(idx)}
                  canReorder={idx < scoreParams.length - 1}
                />
              ))}
              {/* Total column */}
              <ParameterHeader
                label={`Total (${totalMaxScore})`}
                isSorted={Math.abs(sort) === params[params.length - 1]?.id}
                sortDir={
                  Math.abs(sort) === params[params.length - 1]?.id
                    ? sort > 0
                      ? 1
                      : -1
                    : 0
                }
                onSort={() => toggleSort(params[params.length - 1]?.id)}
                editing={false}
              />
            </div>

            {/* Rows */}
            {filteredDelegates.map((delegate) => {
              const scores =
                scorecard.scores[delegate] ?? scoreParams.map(() => 0);
              return (
                <div
                  key={delegate}
                  className="flex items-center border-t border-gray-200"
                  style={{ minHeight: 56 }}
                >
                  <div
                    className="flex items-center gap-3 px-3 shrink-0"
                    style={{ width: COL_DELEGATE }}
                  >
                    <FlagAvatar delegate={delegate} />
                    <span className="text-sm font-medium truncate">
                      {DELEGATES[delegate] ?? delegate}
                    </span>
                  </div>
                  {scoreParams.map((param, idx) => (
                    <ScoreCell
                      key={param.id}
                      value={scores[idx] ?? 0}
                      maxScore={param.maxScore}
                      onChange={(v) =>
                        setScorecard((prev) =>
                          updateScore(prev, delegate, idx, v),
                        )
                      }
                    />
                  ))}
                  {/* Total */}
                  <div
                    className="text-center font-semibold shrink-0"
                    style={{ width: COL_PARAM }}
                  >
                    {getTotal(delegate)}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>

      {/* Edit Parameter Dialog */}
      <DialogBox
        open={editDialogParam !== null}
        onClose={() => setEditDialogParam(null)}
        heading="Edit Parameter"
      >
        {editDialogParam && (
          <div className="flex flex-col gap-4 min-w-72">
            <div>
              <label className="text-sm font-medium mb-1 block">Name</label>
              <input
                className="w-full border rounded-lg px-3 py-2"
                value={editDialogParam.title}
                onChange={(e) =>
                  setEditDialogParam({
                    ...editDialogParam,
                    title: e.target.value,
                  })
                }
                onKeyDown={(e) =>
                  e.key === "Enter" && handleEditParameterSubmit()
                }
                autoFocus
                placeholder="Name"
              />
            </div>
            <div>
              <label className="text-sm font-medium mb-1 block">
                Max Score
              </label>
              <input
                type="number"
                min={0}
                className="w-full border rounded-lg px-3 py-2"
                value={editDialogParam.maxScore}
                onChange={(e) =>
                  setEditDialogParam({
                    ...editDialogParam,
                    maxScore: Number(e.target.value),
                  })
                }
                onKeyDown={(e) =>
                  e.key === "Enter" && handleEditParameterSubmit()
                }
                placeholder="Max Score"
              />
            </div>
            <RoundedButton
              style="border"
              className="border-amber-400 text-amber-400"
              onClick={handleEditParameterSubmit}
            >
              Change
            </RoundedButton>
          </div>
        )}
      </DialogBox>
    </Body>
  );
}

// ---------- Sub-components ----------

function ParameterHeader({
  label,
  isSorted,
  sortDir,
  onSort,
  editing,
  onEdit,
  onReorder,
  onDelete,
  canReorder,
}: {
  label: string;
  isSorted: boolean;
  sortDir: number;
  onSort: () => void;
  editing?: boolean;
  onEdit?: () => void;
  onReorder?: () => void;
  onDelete?: () => void;
  canReorder?: boolean;
}) {
  const [hovering, setHovering] = useState(false);

  if (editing) {
    return (
      <div
        className="flex items-center justify-center gap-1 px-3 border-r-2 border-gray-300 shrink-0"
        style={{ width: COL_PARAM, height: 50 }}
        onMouseEnter={() => setHovering(true)}
        onMouseLeave={() => setHovering(false)}
      >
        <span className="font-semibold text-base text-center flex-1">
          {label}
        </span>
        {hovering && (
          <>
            {onEdit && (
              <button
                onClick={onEdit}
                className="text-gray-500 hover:text-gray-700"
                title="Edit"
              >
                <svg
                  width="16"
                  height="16"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                >
                  <path d="M17 3a2.83 2.83 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5Z" />
                </svg>
              </button>
            )}
            {canReorder && onReorder && (
              <button
                onClick={onReorder}
                className="text-gray-500 hover:text-gray-700"
                title="Move right"
              >
                <svg
                  width="16"
                  height="16"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                >
                  <path d="M5 12h14M12 5l7 7-7 7" />
                </svg>
              </button>
            )}
            {onDelete && (
              <button
                onClick={onDelete}
                className="text-red-400 hover:text-red-500"
                title="Delete"
              >
                <svg
                  width="16"
                  height="16"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                >
                  <path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                </svg>
              </button>
            )}
          </>
        )}
      </div>
    );
  }

  return (
    <div
      className="flex items-center justify-center gap-1 px-3 border-r-2 border-gray-300 shrink-0"
      style={{ width: COL_PARAM, height: 50 }}
    >
      <span className="font-semibold text-base text-center">{label}</span>
      <button
        onClick={onSort}
        className={`flex flex-col items-center rounded-full p-0.5 ${isSorted ? "bg-gray-700" : ""}`}
      >
        <ChevronUp
          size={14}
          className={
            isSorted && sortDir > 0
              ? "text-gray-200"
              : isSorted
                ? "text-gray-500"
                : "text-gray-400"
          }
        />
        <ChevronDown
          size={14}
          className={
            isSorted && sortDir < 0
              ? "text-white"
              : isSorted
                ? "text-gray-500"
                : "text-gray-400"
          }
          style={{ marginTop: -4 }}
        />
      </button>
    </div>
  );
}

function FlagAvatar({ delegate }: { delegate: string }) {
  const flagCode = delegate.split(" ")[0];
  return (
    <div className="w-10 h-10 rounded-full bg-white shadow flex items-center justify-center overflow-hidden shrink-0">
      <img
        src={`/flags/${flagCode}.png`}
        alt={flagCode}
        className="w-7 h-7 object-contain"
        onError={(e) => {
          (e.target as HTMLImageElement).style.display = "none";
        }}
      />
    </div>
  );
}

function ScoreCell({
  value,
  maxScore,
  onChange,
}: {
  value: number;
  maxScore: number;
  onChange: (v: number) => void;
}) {
  const [active, setActive] = useState(false);
  const [hovering, setHovering] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  const handleChange = (text: string) => {
    if (text.trim() === "") {
      onChange(0);
      return;
    }
    const num = parseFloat(text);
    if (isNaN(num)) return;
    if (maxScore > 0 && num > maxScore) return;
    onChange(Math.max(0, num));
  };

  if (active || hovering) {
    return (
      <div
        className="flex items-center justify-center shrink-0"
        style={{ width: COL_PARAM }}
        onMouseEnter={() => setHovering(true)}
        onMouseLeave={() => {
          setHovering(false);
          if (!active) setActive(false);
        }}
      >
        <input
          ref={inputRef}
          type="text"
          inputMode="decimal"
          defaultValue={value !== 0 ? value : ""}
          placeholder="0"
          className="w-20 border rounded px-2 py-1 text-center text-sm bg-white"
          autoFocus={active}
          onFocus={() => setActive(true)}
          onBlur={() => {
            setActive(false);
            setHovering(false);
          }}
          onChange={(e) => handleChange(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter" || e.key === "Escape") {
              (e.target as HTMLInputElement).blur();
            }
          }}
        />
      </div>
    );
  }

  return (
    <div
      className="flex items-center justify-center shrink-0 cursor-pointer"
      style={{ width: COL_PARAM }}
      onMouseEnter={() => setHovering(true)}
      onClick={() => {
        setActive(true);
        setTimeout(() => inputRef.current?.focus(), 0);
      }}
    >
      <span className="text-sm">{value}</span>
    </div>
  );
}
