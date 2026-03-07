import { auth, db } from "@/config/firebase";
import { createUser, userFromJson, userToJson, type User } from "@/types/user";
import {
  createUserWithEmailAndPassword,
  sendEmailVerification,
  signInWithEmailAndPassword,
  signOut,
  updateProfile,
  type UserCredential,
} from "firebase/auth";
import { doc, getDoc, setDoc } from "firebase/firestore";

export async function signIn(
  email: string,
  password: string,
): Promise<{ success: boolean; user?: User; error?: string }> {
  try {
    await signInWithEmailAndPassword(auth, email, password);
    const snap = await getDoc(doc(db, "users", email));
    if (!snap.exists()) return { success: false, error: "User data not found" };
    const user = userFromJson(snap.data());
    return { success: true, user };
  } catch (e: unknown) {
    const err = e as { code?: string };
    if (err.code === "auth/user-not-found") {
      return {
        success: false,
        error:
          "No user found for the email provided. Please check and try again.",
      };
    }
    if (
      err.code === "auth/wrong-password" ||
      err.code === "auth/invalid-credential"
    ) {
      return {
        success: false,
        error:
          "Wrong password provided for the user. Please check and try again.",
      };
    }
    return {
      success: false,
      error: "An unknown error occurred. Please try again later.",
    };
  }
}

export async function signUp(
  firstName: string,
  lastName: string,
  email: string,
  password: string,
): Promise<{ success: boolean; user?: User; error?: string }> {
  try {
    const credential: UserCredential = await createUserWithEmailAndPassword(
      auth,
      email,
      password,
    );
    const user = createUser({ firstName, lastName, email });

    await updateProfile(credential.user, {
      displayName: `${firstName} ${lastName}`,
    });
    await setDoc(doc(db, "users", email), userToJson(user));
    await sendEmailVerification(credential.user);

    return { success: true, user };
  } catch (e: unknown) {
    const err = e as { code?: string };
    if (err.code === "auth/email-already-in-use") {
      return {
        success: false,
        error:
          "The account already exists for the email provided. Please try signing in.",
      };
    }
    return {
      success: false,
      error: "An unknown error occurred. Please try again later.",
    };
  }
}

export async function logOut(): Promise<void> {
  await signOut(auth);
}
