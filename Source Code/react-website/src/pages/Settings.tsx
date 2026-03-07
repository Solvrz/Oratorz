import ProfileCard from "@/components/home/ProfileCard";
import InputField from "@/components/InputField";
import OratorzBanner from "@/components/OratorzBanner";
import RoundedButton from "@/components/RoundedButton";
import { auth } from "@/config/firebase";
import { useApp } from "@/context/AppContext";
import { updateUserInCloud } from "@/services/cloudStorage";
import { sendPasswordResetEmail } from "firebase/auth";
import { User } from "lucide-react";
import { useState } from "react";

export default function SettingsPage() {
  const { user, setUser } = useApp();
  const [firstName, setFirstName] = useState(user?.firstName ?? "");
  const [lastName, setLastName] = useState(user?.lastName ?? "");
  const [role, setRole] = useState(0);
  const [resetSent, setResetSent] = useState(false);
  const [saving, setSaving] = useState(false);
  const [saveMessage, setSaveMessage] = useState("");

  const handleResetPassword = async () => {
    const email = auth.currentUser?.email;
    if (email) {
      await sendPasswordResetEmail(auth, email);
      setResetSent(true);
    }
  };

  const handleSave = async () => {
    if (!user) return;
    setSaving(true);
    const updatedUser = { ...user, firstName, lastName };
    setUser(updatedUser);
    await updateUserInCloud(updatedUser);
    setSaveMessage("User details updated successfully!");
    setSaving(false);
    setTimeout(() => setSaveMessage(""), 3000);
  };

  return (
    <div className="min-h-screen relative">
      <div className="absolute top-0 left-0 right-0 h-[11vh] overflow-hidden">
        <div className="absolute inset-0 bg-[url('/images/Banner.png')] bg-repeat-x bg-cover" />
        <div className="absolute inset-0 backdrop-blur-[3px]" />
      </div>
      <div className="relative flex px-4 py-4 gap-5 min-h-screen">
        <ProfileCard isHome={false} />
        <div className="flex-1 flex flex-col pt-1">
          <OratorzBanner />
          <div className="mt-8 flex-1 overflow-y-auto">
            <div className="py-4">
              <div className="flex justify-between items-center mb-2">
                <div>
                  <h2 className="text-xl font-semibold">Account</h2>
                  <p className="text-gray-500 text-sm">Manage your profile</p>
                </div>
                <div className="flex items-center gap-3">
                  {saveMessage && (
                    <span className="text-sm text-green-600">
                      {saveMessage}
                    </span>
                  )}
                  <RoundedButton
                    onClick={handleSave}
                    disabled={saving}
                    color={saving ? "#607D8B" : undefined}
                  >
                    {saving ? "Saving..." : "Save"}
                  </RoundedButton>
                </div>
              </div>
              <hr className="border-gray-200 my-6" />

              <div className="flex items-center gap-4 mb-8">
                <div className="w-24 h-24 rounded-full bg-gray-800 flex items-center justify-center">
                  <User className="text-gray-400" size={42} />
                </div>
                <div>
                  <p className="font-semibold text-lg">Profile Picture</p>
                  <p className="text-sm text-gray-400">PNG, JPG upto 5MB</p>
                  <button className="text-sm font-bold text-amber-400 hover:underline mt-1">
                    Update
                  </button>
                </div>
              </div>

              <h3 className="text-xl font-semibold mb-4">Details</h3>
              <div className="flex gap-5">
                <InputField
                  label="First Name"
                  value={firstName}
                  onChange={setFirstName}
                  placeholder="First Name"
                  className="flex-1"
                />
                <InputField
                  label="Last Name"
                  value={lastName}
                  onChange={setLastName}
                  placeholder="Last Name"
                  className="flex-1"
                />
              </div>

              <div className="flex items-center gap-3 py-4">
                <span className="text-lg font-semibold">Role:</span>
                <select
                  value={role}
                  onChange={(e) => setRole(Number(e.target.value))}
                  className="border border-gray-400 rounded-[10px] px-4 py-2 bg-transparent text-sm focus:outline-none"
                >
                  <option value={0}>Option 1</option>
                  <option value={1}>Option 2</option>
                </select>
              </div>

              <hr className="border-gray-200 my-6" />

              <h3 className="text-xl font-semibold mb-4">Authentication</h3>
              <button
                onClick={handleResetPassword}
                className="text-sm text-tertiary border border-tertiary rounded-lg px-4 py-2 hover:bg-tertiary/10"
              >
                {resetSent ? "Password reset link sent!" : "Reset Password"}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
