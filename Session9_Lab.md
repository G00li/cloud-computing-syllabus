# Session 9: Observability with Prometheus and Grafana

## Objectives
- Understand the basics of observability in Kubernetes.
- Deploy Prometheus and Grafana to monitor cluster metrics.
- Use Terraform to automate the deployment and configuration.

---

## Lab Outline

### Step 1: Setting Up the Environment

1. **Prerequisites**:
   - Ensure Terraform, kubectl, and a Kubernetes cluster (Minikube/Kind) are set up (refer to previous sessions if needed).
   - Clone the lab repository:
     ```bash
     git clone <repository-url>
     cd session9_observability
     ```

2. **Install Helm** (if not already installed):
   ```bash
   curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
   ```

---

### Step 2: Deploying Prometheus and Grafana with Terraform

1. **Review the Terraform Configuration**:
   - Open `prometheus_grafana.tf` to review the configuration:
     ```hcl
     provider "kubernetes" {
       config_path = "~/.kube/config"
     }

     # Namespace for Monitoring
     resource "kubernetes_namespace" "monitoring" {
       metadata {
         name = "monitoring"
       }
     }

     # Prometheus Helm Chart
     resource "helm_release" "prometheus" {
       name       = "prometheus"
       namespace  = kubernetes_namespace.monitoring.metadata[0].name
       chart      = "prometheus"
       repository = "https://prometheus-community.github.io/helm-charts"

       values = <<EOF
       serviceAccount:
         create: true
       server:
         service:
           type: NodePort
       EOF
     }

     # Grafana Helm Chart
     resource "helm_release" "grafana" {
       name       = "grafana"
       namespace  = kubernetes_namespace.monitoring.metadata[0].name
       chart      = "grafana"
       repository = "https://grafana.github.io/helm-charts"

       values = <<EOF
       adminUser: "admin"
       adminPassword: "admin"
       service:
         type: NodePort
       EOF
     }
     ```

2. **Initialize and Apply Terraform**:
   - Initialize Terraform:
     ```bash
     terraform init
     ```
   - Preview the changes:
     ```bash
     terraform plan
     ```
   - Apply the configuration:
     ```bash
     terraform apply -auto-approve
     ```

3. **Verify the Deployment**:
   - Check if Prometheus and Grafana pods are running:
     ```bash
     kubectl get pods -n monitoring
     ```
   - Retrieve the NodePort for Grafana:
     ```bash
     kubectl get svc -n monitoring
     ```

---

### Step 3: Configuring Prometheus and Grafana

1. **Access Grafana**:
   - Open your browser and access Grafana using the NodePort (e.g., `http://<node-ip>:<grafana-nodeport>`).
   - Log in with the default credentials (`admin`/`admin`).

2. **Add Prometheus as a Data Source**:
   - In Grafana, go to **Configuration > Data Sources**.
   - Add Prometheus with the following settings:
     - URL: `http://prometheus-server.monitoring.svc.cluster.local:80`
     - Save & Test.

3. **Import a Dashboard**:
   - Go to **Create > Import**.
   - Use the Prometheus Kubernetes monitoring dashboard ID: `315`.
   - Select Prometheus as the data source and click **Import**.

---

### Step 4: Monitoring the Cluster

1. **Explore Metrics in Prometheus**:
   - Access Prometheus via its NodePort (e.g., `http://<node-ip>:<prometheus-nodeport>`).
   - Query metrics like:
     - `node_cpu_seconds_total`
     - `kube_pod_container_resource_requests_cpu_cores`

2. **Analyze Grafana Dashboards**:
   - Use the imported dashboard to monitor Kubernetes resources such as pods, nodes, and cluster health.

---

### Step 5: Cleaning Up

1. **Destroy Resources**:
   - To remove the monitoring stack:
     ```bash
     terraform destroy -auto-approve
     ```

2. **Delete the Cluster**:
   - If using Minikube:
     ```bash
      minikube delete
     ```
   - If using Kind:
     ```bash
     kind delete cluster
     ```

---

## Deliverables
- **Screenshots**:
  1. Prometheus metrics UI showing a query result.
  2. Grafana dashboard displaying cluster metrics.

- **Git Repository**:
  - Commit all Terraform and Helm files to your Git repository.

---

## Files Included
1. `prometheus_grafana.tf`: Terraform configuration for Prometheus and Grafana.
2. `variables.tf`: Variables for the Terraform setup.
3. `.gitignore`: Ignoring Terraform state files.
4. `README.md`: Documentation for the lab.

---

Happy monitoring your Kubernetes cluster! 🌟
