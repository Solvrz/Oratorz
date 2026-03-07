import OratorzBanner from "@/components/OratorzBanner";
import RoundedButton from "@/components/RoundedButton";
import { useNavigate } from "react-router-dom";

export default function ErrorPage() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen flex flex-col">
      <div className="h-[11vh] bg-[url('/images/Banner.png')] bg-repeat-x bg-cover backdrop-blur-sm flex items-center px-6">
        <OratorzBanner />
      </div>
      <div className="flex-1 flex">
        <div className="flex-1 flex flex-col justify-center px-12">
          <span className="bg-[#afbfdc] text-white px-4 py-2 rounded-full text-sm font-medium w-fit mb-4">
            Page not found
          </span>
          <h1 className="text-5xl font-bold mb-4">Oops! Error 404</h1>
          <p className="text-gray-500 text-lg mb-8">
            The page you are looking for could not be found. Please go back!
          </p>
          <RoundedButton
            onClick={() => navigate("/home", { replace: true })}
            className="w-full"
          >
            Back to Homepage
          </RoundedButton>
        </div>
        <div className="flex-1 flex items-center justify-center">
          <img
            src="/images/Error.png"
            alt="Error"
            className="max-h-full object-contain"
          />
        </div>
      </div>
    </div>
  );
}
