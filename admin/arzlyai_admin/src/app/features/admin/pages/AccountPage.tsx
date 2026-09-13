import { useState, type SyntheticEvent } from "react";
import { useMutation } from "@tanstack/react-query";
import { Loader2 } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { ApiError } from "../../../shared/api/http";
import { PageHeader } from "../../../shared/components/PageHeader";
import { useAuth } from "../../../providers/AuthProvider";
import { changePassword } from "../account.service";

export default function AccountPage() {
  const { logout, user } = useAuth();
  const [currentPassword, setCurrentPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");

  const mutation = useMutation({
    mutationFn: () => changePassword(currentPassword, newPassword),
    onSuccess: async () => {
      toast.success("Password changed. Sign in again.");
      await logout();
    },
    onError: (error) =>
      toast.error("Could not change password", {
        description:
          error instanceof ApiError ? error.message : "Unexpected error",
      }),
  });

  const handleSubmit = (e: SyntheticEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (newPassword !== confirmPassword) {
      toast.error("New passwords do not match");
      return;
    }
    if (newPassword.length < 12) {
      toast.error("New password must be at least 12 characters");
      return;
    }
    mutation.mutate();
  };

  return (
    <div className="mx-auto max-w-xl space-y-6">
      <PageHeader
        title="Account"
        description={user ? `Signed in as ${user.email}` : undefined}
      />

      <Card>
        <CardHeader>
          <CardTitle>Change password</CardTitle>
          <CardDescription>
            Changing your password revokes refresh tokens. Access tokens on
            other sessions remain valid until they expire. You will be signed
            out here on success and must sign in again.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="current-password">Current password</Label>
              <Input
                id="current-password"
                type="password"
                autoComplete="current-password"
                value={currentPassword}
                onChange={(e) => setCurrentPassword(e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="new-password">New password</Label>
              <Input
                id="new-password"
                type="password"
                autoComplete="new-password"
                value={newPassword}
                onChange={(e) => setNewPassword(e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="confirm-password">Confirm new password</Label>
              <Input
                id="confirm-password"
                type="password"
                autoComplete="new-password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                required
              />
            </div>
            <Button
              type="submit"
              disabled={
                mutation.isPending ||
                !currentPassword ||
                !newPassword ||
                !confirmPassword
              }
              className="bg-gradient-primary text-primary-foreground"
            >
              {mutation.isPending ? (
                <Loader2 className="size-4 animate-spin" />
              ) : null}
              Update password
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
