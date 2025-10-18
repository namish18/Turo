import { AuthForm } from "@/components/auth-form";

export default function AuthenticationPage() {
  return (
    <div className="relative flex min-h-screen w-full flex-col items-center justify-center bg-background">
      <div
        className="absolute inset-0 z-0"
        style={{
          background:
            "radial-gradient(ellipse 80% 60% at 50% 0%, rgba(251, 191, 36, 0.25), transparent 70%), #000000",
        }}
      />
      <div className="relative z-10">
        <AuthForm />
      </div>
    </div>
  );
}