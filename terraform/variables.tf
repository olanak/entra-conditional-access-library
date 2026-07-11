variable "tenant_id" {
  type        = string
  description = "Entra tenant ID"
}

variable "break_glass_object_ids" {
  type        = list(string)
  description = "Object IDs of break-glass accounts, excluded from every CA policy"
}

variable "protected_service_principal_ids" {
  type        = list(string)
  description = "Object IDs of single-tenant service principals to protect with CA (requires Workload Identities Premium)"
  default     = [] # populate when the Workload ID license is available
}

variable "sensitive_app_ids" {
  type        = list(string)
  description = "App IDs treated as sensitive (shorter session lifetime)"
  default     = ["797f4846-ba00-4fd7-ba43-dac1f8f63013"] # Windows Azure Service Management API (Azure portal/ARM)
}

variable "admin_role_template_ids" {
  type        = map(string)
  description = "Entra role template IDs for admin-scoped policies"
  default = {
    global_admin          = "62e90394-69f5-4237-9190-012177145e10"
    privileged_role_admin = "e8611ab8-c189-46e8-94e1-60213ab1f814"
    security_admin        = "194ae4cb-b126-40b2-bd5b-6091b380977d"
    sharepoint_admin      = "f28a1f50-f6e7-4571-818b-6a12f2af6b6c"
    exchange_admin        = "29232cdf-9323-42fd-ade2-1d097af3e4de"
  }


}