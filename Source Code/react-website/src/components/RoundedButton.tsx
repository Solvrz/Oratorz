import type { ReactNode } from "react";

type ButtonStyle = "fill" | "border" | "empty";

interface RoundedButtonProps {
  children: ReactNode;
  style?: ButtonStyle;
  onClick?: () => void;
  disabled?: boolean;
  color?: string;
  tooltip?: string;
  className?: string;
}

export default function RoundedButton({
  children,
  style = "fill",
  onClick,
  disabled,
  color = "var(--color-secondary)",
  tooltip,
  className = "",
}: RoundedButtonProps) {
  const baseClasses =
    "rounded-[10px] px-4 py-2 font-medium transition-all cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed";

  const styleClasses =
    style === "fill"
      ? "text-white"
      : style === "border"
        ? "bg-white"
        : "bg-transparent border-none";

  return (
    <button
      onClick={onClick}
      disabled={disabled}
      title={tooltip}
      className={`${baseClasses} ${styleClasses} ${className}`}
      style={{
        backgroundColor:
          style === "fill"
            ? color
            : style === "border"
              ? "white"
              : "transparent",
        color: style === "fill" ? "white" : color,
        border: style === "empty" ? "none" : `1px solid ${color}`,
      }}
    >
      {children}
    </button>
  );
}
