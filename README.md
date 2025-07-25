# Cloud-Native GitOps Platform with ArgoCD, Terraform, Monitoring & Security

[![CI/CD Pipeline](https://github.com/justrunme/cloud-devops-platform/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/justrunme/cloud-devops-platform/actions/workflows/ci-cd.yml)

This project demonstrates a complete cloud-native infrastructure built from scratch using modern DevOps and DevSecOps practices. The platform is designed to be deployed locally on Minikube/Kind or in a cloud environment.

## 🌟 Overview

We create a demo DevOps infrastructure that includes:
- **Infrastructure as Code (IaC)** with Terraform.
- **Automated Application Deployment** using ArgoCD and GitOps principles.
- **Integrated Monitoring** with Prometheus + Grafana.
- **Security Auditing** with Trivy, kube-bench, and kubescape.
- **CI/CD Pipelines** powered by GitHub Actions.
- **Report & Dashboard Visualization**.

---

## 🏗️ Repository Structure

```
cloud-devops-platform/
├── README.md
├── terraform/
│   ├── providers.tf             # Terraform providers configuration
│   ├── kind_cluster.tf          # Kind cluster definition and kubeconfig generation
│   ├── k8s_resources.tf         # Kubernetes resources (ArgoCD, Prometheus, Grafana, etc.)
│   └── argocd-values.yaml       # ArgoCD Helm chart values
├── manifests/
│   └── app/                   # Example demo application
├── monitoring/
│   ├── prometheus-values.yaml
│   ├── grafana-dashboards/    # Grafana dashboards
│   └── grafana-values.yaml      # Grafana Helm chart values
├── security/
│   ├── run_trivy.sh
│   └── kube-bench-config.yaml
├── .github/
│   └── workflows/
│       └── ci-cd.yml
├── SECURITY-REPORT.md
├── REPORTS/
│   └── grafana.png
│   └── audit-results/
└── LICENSE
```

---

## 🎯 Project Goals

| Goal          | Description                                                              |
|---------------|--------------------------------------------------------------------------|
| **GitOps**    | Deploy applications via `git push` managed by ArgoCD.                    |
| **IaC**       | Define cluster, Helm charts, ingress, and monitoring as code with Terraform. |
| **CI/CD**     | Automate checks and deployments with GitHub Actions.                     |
| **Security**  | Generate a `SECURITY-REPORT.md` using Trivy, kube-bench, and kubescape.  |
| **Monitoring**| Set up Prometheus and Grafana with pre-configured dashboards.            |
| **Docs**      | Provide a clear README with screenshots of dashboards and audit results. |

---

## ✅ Why This Project is Valuable

| Factor          | Importance                                                    |
|-----------------|---------------------------------------------------------------|
| **Security**    | DevSecOps is a top-demand skill for hiring.                   |
| **GitOps**      | ArgoCD/Flux are the leading tools in the 2024-2025 tech stack.|
| **Terraform**   | Infrastructure as Code is a must-have skill.                  |
| **Observability**| Prometheus + Grafana is the industry standard.                |
| **CI/CD**       | Demonstrates the ability to automate an end-to-end pipeline.  |
| **Documentation**| Crucial for any open-source or portfolio project.             |

---

## 🚀 Getting Started

### Deployment Options

1.  **Local:** Via Minikube or Kind.
2.  **Cloud (Optional):** Via Terraform on AWS (EKS).

### Prerequisites

*   [Minikube](https://minikube.sigs.k8s.io/docs/start/) or [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
*   [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
*   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### Installation Steps

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/justrunme/cloud-devops-platform.git
    cd cloud-devops-platform
    ```

2.  **Initialize Terraform:**
    ```sh
    cd terraform
    terraform init
    ```

3.  **Apply Terraform configuration (Two-Phase Deployment):**
    This project uses a two-phase Terraform deployment to ensure proper ordering of Kubernetes resource creation.

    **Phase 1: Create Kind Cluster and Kubeconfig**
    ```sh
    cd terraform
    terraform apply -auto-approve -target=kind_cluster.default -target=local_file.kubeconfig
    ```

    **Phase 2: Deploy Kubernetes Resources (ArgoCD, Prometheus, Grafana, etc.)**
    ```sh
    terraform apply -auto-approve
    ```

---

## ✨ Key Improvements & Learnings

During the development of this project, I addressed several complex challenges and implemented robust solutions:

*   **Robust CI/CD with Kind:** I transitioned from local Minikube to a dedicated Kind cluster within GitHub Actions for isolated and consistent testing environments. This involved:
    *   **Two-Phase Terraform Apply:** I implemented a two-step `terraform apply` process to ensure the Kind cluster is fully provisioned and its `kubeconfig` is available before deploying Kubernetes-dependent resources. This resolves circular dependency issues.
    *   **Dynamic Kubeconfig Management:** I utilized `local_file` resource in Terraform to generate and manage the `kubeconfig` file for the Kind cluster, making it accessible to all Kubernetes-related tools in the CI/CD pipeline.
    *   **Explicit Dependencies:** I added explicit `depends_on` to ensure correct ordering of resource creation, especially for `kubernetes_config_map` and `helm_release` resources.

*   **Enhanced Security Scans:** I integrated comprehensive security scanning tools into the CI/CD pipeline:
    *   **Trivy:** I configured Trivy for vulnerability scanning of the Kubernetes cluster, ensuring it correctly accesses the Kind cluster's context.
    *   **kube-bench:** I transformed `kube-bench` deployment from a `Pod` to a `Job` to leverage Kubernetes' job completion tracking, allowing for reliable waiting and log collection in CI.
    *   **Kubescape:** I ensured Kubescape is correctly installed and added to the system's PATH within the CI environment for accurate security posture assessment.

*   **Improved Debugging & Observability:** I incorporated extensive debugging steps within the GitHub Actions workflow to quickly identify and resolve issues related to Kubernetes cluster access and tool execution.

*   **Refactored Terraform Structure:** I organized Terraform configurations into logical files (`providers.tf`, `kind_cluster.tf`, `k8s_resources.tf`) to improve maintainability and adhere to best practices, resolving `Duplicate required providers configuration` errors.

---

## 📊 Generating Reports and Visualizations

To fulfill the project goals, you will need to generate the following:

### Grafana Dashboard Screenshot (`REPORTS/grafana.png`)

1.  Once Grafana is deployed and running (via `terraform apply`),
    access the Grafana UI. You can usually port-forward the Grafana service:
    ```sh
    kubectl -n monitoring port-forward svc/grafana 3000:3000
    ```
2.  Open your browser to `http://localhost:3000`.
3.  Log in (default credentials are `admin`/`admin`, you will be prompted to change the password).
4.  Navigate to the "Kubernetes cluster" dashboard (it should be automatically imported).
5.  Take a screenshot of the dashboard and save it as `REPORTS/grafana.png`.

### Security Audit Results (`REPORTS/audit-results/`)

After running the CI/CD pipeline (which includes Trivy, kube-bench, and Kubescape):

1.  **Trivy:** The `run_trivy.sh` script will output a summary. For detailed reports, you might need to run `trivy k8s --report all cluster > REPORTS/audit-results/trivy-report.txt` locally.
2.  **kube-bench:** The `kube-bench-results.txt` file generated by the CI/CD job should be moved to `REPORTS/audit-results/kube-bench-report.txt`.
3.  **Kubescape:** The `SECURITY-REPORT.md` generated by the CI/CD job should be moved to `REPORTS/audit-results/kubescape-report.md`.

Remember to commit these generated files to your repository to showcase your project's outputs.

---

## 🔑 GitHub Actions Kubeconfig Setup

For the CI/CD pipeline to interact with your Kubernetes cluster (for `kube-bench` and `kubescape`),
you need to provide your `kubeconfig` as a GitHub Secret.

1.  **Get your kubeconfig:**
    ```sh
    cat ~/.kube/config | base64
    ```
2.  **Add as GitHub Secret:**
    *   Go to your GitHub repository settings.
    *   Navigate to `Settings` -> `Secrets and variables` -> `Actions`.
    *   Click `New repository secret`.
    *   Name it `KUBECONFIG_BASE64`.
    *   Paste the base64 encoded output from step 1 into the `Value` field.

3.  **Update `ci-cd.yml` (if not already done):**
    Ensure your `.github/workflows/ci-cd.yml` includes steps to decode and use this secret:
    ```yaml
          - name: Set up Kubeconfig
            env:
              KUBECONFIG_BASE64: ${{ secrets.KUBECONFIG_BASE64 }}
            run: |
              mkdir -p ~/.kube
              echo "$KUBECONFIG_BASE64" | base64 --decode > ~/.kube/config
              chmod 600 ~/.kube/config
    ```