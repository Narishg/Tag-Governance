resource "azurerm_policy_definition" "addTagToRG" {
  count = length(var.mandatory_tag_keys)

  name         = "addTagToRG_${var.mandatory_tag_keys[count.index]}"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Add tag ${var.mandatory_tag_keys[count.index]} to resource group"
  description  = "Adds the mandatory tag key ${var.mandatory_tag_keys[count.index]} when any resource group missing this tag is created or updated. \nExisting resource groups can be remediated by triggering a remediation task.\nIf the tag exists with a different value it will not be changed."

  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Resources/subscriptions/resourceGroups"
          },
          {
            "field" : "[concat('tags[', parameters('tagName'), ']')]",
            "exists" : "false"
          }
        ]
      },
      "then" : {
        "effect" : "modify",
        "details" : {
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "operations" : [
            {
              "operation" : "add",
              "field" : "[concat('tags[', parameters('tagName'), ']')]",
              "value" : "[parameters('tagValue')]"
            }
          ]
        }
      }
    }
  )
  parameters = jsonencode(
    {
      "tagName" : {
        "type" : "String",
        "metadata" : {
          "displayName" : "Mandatory Tag ${var.mandatory_tag_keys[count.index]}",
          "description" : "Name of the tag, such as ${var.mandatory_tag_keys[count.index]}"
        },
        "defaultValue" : "${var.mandatory_tag_keys[count.index]}"
      },
      "tagValue" : {
        "type" : "String",
        "metadata" : {
          "displayName" : "Tag Value '${var.mandatory_tag_value[count.index]}'",
          "description" : "Value of the tag, such as '${var.mandatory_tag_value[count.index]}'"
        },
        "defaultValue" : "'${var.mandatory_tag_value[count.index]}'"
      }
    }
  )
}
