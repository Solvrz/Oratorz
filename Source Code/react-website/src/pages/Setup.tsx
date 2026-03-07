import DelegateTile from "@/components/DelegateTile";
import DialogBox from "@/components/DialogBox";
import RoundedButton from "@/components/RoundedButton";
import { AIPPM, COMMITTEES, COUNTRIES, DELEGATES, TYPES } from "@/config/data";
import { auth } from "@/config/firebase";
import { useApp } from "@/context/AppContext";
import {
  createCommitteeInCloud,
  fetchCommittee,
} from "@/services/cloudStorage";
import * as storage from "@/services/localStorage";
import {
  createCommittee,
  initRollCall,
  type Committee,
} from "@/types/committee";
import {
  ArrowLeft,
  ChevronDown,
  ChevronRight,
  Edit,
  Minus,
  Plus,
  Search,
  Send,
} from "lucide-react";
import { useEffect, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";

export default function SetupPage() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const { user, addCommittee } = useApp();
  const editId = searchParams.get("id");

  const [committee, setCommittee] = useState<Committee>(() => {
    const saved = storage.loadSetup();
    const email = auth.currentUser?.email ?? "";
    const base = saved ?? createCommittee();
    if (base.members.length === 0 || base.members[0] !== email) {
      base.members = [email, ...base.members.filter((m) => m !== email)];
    }
    return base;
  });
  const [showOptions, setShowOptions] = useState(false);
  const [selectedType, setSelectedType] = useState(0);
  const [search, setSearch] = useState("");
  const [publishing, setPublishing] = useState(false);

  // Name dialog state
  const [nameDialogOpen, setNameDialogOpen] = useState(false);
  const [tempName, setTempName] = useState("");

  // Template dialog state
  const [templateDialogOpen, setTemplateDialogOpen] = useState(false);

  useEffect(() => {
    if (editId) {
      fetchCommittee(editId).then((fetched) => {
        if (fetched) setCommittee(fetched);
      });
    }
  }, [editId]);

  const delegateLists: { title: string; delegates: string[] }[] = [
    { title: "UN Member States", delegates: Object.keys(COUNTRIES) },
    { title: "AIPPM Members", delegates: Object.keys(AIPPM) },
  ];

  const addDelegate = (delegate: string) => {
    if (committee.delegates.includes(delegate)) return;
    const updated = [...committee.delegates, delegate].sort((a, b) =>
      (DELEGATES[a] ?? a).localeCompare(DELEGATES[b] ?? b),
    );
    const newCommittee = { ...committee, delegates: updated };
    setCommittee({
      ...newCommittee,
      rollCall: initRollCall(newCommittee),
    });
  };

  const removeDelegate = (index: number) => {
    const updated = committee.delegates.filter((_, i) => i !== index);
    const newCommittee = { ...committee, delegates: updated };
    setCommittee({
      ...newCommittee,
      rollCall: initRollCall(newCommittee),
    });
  };

  const fromTemplate = (template: string) => {
    const delegates = (COMMITTEES[template] ?? [])
      .slice()
      .sort((a, b) => (DELEGATES[a] ?? a).localeCompare(DELEGATES[b] ?? b));
    const newCommittee = {
      ...committee,
      name: template,
      type: template,
      delegates,
    };
    setCommittee({
      ...newCommittee,
      rollCall: initRollCall(newCommittee),
    });
  };

  const handlePublish = async () => {
    if (committee.days.length === 0) {
      alert("Please select at least one committee day");
      return;
    }
    if (committee.days.some((d) => d === null)) {
      alert("Please select dates for all committee days");
      return;
    }
    const emailRegex = /^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$/;
    if (committee.members.some((m) => !emailRegex.test(m))) {
      alert("Please provide valid emails for members");
      return;
    }
    setPublishing(true);
    const updatedUser = !editId
      ? {
          ...user!,
          committeeIds: [...user!.committeeIds, committee.id],
        }
      : user!;
    await createCommitteeInCloud(committee, updatedUser);
    if (!editId) addCommittee(committee);
    storage.clearSetup();
    setPublishing(false);
    navigate(`/gsl?id=${committee.id}`);
  };

  const filteredDelegates = (delegates: string[]) =>
    delegates.filter((d) =>
      search
        ? (DELEGATES[d] ?? d).toLowerCase().includes(search.toLowerCase())
        : true,
    );

  if (!showOptions) {
    // DELEGATES STEP
    return (
      <div className="min-h-screen bg-white">
        <div className="bg-secondary text-white p-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <button onClick={() => navigate(-1)} className="hover:opacity-80">
              <ArrowLeft size={22} />
            </button>
            <h1 className="text-xl font-semibold">Setup Committee</h1>
          </div>
          {!editId && (
            <RoundedButton
              onClick={() => storage.saveSetup(committee)}
              style="border"
              className="border-white text-white"
            >
              Save
            </RoundedButton>
          )}
        </div>
        <div className="flex p-4 gap-9 h-[calc(100vh-64px)]">
          {/* Left: Load / New */}
          <div className="flex-1 flex flex-col gap-3 overflow-hidden">
            {/* Load Committee */}
            <div className="bg-white rounded-xl shadow p-4">
              <h2 className="text-lg font-semibold mb-3">Load Committee</h2>
              <div className="flex gap-4">
                <RoundedButton
                  style="border"
                  className="flex-1"
                  color="#f59e0b"
                  onClick={() => {}}
                >
                  From File
                </RoundedButton>
                <RoundedButton
                  style="border"
                  className="flex-1"
                  color="#f59e0b"
                  onClick={() => setTemplateDialogOpen(true)}
                >
                  From Template
                </RoundedButton>
              </div>
            </div>
            {/* New Committee */}
            <div className="flex-1 bg-white rounded-xl shadow p-4 flex flex-col overflow-hidden">
              <h2 className="text-lg font-semibold mb-2">
                Set Up New Committee
              </h2>
              {delegateLists.map(({ title, delegates }, idx) => {
                const isOpen = selectedType === idx;
                return (
                  <div
                    key={idx}
                    className={`${isOpen ? "flex-1 flex flex-col overflow-hidden" : ""}`}
                  >
                    <button
                      onClick={() => setSelectedType(idx)}
                      className="flex items-center gap-1 p-2 hover:bg-gray-50 rounded"
                    >
                      {isOpen ? (
                        <ChevronDown size={20} />
                      ) : (
                        <ChevronRight size={20} />
                      )}
                      <span className="font-semibold">{title}</span>
                    </button>
                    {isOpen && (
                      <>
                        <div className="relative mx-3 mb-2">
                          <Search
                            size={16}
                            className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"
                          />
                          <input
                            className="w-full pl-9 pr-3 py-2 border rounded-lg text-sm"
                            placeholder="Search"
                            value={search}
                            onChange={(e) => setSearch(e.target.value)}
                            autoFocus
                          />
                        </div>
                        <div className="flex-1 overflow-y-auto">
                          {filteredDelegates(delegates).map((delegate) => {
                            const added =
                              committee.delegates.includes(delegate);
                            return (
                              <div
                                key={delegate}
                                className={`${added ? "opacity-60" : "cursor-pointer"} border-b border-gray-100`}
                                onClick={() => !added && addDelegate(delegate)}
                              >
                                <DelegateTile
                                  delegate={delegate}
                                  trailing={
                                    !added ? (
                                      <Plus
                                        size={16}
                                        className="text-gray-400"
                                      />
                                    ) : undefined
                                  }
                                />
                              </div>
                            );
                          })}
                        </div>
                      </>
                    )}
                  </div>
                );
              })}
            </div>
          </div>

          {/* Right: Committee Card */}
          <div className="flex-1 bg-white rounded-xl shadow p-6 flex flex-col overflow-hidden">
            <div className="flex items-center gap-3 mb-1">
              <h2 className="text-xl font-semibold">{committee.name}</h2>
              <button
                onClick={() => {
                  setTempName(committee.name);
                  setNameDialogOpen(true);
                }}
                className="p-1 border border-amber-400 rounded-lg hover:bg-amber-50"
              >
                <Edit size={16} className="text-amber-400" />
              </button>
            </div>
            <p className="text-gray-500 text-lg mb-3">
              {committee.delegates.length} Delegates
            </p>
            <div className="flex-1 overflow-y-auto">
              {committee.delegates.map((delegate, index) => (
                <div key={delegate} className="flex items-center">
                  <div className="flex-1">
                    <DelegateTile delegate={delegate} />
                  </div>
                  <button
                    onClick={() => removeDelegate(index)}
                    className="p-1 text-red-400 hover:bg-red-50 rounded"
                  >
                    <Minus size={16} />
                  </button>
                </div>
              ))}
            </div>
            <div className="mt-4 flex flex-col gap-3">
              <RoundedButton
                style="border"
                onClick={() =>
                  setCommittee({
                    ...committee,
                    delegates: [],
                    name: "Your Committee",
                    rollCall: {},
                  })
                }
              >
                Reset Selection
              </RoundedButton>
              <RoundedButton
                onClick={() => {
                  if (committee.delegates.length === 0) {
                    alert("Add at least 1 delegate to continue");
                    return;
                  }
                  setShowOptions(true);
                }}
              >
                Configure Options
              </RoundedButton>
            </div>
          </div>
        </div>

        {/* Name Dialog */}
        <DialogBox
          open={nameDialogOpen}
          onClose={() => setNameDialogOpen(false)}
          heading="Set Committee Name"
        >
          <input
            className="w-full border rounded-lg px-3 py-2 mb-4"
            value={tempName}
            onChange={(e) => setTempName(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") {
                setCommittee({ ...committee, name: tempName });
                setNameDialogOpen(false);
              }
            }}
            autoFocus
          />
          <RoundedButton
            style="border"
            color="#f59e0b"
            onClick={() => {
              setCommittee({ ...committee, name: tempName });
              setNameDialogOpen(false);
            }}
          >
            Select
          </RoundedButton>
        </DialogBox>

        {/* Template Dialog */}
        <DialogBox
          open={templateDialogOpen}
          onClose={() => setTemplateDialogOpen(false)}
          heading="Select Template"
        >
          <div className="max-h-96 overflow-y-auto">
            {Object.entries(COMMITTEES).map(([name, delegates]) => (
              <button
                key={name}
                onClick={() => {
                  fromTemplate(name);
                  setTemplateDialogOpen(false);
                }}
                className="w-full text-left p-3 hover:bg-gray-100 border-b border-gray-200"
              >
                {name} ({delegates.length})
              </button>
            ))}
          </div>
        </DialogBox>
      </div>
    );
  }

  // OPTIONS STEP
  return (
    <div className="min-h-screen bg-white">
      <div className="bg-secondary text-white p-4 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <button
            onClick={() => setShowOptions(false)}
            className="hover:opacity-80"
          >
            <ArrowLeft size={22} />
          </button>
          <h1 className="text-xl font-semibold">Setup Committee</h1>
        </div>
        {!editId && (
          <RoundedButton
            onClick={() => storage.saveSetup(committee)}
            style="border"
            className="border-white text-white"
          >
            Save
          </RoundedButton>
        )}
      </div>
      <div className="flex p-4 gap-9 h-[calc(100vh-64px)]">
        {/* Left: Members + Days */}
        <div className="flex-1 flex flex-col gap-3 overflow-hidden">
          {/* Members Card */}
          <div className="flex-1 bg-white rounded-xl shadow p-4 flex flex-col overflow-hidden">
            <h2 className="text-lg font-semibold mb-2">Set Members</h2>
            <div className="flex-1 overflow-y-auto">
              {committee.members.map((member, index) => (
                <div key={index} className="flex items-center gap-3 px-4 py-2">
                  <div className="w-8 h-8 shrink-0 rounded-full bg-gray-800 text-gray-400 flex items-center justify-center text-sm">
                    {index + 1}
                  </div>
                  <input
                    className="flex-1 min-w-0 border-b border-gray-300 py-1 text-sm focus:outline-none focus:border-secondary"
                    placeholder="Member's Email"
                    value={member}
                    disabled={index === 0}
                    onChange={(e) => {
                      const updated = [...committee.members];
                      updated[index] = e.target.value;
                      setCommittee({ ...committee, members: updated });
                    }}
                  />
                  {index > 0 && (
                    <>
                      <button
                        title="Remove member"
                        className="p-2 bg-red-400 rounded-lg text-white shrink-0"
                        onClick={() => {
                          const updated = committee.members.filter(
                            (_, i) => i !== index,
                          );
                          setCommittee({ ...committee, members: updated });
                        }}
                      >
                        <Minus size={16} />
                      </button>
                      <button
                        title="Send email"
                        className="p-2 bg-secondary rounded-lg text-white shrink-0"
                        onClick={() => {
                          const email = committee.members[index];
                          if (email)
                            window.open(`mailto:${encodeURIComponent(email)}`);
                        }}
                      >
                        <Send size={16} />
                      </button>
                    </>
                  )}
                </div>
              ))}
            </div>
            <RoundedButton
              style="border"
              className="mt-2"
              color="#f59e0b"
              onClick={() =>
                setCommittee({
                  ...committee,
                  members: [...committee.members, ""],
                })
              }
            >
              + Add a new Member
            </RoundedButton>
          </div>

          {/* Days Card */}
          <div className="flex-1 bg-white rounded-xl shadow p-4 flex flex-col overflow-hidden">
            <h2 className="text-lg font-semibold mb-2">Set Days</h2>
            <div className="flex-1 overflow-y-auto">
              {committee.days.map((day, index) => (
                <div key={index} className="flex items-center gap-3 px-4 py-2">
                  <span className="font-semibold">Day {index + 1}</span>
                  <div className="flex-1" />
                  <input
                    type="date"
                    className="border rounded-lg px-3 py-1 text-sm text-gray-500"
                    value={day ? day.toString().split("T")[0] : ""}
                    onChange={(e) => {
                      const updated = [...committee.days];
                      updated[index] = e.target.value
                        ? new Date(e.target.value)
                        : null;
                      // Clear later dates
                      for (let i = index + 1; i < updated.length; i++)
                        updated[i] = null;
                      setCommittee({ ...committee, days: updated });
                    }}
                  />
                  <button
                    className="p-2 bg-red-400 rounded-lg text-white shrink-0"
                    onClick={() => {
                      const updated = committee.days.filter(
                        (_, i) => i !== index,
                      );
                      setCommittee({ ...committee, days: updated });
                    }}
                  >
                    <Minus size={16} />
                  </button>
                </div>
              ))}
            </div>
            <RoundedButton
              style="border"
              className="mt-2"
              color="#f59e0b"
              onClick={() =>
                setCommittee({ ...committee, days: [...committee.days, null] })
              }
            >
              + Add another Day
            </RoundedButton>
          </div>
        </div>

        {/* Right: Info Card */}
        <div className="flex-1 bg-white rounded-xl shadow p-6 flex flex-col">
          <h2 className="text-lg font-semibold mb-3">Other Info</h2>
          <div className="flex items-center gap-3 mb-4">
            <span className="font-semibold">Committee Type:</span>
            <select
              className="border rounded-lg px-3 py-2 text-sm"
              value={committee.type}
              onChange={(e) =>
                setCommittee({ ...committee, type: e.target.value })
              }
            >
              {TYPES.map((type) => (
                <option key={type} value={type}>
                  {type}
                </option>
              ))}
            </select>
          </div>
          <div className="flex-1" />
          <div className="flex flex-col gap-3">
            <RoundedButton
              style="border"
              onClick={() => {
                const email = auth.currentUser?.email ?? "";
                setCommittee({ ...committee, members: [email], days: [] });
              }}
            >
              Reset Options
            </RoundedButton>
            <RoundedButton style="border" onClick={() => setShowOptions(false)}>
              Configure Delegates
            </RoundedButton>
            <RoundedButton onClick={handlePublish} disabled={publishing}>
              {publishing ? "Publishing..." : "Publish Committee"}
            </RoundedButton>
          </div>
        </div>
      </div>
    </div>
  );
}
