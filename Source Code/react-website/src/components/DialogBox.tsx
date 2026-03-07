import type { ReactNode } from "react";

interface DialogBoxProps {
  open: boolean;
  onClose?: () => void;
  heading: string;
  children: ReactNode;
  barrierDismissible?: boolean;
}

export default function DialogBox({
  open,
  onClose,
  heading,
  children,
  barrierDismissible = true,
}: DialogBoxProps) {
  if (!open) return null;

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/40"
      onClick={barrierDismissible ? onClose : undefined}
    >
      <div
        className="bg-white rounded-xl shadow-xl p-6 max-w-lg w-full mx-4 max-h-[80vh] overflow-y-auto"
        onClick={(e) => e.stopPropagation()}
      >
        <h2 className="text-xl font-bold mb-4">{heading}</h2>
        {children}
      </div>
    </div>
  );
}
