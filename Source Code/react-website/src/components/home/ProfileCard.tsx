import { auth } from "@/config/firebase";
import { logOut } from "@/services/auth";
import {
  HelpCircle,
  Home,
  LogOut,
  Settings as SettingsIcon,
  User,
} from "lucide-react";
import { useNavigate } from "react-router-dom";

export default function ProfileCard({ isHome }: { isHome: boolean }) {
  const navigate = useNavigate();

  const handleSignOut = async () => {
    await logOut();
    navigate("/signin", { replace: true });
  };

  return (
    <div className="bg-white rounded-xl shadow p-6 w-64 flex flex-col min-h-full">
      {isHome ? (
        <>
          <div className="flex justify-center">
            <div className="w-28 h-28 rounded-full bg-gray-800 flex items-center justify-center">
              <User className="text-gray-400" size={48} />
            </div>
          </div>
          <div className="text-center mt-5">
            <p className="text-base text-gray-500">Welcome Back,</p>
            <p className="text-xl font-semibold">
              {auth.currentUser?.displayName ?? "User"}
            </p>
          </div>
        </>
      ) : (
        <button
          onClick={() => navigate("/home")}
          className="flex items-center gap-2 p-2 rounded-lg hover:bg-gray-100 text-left"
        >
          <Home size={20} className="text-secondary" />
          <span>Home</span>
        </button>
      )}

      <div className="flex-1" />

      {isHome && (
        <button
          onClick={() => navigate("/settings")}
          className="flex items-center gap-3 p-3 rounded-lg hover:bg-gray-100 mb-1"
        >
          <SettingsIcon size={22} className="text-secondary" />
          <span className="text-base">Settings</span>
        </button>
      )}
      <button
        onClick={() => {}}
        className="flex items-center gap-3 p-3 rounded-lg hover:bg-gray-100 mb-3"
      >
        <HelpCircle size={22} className="text-secondary" />
        <span className="text-base">Help</span>
      </button>
      <button
        onClick={handleSignOut}
        className="flex items-center gap-3 p-4 rounded-lg bg-red-600 text-white hover:opacity-90"
      >
        <LogOut size={22} />
        <span className="text-base">Sign Out</span>
      </button>
    </div>
  );
}
