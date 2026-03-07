import OratorzBanner from "@/components/OratorzBanner";
import CommitteesSection from "@/components/home/CommitteesSection";
import ProfileCard from "@/components/home/ProfileCard";
import { useApp } from "@/context/AppContext";
import { logOut } from "@/services/auth";
import { sendEmailVerification } from "firebase/auth";
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

export default function HomePage() {
  const { firebaseUser } = useApp();
  const navigate = useNavigate();
  const [emailSent, setEmailSent] = useState(false);

  useEffect(() => {
    if (firebaseUser && !firebaseUser.emailVerified) {
      // show verification banner
    }
  }, [firebaseUser]);

  if (firebaseUser && !firebaseUser.emailVerified) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center p-8">
        <OratorzBanner />
        <div className="mt-8 text-center max-w-md">
          <h2 className="text-2xl font-bold mb-4">Account Not Verified!</h2>
          <p className="text-gray-600 mb-6">
            The account for '{firebaseUser.email ?? ""}' is not verified! Check
            your inbox for the verification email or log in to another account.
          </p>
          <div className="flex flex-col items-center gap-2">
            <button
              className="text-tertiary font-medium hover:underline"
              onClick={async () => {
                await sendEmailVerification(firebaseUser);
                setEmailSent(true);
              }}
              disabled={emailSent}
            >
              {emailSent
                ? "Verification Email Sent!"
                : "Resend Verification Email"}
            </button>
            <button
              className="text-tertiary font-medium hover:underline"
              onClick={async () => {
                await logOut();
                navigate("/signin", { replace: true });
              }}
            >
              Log In to another account
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen relative">
      <div className="absolute top-0 left-0 right-0 h-[11vh] overflow-hidden">
        <div className="absolute inset-0 bg-[url('/images/Banner.png')] bg-repeat-x bg-cover" />
        <div className="absolute inset-0 backdrop-blur-[3px]" />
      </div>
      <div className="relative flex px-4 py-4 gap-5 min-h-screen">
        <ProfileCard isHome />
        <div className="flex-1 flex flex-col pt-1">
          <OratorzBanner />
          <div className="mt-8 flex-1 overflow-y-auto">
            <CommitteesSection />
          </div>
        </div>
      </div>
    </div>
  );
}
