import { Navigate, Route, Routes } from "react-router-dom"
import { AuthProvider } from "../providers/AuthProvider"
import { Toaster } from "@/components/ui/sonner"
import { TooltipProvider } from "@/components/ui/tooltip"
import AdminLayout from "../features/admin/components/AdminLayout"
import ProtectedRoute from "../features/admin/components/ProtectedRoute"
import LoginPage from "../features/admin/pages/LoginPage"
import DashboardPage from "../features/admin/pages/DashboardPage"
import AccountPage from "../features/admin/pages/AccountPage"
import SessionsPage from "../features/sessions/SessionsPage"
import SessionWorkspacePage from "../features/sessions/SessionWorkspacePage"
import PresetsPage from "../features/presets/PresetsPage"
import PresetDetailPage from "../features/presets/PresetDetailPage"
import CapabilitiesPage from "../features/capabilities/CapabilitiesPage"

export default function AdminRoutes() {
  return (
    <AuthProvider>
      <TooltipProvider>
        <Toaster richColors closeButton position="bottom-right" theme="dark" />
        <Routes>
          <Route path="login" element={<LoginPage />} />
          <Route
            element={
              <ProtectedRoute>
                <AdminLayout />
              </ProtectedRoute>
            }
          >
            <Route index element={<DashboardPage />} />
            <Route path="sessions" element={<SessionsPage />} />
            <Route path="sessions/:id" element={<SessionWorkspacePage />} />
            <Route path="presets" element={<PresetsPage />} />
            <Route
              path="presets/:key/:version"
              element={<PresetDetailPage />}
            />
            <Route path="integrations" element={<CapabilitiesPage />} />
            <Route path="capabilities" element={<Navigate to="/integrations" replace />} />
            <Route path="account" element={<AccountPage />} />
            <Route path="*" element={<Navigate to="/" replace />} />
          </Route>
        </Routes>
      </TooltipProvider>
    </AuthProvider>
  )
}
