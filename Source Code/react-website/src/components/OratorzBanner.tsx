interface OratorzBannerProps {
  isSmall?: boolean;
  light?: boolean;
}

export default function OratorzBanner({ isSmall, light }: OratorzBannerProps) {
  return (
    <div
      className={`flex items-center justify-center ${isSmall ? "" : "mb-4"}`}
    >
      <div className="flex items-center justify-center gap-2 bg-white rounded-[10px] px-5 py-3 shadow w-full">
        <img
          src="/images/Logo.svg"
          alt="Oratorz"
          className={isSmall ? "w-7 h-7" : "w-9 h-9"}
        />
        <div
          className={`font-medium ${light ? "text-white" : "text-secondary"} ${isSmall ? "text-xl" : "text-3xl"}`}
        >
          Oratorz
        </div>
      </div>
    </div>
  );
}
