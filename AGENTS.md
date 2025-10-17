# Repository Guidelines

## Project Structure & Module Organization
- Root Terraform project: all configuration lives at the repository root.
- `main.tf` wires the `hcloud-talos/talos` module, pinning Kubernetes, Talos, and Cilium versions, and provisions the control-plane load balancer.
- `variables.tf` and `terraform.tfvars` manage environment-specific inputs; keep tokens out of source control.
- `outputs.tf` exposes sensitive kubeconfig and talosconfig—treat generated files with care.
- `versions.tf` locks Terraform (>=1.6.0) and the Hetzner Cloud provider (`~> 1.47`); update deliberately.

## Build, Test, and Development Commands
```bash
terraform init                # set up providers and module dependencies
terraform fmt                 # auto-format HashiCorp Configuration Language files
terraform validate            # static checks for configuration correctness
terraform plan -var-file=terraform.tfvars # preview infrastructure changes
```
- Use `terraform apply` only after a reviewed plan.
- GitHub Actions workflow `.github/workflows/terraform.yml` runs fmt/init/validate; set repository secret `HCLOUD_TOKEN` to enable the plan stage.

## Coding Style & Naming Conventions
- Follow Terraform defaults: two-space indentation, lowercase resource names with underscores.
- Keep module variables explicit; prefer descriptive names such as `control_plane_count`.
- Tune load balancer behavior via `load_balancer_type` and `control_plane_label_selector`; document overrides in PRs.
- Always run `terraform fmt` before reviews to enforce canonical ordering and spacing.
- Pin provider and module versions in `versions.tf`/`main.tf` to avoid drift.

## Testing Guidelines
- Treat `terraform validate` and a non-drift `terraform plan` as the minimum test bar.
- Capture expected plan output for peer review; attach sanitized excerpts to PRs when helpful.
- Maintain separate `*.tfvars` files per environment; never commit secrets.
- After applying, fetch kubeconfig/talosconfig via `terraform output` and store them securely.

## Commit & Pull Request Guidelines
- Current history is empty; adopt imperative, present-tense messages (e.g., `Add worker sizing variables`).
- Keep changes focused and reference related issues in the body (`Refs #123`).
- For PRs, include: purpose summary, plan output snippet, and any follow-up actions or manual steps.
- Request at least one review for changes impacting core infrastructure or credentials.

## Security & State Management
- Store Terraform state remotely (Terraform Cloud or Hetzner storage) for team collaboration; avoid local `.tfstate` in commits.
- Export `HCLOUD_TOKEN` when running CLI commands; never echo or log the token.
- Keep the `HCLOUD_TOKEN` GitHub secret scoped to Terraform planning; rotate it whenever tokens are regenerated locally.
- Rotate API tokens on contributors joining or leaving; revoke unused credentials promptly.
