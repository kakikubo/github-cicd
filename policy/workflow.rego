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

deny_job_timeout_minutes_missing contains msg if { # timeout-minutesが未設定のジョブを拒否（Reusable Workflowsの呼び出しジョブは指定不可のため除外）
  some name, job in input.jobs
  not job.uses
  not job["timeout-minutes"]
  msg = sprintf("Job timeout-minutes is missing: %v", [name])
}
