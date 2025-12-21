package kubernetes.admission

import future.keywords.in

deny[msg] {
  input.request.kind.kind == "Deployment"
  not input.request.object.metadata.labels.team
  msg := "Deployments must have 'team' label"
}

deny[msg] {
  input.request.kind.kind == "Deployment"
  not input.request.object.metadata.labels.environment
  msg := "Deployments must have 'environment' label"
}
