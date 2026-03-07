import { auth, db } from "@/config/firebase";
import { fetchCommittee } from "@/services/cloudStorage";
import { type Committee } from "@/types/committee";
import { userFromJson, type User } from "@/types/user";
import { onAuthStateChanged, type User as FirebaseUser } from "firebase/auth";
import { doc, getDoc } from "firebase/firestore";
import {
  createContext,
  useContext,
  useEffect,
  useState,
  type ReactNode,
} from "react";

interface AppContextType {
  firebaseUser: FirebaseUser | null;
  user: User | null;
  setUser: (user: User | null) => void;
  loading: boolean;
  addCommittee: (committee: Committee) => void;
  deleteCommittee: (committeeId: string) => void;
  fetchUserCommittees: () => Promise<void>;
}

const AppContext = createContext<AppContextType | null>(null);

export function AppProvider({ children }: { children: ReactNode }) {
  const [firebaseUser, setFirebaseUser] = useState<FirebaseUser | null>(null);
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (fbUser) => {
      setFirebaseUser(fbUser);
      if (fbUser) {
        const snap = await getDoc(doc(db, "users", fbUser.email!));
        if (snap.exists()) {
          setUser(userFromJson(snap.data()));
        }
      } else {
        setUser(null);
      }
      setLoading(false);
    });
    return unsubscribe;
  }, []);

  const addCommittee = (committee: Committee) => {
    if (!user) return;
    setUser({
      ...user,
      committees: [...user.committees, committee],
      committeeIds: [...user.committeeIds, committee.id],
    });
  };

  const deleteCommitteeHandler = (committeeId: string) => {
    if (!user) return;
    setUser({
      ...user,
      committees: user.committees.filter((c) => c.id !== committeeId),
      committeeIds: user.committeeIds.filter((id) => id !== committeeId),
    });
  };

  const fetchUserCommittees = async () => {
    if (!user) return;
    const committees: Committee[] = [];
    for (const id of user.committeeIds) {
      const existing = user.committees.find((c) => c.id === id);
      if (existing) {
        committees.push(existing);
      } else {
        const fetched = await fetchCommittee(id);
        if (fetched) committees.push(fetched);
      }
    }
    setUser({ ...user, committees });
  };

  return (
    <AppContext.Provider
      value={{
        firebaseUser,
        user,
        setUser,
        loading,
        addCommittee,
        deleteCommittee: deleteCommitteeHandler,
        fetchUserCommittees,
      }}
    >
      {children}
    </AppContext.Provider>
  );
}

export function useApp() {
  const context = useContext(AppContext);
  if (!context) throw new Error("useApp must be used within AppProvider");
  return context;
}
