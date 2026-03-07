import InputField, { PasswordField } from "@/components/InputField";
import RoundedButton from "@/components/RoundedButton";
import { useApp } from "@/context/AppContext";
import { signUp } from "@/services/auth";
import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";

export default function SignUpPage() {
  const navigate = useNavigate();
  const { setUser } = useApp();
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [firstNameError, setFirstNameError] = useState("");
  const [lastNameError, setLastNameError] = useState("");
  const [emailError, setEmailError] = useState("");
  const [passwordError, setPasswordError] = useState("");
  const [loading, setLoading] = useState(false);

  const emailRegex = /^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/;
  const nameRegex = /^[a-zA-Z]+$/;

  const validate = () => {
    let valid = true;
    if (firstName.trim().length === 0) {
      setFirstNameError("Required");
      valid = false;
    } else if (!nameRegex.test(firstName.trim())) {
      setFirstNameError("Enter a valid name");
      valid = false;
    } else setFirstNameError("");
    if (lastName.trim().length === 0) {
      setLastNameError("Required");
      valid = false;
    } else if (!nameRegex.test(lastName.trim())) {
      setLastNameError("Enter a valid name");
      valid = false;
    } else setLastNameError("");
    if (!email) {
      setEmailError("Required");
      valid = false;
    } else if (!emailRegex.test(email)) {
      setEmailError("Enter a valid email address");
      valid = false;
    } else setEmailError("");
    if (!password) {
      setPasswordError("Required");
      valid = false;
    } else if (
      !/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{6,}$/.test(password)
    ) {
      setPasswordError(
        "Use atleast 1 digit, 1 special character and min. 6 characters in total",
      );
      valid = false;
    } else setPasswordError("");
    return valid;
  };

  const handleSubmit = async () => {
    if (!validate()) return;
    setLoading(true);
    const result = await signUp(
      firstName.trim(),
      lastName.trim(),
      email,
      password,
    );
    setLoading(false);
    if (result.success && result.user) {
      setUser(result.user);
      navigate("/home", { replace: true });
    } else {
      setEmailError(result.error ?? "Sign up failed");
    }
  };

  return (
    <div className="min-h-screen flex">
      <div className="flex-[5] flex flex-col px-14 py-4">
        <div className="flex items-center gap-2 -ml-8">
          <img src="/images/Logo.svg" alt="Oratorz" className="w-9 h-9" />
          <span className="text-3xl font-medium text-secondary">Oratorz</span>
        </div>
        <div className="flex-1 flex flex-col justify-center">
          <h1 className="text-3xl font-bold mb-2">Get Started Now!</h1>
          <p className="text-gray-500 mb-2">
            Have an account?{" "}
            <Link
              to="/signin"
              className="text-tertiary font-semibold hover:underline"
            >
              Sign In
            </Link>
          </p>
          <div className="h-16" />

          <div className="flex gap-4">
            <InputField
              label="First Name"
              value={firstName}
              onChange={setFirstName}
              error={firstNameError}
              placeholder="First name"
              className="flex-1 min-w-0"
            />
            <InputField
              label="Last Name"
              value={lastName}
              onChange={setLastName}
              error={lastNameError}
              placeholder="Last name"
              className="flex-1 min-w-0"
            />
          </div>
          <InputField
            label="Email"
            value={email}
            onChange={setEmail}
            error={emailError}
            type="email"
            placeholder="Enter your email"
          />
          <PasswordField
            label="Password"
            value={password}
            onChange={setPassword}
            error={passwordError}
            placeholder="Create a password"
          />
          <div className="mt-6">
            <RoundedButton
              onClick={handleSubmit}
              disabled={loading}
              className="w-full"
            >
              {loading ? "Creating Account..." : "Sign Up"}
            </RoundedButton>
          </div>
        </div>
        <p className="text-center text-gray-500 text-sm pb-4">
          <span className="text-base">®</span> 2026 Solvrz Inc., All Rights
          Reserved
        </p>
      </div>
      <div className="flex-[4] bg-[url('/images/Login.png')] bg-repeat-x bg-cover" />
    </div>
  );
}
