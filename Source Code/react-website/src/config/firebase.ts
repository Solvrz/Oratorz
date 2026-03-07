import { getAnalytics } from "firebase/analytics";
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey:
    import.meta.env.VITE_FIREBASE_API_KEY ??
    "AIzaSyDuLF8uzcD51hS9fiJKYzZHX5uWFvBuVmg",
  authDomain: "oratorz37.firebaseapp.com",
  projectId: "oratorz37",
  storageBucket: "oratorz37.appspot.com",
  messagingSenderId: "349136834707",
  appId: "1:349136834707:web:3d6d0d62fca250d6cebd66",
  measurementId: "G-Q6TCZ1SW7D",
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
export const analytics = getAnalytics(app);

export default app;
