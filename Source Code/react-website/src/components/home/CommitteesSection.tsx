import { useApp } from "@/context/AppContext";
import { fetchCommittee } from "@/services/cloudStorage";
import type { Committee } from "@/types/committee";
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import CommitteeCard from "./CommitteeCard";

export default function CommitteesSection() {
  const { user } = useApp();
  const navigate = useNavigate();
  const [committees, setCommittees] = useState<Committee[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!user) return;
    const loadCommittees = async () => {
      setLoading(true);
      const results: Committee[] = [];
      for (const id of user.committeeIds) {
        const existing = user.committees.find((c) => c.id === id);
        if (existing) {
          results.push(existing);
        } else {
          const fetched = await fetchCommittee(id);
          if (fetched) results.push(fetched);
        }
      }
      setCommittees(results);
      setLoading(false);
    };
    loadCommittees();
  }, [user]);

  return (
    <div className="mt-6">
      <h2 className="text-xl font-semibold mb-4">Your Committees</h2>
      {loading ? (
        <div className="flex justify-center py-8">
          <div className="animate-spin h-8 w-8 border-4 border-secondary border-t-transparent rounded-full" />
        </div>
      ) : (
        <div className="flex flex-wrap gap-4 items-center">
          {committees.map((committee) => (
            <CommitteeCard key={committee.id} committee={committee} />
          ))}
          <button
            onClick={() => navigate("/setup")}
            className="h-44 w-40 rounded-xl border-3 border-dashed border-gray-400 flex items-center justify-center hover:border-gray-600 transition-colors group"
          >
            <span className="text-center text-gray-500 group-hover:text-gray-700 text-lg font-semibold px-2">
              Start a New Committee
            </span>
          </button>
        </div>
      )}
    </div>
  );
}
