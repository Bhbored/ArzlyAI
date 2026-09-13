export interface ValidationIssue {
  path: string
  message: string
}

export interface ValidationResult {
  errors: ValidationIssue[]
  isValid?: boolean
}

export function isValidationValid(result: ValidationResult | null | undefined) {
  if (!result) return false
  if (typeof result.isValid === "boolean") return result.isValid
  return (result.errors?.length ?? 0) === 0
}
