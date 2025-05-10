package main
import rego.v1

deny_workflow_permissions contains msg if { # ワークフローレベルのpermissionが省略されていたら拒否
  not input.permissions
  msg = "Workflow permissions are missing"
}

deny_workflow_permission_are_not_empty contains msg if { # ワークフローレベルのpermissionsで空以外が指定されていたら拒否
  input.permissions != {}
  msg = sprintf("Workflow permissions are not empty: %v", [input.permissions])
}
