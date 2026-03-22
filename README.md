# TickBook-Infra

Minimal, low-cost Azure AKS deployment setup for the [TickBook](https://github.com/nmdra/TickBook) microservices platform. Designed for demo and testing purposes.

## Architecture

| Component | Technology | Purpose |
|-----------|-----------|---------|
| Event Service | Node.js / Express | Event CRUD with Redis caching |
| User Service | Node.js / Express | User auth with JWT |
| Booking Service | Go / gorilla/mux | Ticket booking management |
| Payment Service | Node.js / Express | Payment processing via Kafka events |
| Database | Azure PostgreSQL Flexible Server | Persistent storage (one DB per service) |
| Cache | Redis (in-cluster) | Event Service caching |
| Messaging | Kafka (in-cluster, KRaft mode) | Async event streaming |
| Orchestration | Azure AKS | Kubernetes cluster |

## Repository Structure

```
├── terraform/                  # Azure infrastructure
│   ├── versions.tf             # Terraform and provider versions
│   ├── providers.tf            # Provider configuration
│   ├── main.tf                 # Container Apps, data services, gateway
│   ├── data.tf                 # Data sources
│   ├── locals.tf               # Local values
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Useful output values
│   └── terraform.tfvars.example # Example variable values
├── kubernetes/                 # Kubernetes manifests
│   ├── namespace.yaml          # tickbook namespace
│   ├── configmap.yaml          # Shared configuration
│   ├── secret.yaml             # Sensitive data (template)
│   ├── ingress.yaml            # NGINX Ingress routing
│   ├── redis.yaml              # In-cluster Redis
│   ├── kafka.yaml              # In-cluster Kafka (KRaft)
│   └── apps/                   # Application services
│       ├── event-service.yaml  # Deployment + Service
│       ├── user-service.yaml   # Deployment + Service
│       ├── booking-service.yaml# Deployment + Service
│       └── payment-service.yaml# Deployment + Service
└── .github/workflows/          # CI/CD
    └── terraform-apply.yml     # Terraform automation
```

## Cost Optimization

This setup is optimized for minimal Azure costs:

- **AKS**: Single `Standard_B2s` node (2 vCPU, 4 GB RAM)
- **PostgreSQL**: `B_Standard_B1ms` Burstable tier (1 vCPU, 2 GB RAM, 32 GB storage)
- **Event Hubs**: Basic SKU with 1 throughput unit
- **Replicas**: All services run with 1 replica
- **Resources**: Minimal CPU/memory requests and limits

> **Note**: This setup is intended for demo/testing only. For production, increase node count, VM sizes, and replica counts.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.5
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- An Azure subscription

## Deployment

### 1. Provision Azure Infrastructure

```bash
cd terraform

# Initialize Terraform
terraform init

# Review the plan
terraform plan \
  -var="subscription_id=YOUR_SUBSCRIPTION_ID" \
  -var="postgres_admin_password=YOUR_SECURE_PASSWORD"

# Apply
terraform apply \
  -var="subscription_id=YOUR_SUBSCRIPTION_ID" \
  -var="postgres_admin_password=YOUR_SECURE_PASSWORD"
```

### 2. Configure kubectl

```bash
az aks get-credentials \
  --resource-group rg-tickbook-demo \
  --name aks-tickbook-demo
```

### 3. Deploy Kubernetes Resources

```bash
cd kubernetes

# Create namespace
kubectl apply -f namespace.yaml

# Update secret.yaml with real credentials, then apply
kubectl apply -f secret.yaml
kubectl apply -f configmap.yaml

# Deploy infrastructure services
kubectl apply -f redis.yaml
kubectl apply -f kafka.yaml

# Deploy application services
kubectl apply -f apps/

# Deploy ingress
kubectl apply -f ingress.yaml
```

### 4. Verify Deployment

```bash
kubectl get all -n tickbook
```

## Container Images

Images are built from the [TickBook](https://github.com/nmdra/TickBook) repository and published to GHCR:

- `ghcr.io/nmdra/tickbook/event-service:latest`
- `ghcr.io/nmdra/tickbook/user-service:latest`
- `ghcr.io/nmdra/tickbook/booking-service:latest`
- `ghcr.io/nmdra/tickbook/payment-service:latest`

## Cleanup

```bash
# Remove Kubernetes resources
kubectl delete namespace tickbook

# Destroy Azure infrastructure
cd terraform
terraform destroy \
  -var="subscription_id=YOUR_SUBSCRIPTION_ID" \
  -var="postgres_admin_password=YOUR_SECURE_PASSWORD"
```

## License

[MIT](LICENSE)
