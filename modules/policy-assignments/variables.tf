data "azurerm_subscription" "current" {
}

variable "tag_governance_policyset_id" {
  type        = string
  description = "The policy set definition id for tag_governance"
}

