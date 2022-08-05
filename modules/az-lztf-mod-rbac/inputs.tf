variable custom_role_definitions {
  type = list(object({
    name              = string
    description       = string
    scope             = string
    assignable_scopes = list(string)
    permissions = object({
      actions          = list(string)
      not_actions      = list(string)
      data_actions     = list(string)
      not_data_actions = list(string)
    })
  }))
  description = "List of objects defining the role definitions"
  default = [
    {
      name        = ""
      description = ""
      scope       = ""
      assignable_scopes = []
      permissions = {
        actions          = []
        not_actions      = ["*"]
        data_actions     = []
        not_data_actions = []
      }
    }
  ]
}

variable "role_assignments" {
  type = list(object({
    definition_scope     = string
    role_definition_name = string
    role_definition_id   = string
    assignment_scope     = string
    principal_id         = string
  }))
  description = "List of objects defining the role assignments. definition_name and definition_id are mutually excluded"
  default = [
    {
      definition_scope     = ""
      role_definition_name = "Reader"
      role_definition_id   = null
      assignment_scope     = ""
      principal_id         = ""
    },
    {
      definition_scope     = ""
      role_definition_name = null
      role_definition_id   = ""
      assignment_scope     = ""
      principal_id         = ""
    }
  ]
}
