export interface AdminUser {
  adminId: string
  email: string
  displayName: string
}

export interface AuthTokens {
  accessToken: string
  accessTokenExpiresAtUtc: string
  refreshToken: string
  refreshTokenExpiresAtUtc: string
}

export interface AdminAuthenticationResponse extends AdminUser, AuthTokens {}
