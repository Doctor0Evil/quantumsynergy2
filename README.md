# QuantumSynergy2 ALN Core

QuantumSynergy2 `aln-core` is the reference ALN runtime service wired for zero‑downtime rollouts, policy‑driven compliance, and multi‑arch container delivery.

## Features

- Multi‑arch images built via Docker Buildx and pushed to GHCR.
- Helm chart for staging and prod namespaces (`aln-staging`, `aln-ecosystem`).
- Kyverno and OPA policies for secrets hygiene and trusted registries.
- Argo Rollout template for blue/green promotion.
- Prometheus `/metrics` endpoint with ready/health probes.

## Repository layout

- `ci/workflows/deploy.yml` – GitHub Actions pipeline (build, scan, deploy).
- `ci/policies/` – Kyverno and OPA policies.
- `ci/templates/` – Argo Rollout and Grafana dashboard JSON.
- `helm/aln-ecosystem/` – Helm chart for `aln-core`.
- `k8s-manifests/` – Namespaces and SOPS‑encrypted secrets.
- `src/` – ALN source modules.

## Prerequisites

- Kubernetes cluster with:
  - `kubectl` access.
  - Helm 3 installed.
  - Kyverno and an OPA/Gatekeeper‑compatible admission controller.
- GitHub Container Registry access (`ghcr.io`).
- SOPS key material for decrypting `k8s-manifests/secrets.enc.yaml`.

## Local build

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg ALN_VERSION=6.0.0 \
  -t ghcr.io/<org>/<repo>/aln-core:local \
  .
CI/CD flow
Push to develop:

Build and scan container image.

Deploy to aln-staging via Helm.

Verify staging:

/health returns 200.

/ready reports all pods Ready.

/metrics exports Prometheus metrics.

Merge to main:

Promote image to aln-ecosystem namespace.

Argo Rollout handles traffic shifting.

Observability:

Prometheus scrapes aln-core metrics.

Grafana uses ci/templates/grafana-aln.json.

Loki tails app=aln-core logs.

Security and compliance
Secrets must be managed through SOPS‑encrypted manifests.

Images must originate from the configured trusted registry (ghcr.io/).

Resource requests/limits enforced at admission via Kyverno.
