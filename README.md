# Bookinfo on Azure AKS with Istio - Terraform Deployment

## Architecture & Design Decisions

- **Azure AKS** is used for managed Kubernetes, providing scalability and easy integration with Azure networking.
- **Istio Service Mesh** is deployed for advanced traffic management, observability, and security.
- **Terraform** manages all infrastructure as code, including AKS, networking (VNet, Subnet, NSG), and remote state in Azure Blob Storage.
- **GitHub Actions** are used for CI/CD, supporting both `dev` and `prod` environments.
- **Networking**: AKS is deployed with direct VNet integration, so pods and nodes get real Azure IPs. Istio Ingress Gateway is exposed via Azure LoadBalancer.
- **State Management**: Terraform state is stored in Azure Blob Storage with versioning enabled for safety.
- **Security**: NSG rules are managed via Terraform to allow only required ports (e.g., Istio Ingress, Kiali, Grafana, Prometheus).
- **CI/CD Separation**: CI validates code and runs tests; CD deploys infrastructure and applications after CI passes.




## How to Deploy

### Prerequisites
- Azure subscription with permission to create resources.
- GitHub Runner (Linux VM) configured with Azure credentials. 

### Steps

#### 1. Clone the Repository
```bash
git clone https://github.com/sbnm007/terraform-Aks.git
cd terraform-Aks
```

#### 2. Configure Azure Credentials (Use Service Principal within terraform)
- Login to Azure and set your subscription:
  ```bash
  az login

  #Here its better to create service principle / service role rather than configuring on the server

#### 3. Deploy Infrastructure (Dev or Prod)
- **Manual Deployment via GitHub Actions:**
  1. Go to GitHub → Actions → `CD - Deploy Infra (Dev/Prod)`
  2. Click "Run workflow"
  3. Select environment (`dev` or `prod`)
  4. Optionally check "destroy" to delete resources
  5. Click "Run workflow"

- **Automatic Deployment:**
  - Push to `develop` branch for dev, or `main` branch for prod.
  - CI pipeline validates, then CD pipeline deploys.

#### 4. Access AKS Cluster
```bash
az aks get-credentials --resource-group <resource-group> --name <cluster-name>
kubectl get nodes
```

#### 5. Deploy Istio & Bookinfo Application
- Istio and Bookinfo are deployed automatically by the CD workflow.

- Manual steps (if needed):
  ```bash
  curl -L https://istio.io/downloadIstio | sh -
  cd istio-<version>/
  istioctl install --set values.defaultRevision=default -y
  kubectl label namespace default istio-injection=enabled
  kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
  kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
  ```

## How to Access Deployed Applications

- **Bookinfo Application:**
  - Get Istio Ingress Gateway external IP:
    ```bash
    kubectl get svc istio-ingressgateway -n istio-system
    ```
  - Access at: `http://<EXTERNAL-IP>/productpage`

- **Kiali Dashboard:**
  - Exposed via LoadBalancer on port 20001:
    ```bash
    kubectl get svc kiali -n istio-system
    ```
  - Access at: `http://<KIALI-IP>:20001`

- **Grafana & Prometheus:**
  - Use `kubectl port-forward` for local access:
    ```bash
    kubectl port-forward -n istio-system svc/grafana 3000:3000
    kubectl port-forward -n istio-system svc/prometheus 9090:9090
    ```
  For Prod,
      kubectl patch service kiali -n istio-system -p '{"spec":{"type":"LoadBalancer"}}'


## Assumptions & Trade-offs

- **Assumptions:**
  - You have access to an Azure subscription and can create resources.
  - A Service Principal is available for Terraform authentication.
  - GitHub Runner is configured with necessary Azure credentials.
  - Networking ranges (VNet, Subnet, Service CIDR) are set to avoid conflicts.

- **Trade-offs:**
  - Using a single workflow for both environments simplifies maintenance but requires careful input selection.
  - Manual approval for production deployments is recommended for safety.
  - LoadBalancer services created by Kubernetes (e.g., Istio Ingress, Kiali) are not directly tracked by Terraform, but their underlying Azure resources are managed by AKS and will be deleted when the cluster is destroyed.
  - State file is stored remotely for reliability, but access control must be managed.



Thanks!