package kubernetes.admission

default deny = []

trusted_registry_prefixes := [
  "ghcr.io/"
]

deny[msg] {
  input.review.object.kind == "Pod"
  container := input.review.object.spec.containers[_]
  image := container.image
  not startswith_any(image, trusted_registry_prefixes)
  msg := sprintf("Image %v not from trusted registry", [image])
}

startswith_any(image, prefixes) {
  some i
  prefix := prefixes[i]
  startswith(image, prefix)
}
