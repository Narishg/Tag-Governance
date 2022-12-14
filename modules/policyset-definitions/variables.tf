variable "custom_policies_tag_governance" {
  type        = list(map(string))
  description = "List of custom policy definitions for the tag_governance policyset"
  default     = []
}
variable "policyset_definition_category" {
  type        = string
  description = "The category to use for all Policy Definitions"
  default     = "Custom"
}