import type { IconType } from "react-icons"
import { RiOpenaiFill } from "react-icons/ri"
import { SiAnthropic, SiDeepseek, SiGooglegemini } from "react-icons/si"

const PROVIDER_ICONS: Record<string, IconType> = {
  openai: RiOpenaiFill,
  anthropic: SiAnthropic,
  "google-gemini": SiGooglegemini,
  deepseek: SiDeepseek,
}

export function ProviderIcon({
  iconKey,
  className,
}: Readonly<{ iconKey: string; className?: string }>) {
  const Icon = PROVIDER_ICONS[iconKey]
  if (!Icon) return null
  return <Icon className={className} aria-hidden="true" />
}
