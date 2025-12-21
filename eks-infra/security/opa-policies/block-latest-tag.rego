package kubernetes.admission

import future.keywords.in

# Block deployments using :latest tag
deny[msg] {
  input.request.kind.kind == "Deployment"
  container := input.request.object.spec.template.spec.containers[_]
  endswith(lower(container.image), ":latest")
  msg := sprintf("Container '%s' in '%s' uses forbidden ':latest' image tag", [container.name, input.request.name])
}

# Block deployments without image digest
deny[msg] {
  input.request.kind.kind == "Deployment"
  container := input.request.object.spec.template.spec.containers[_]
  not startswith(container.image, "sha256:")
  msg := sprintf("Container '%s' in '%s' must use image digest or specific tag (not ':latest')", [container.name, input.request.name])
}
