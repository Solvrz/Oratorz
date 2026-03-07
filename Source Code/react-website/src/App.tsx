import { useApp } from '@/context/AppContext';
import CommitteePage from '@/pages/committee/CommitteePage';
import AdjournMode from '@/pages/committee/modes/Adjourn';
import ConsultationMode from '@/pages/committee/modes/Consultation';
import CustomMode from '@/pages/committee/modes/Custom';
import GSLMode from '@/pages/committee/modes/GSL';
import ModMode from '@/pages/committee/modes/Mod';
import PrayerMode from '@/pages/committee/modes/Prayer';
import SingleMode from '@/pages/committee/modes/Single';
import TourDeTableMode from '@/pages/committee/modes/TourDeTable';
import UnmodMode from '@/pages/committee/modes/Unmod';
import ModesPage from '@/pages/committee/ModesPage';
import MotionsPage from '@/pages/committee/Motions';
import ScorecardPage from '@/pages/committee/Scorecard';
import VotePage from '@/pages/committee/Vote';
import ErrorPage from '@/pages/Error';
import HomePage from '@/pages/Home';
import SettingsPage from '@/pages/Settings';
import SetupPage from '@/pages/Setup';
import SignInPage from '@/pages/SignIn';
import SignUpPage from '@/pages/SignUp';
import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { firebaseUser, loading } = useApp();
  if (loading) return <div className="flex h-screen items-center justify-center"><div className="animate-spin h-8 w-8 border-4 border-secondary border-t-transparent rounded-full" /></div>;
  if (!firebaseUser) return <Navigate to="/signin" replace />;
  return <>{children}</>;
}

function AuthRoute({ children }: { children: React.ReactNode }) {
  const { firebaseUser, loading } = useApp();
  if (loading) return <div className="flex h-screen items-center justify-center"><div className="animate-spin h-8 w-8 border-4 border-secondary border-t-transparent rounded-full" /></div>;
  if (firebaseUser) return <Navigate to="/home" replace />;
  return <>{children}</>;
}

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Navigate to="/home" replace />} />
        <Route path="/signin" element={<AuthRoute><SignInPage /></AuthRoute>} />
        <Route path="/signup" element={<AuthRoute><SignUpPage /></AuthRoute>} />
        <Route path="/home" element={<ProtectedRoute><HomePage /></ProtectedRoute>} />
        <Route path="/settings" element={<ProtectedRoute><SettingsPage /></ProtectedRoute>} />
        <Route path="/setup" element={<ProtectedRoute><SetupPage /></ProtectedRoute>} />
        <Route element={<ProtectedRoute><CommitteePage /></ProtectedRoute>}>
          <Route element={<ModesPage />}>
            <Route path="/gsl" element={<GSLMode />} />
            <Route path="/mod" element={<ModMode />} />
            <Route path="/unmod" element={<UnmodMode />} />
            <Route path="/consultation" element={<ConsultationMode />} />
            <Route path="/prayer" element={<PrayerMode />} />
            <Route path="/adjournment" element={<AdjournMode />} />
            <Route path="/tourdetable" element={<TourDeTableMode />} />
            <Route path="/single" element={<SingleMode />} />
            <Route path="/custom" element={<CustomMode />} />
          </Route>
          <Route path="/vote" element={<VotePage />} />
          <Route path="/motions" element={<MotionsPage />} />
          <Route path="/score" element={<ScorecardPage />} />
        </Route>
        <Route path="*" element={<ErrorPage />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
