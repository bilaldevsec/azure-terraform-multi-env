# Multi-Environment Azure Infrastructure using Terraform

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure Provider](https://img.shields.io/badge/AzureRM-~%3E5.0-0078D4?logo=microsoftazure&logoColor=white)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
[![Security](https://img.shields.io/badge/Security-Zero--Trust%20NSG-success)](https://learn.microsoft.com/en-us/azure/security/fundamentals/zero-trust)
[![Azure For Students](https://img.shields.io/badge/Azure%20for%20Students-Compatible%20%28%240%2Fmo%20idle%29-brightgreen)](#cost-optimization--azure-for-students-guarantee)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

An enterprise-ready, production-grade Infrastructure as Code (IaC) repository architected with **Terraform** and the **AzureRM Provider (~> 5.0)**. This project provisions fully isolated **Development (`dev`)** and **Production (`prod`)** environments on Microsoft Azure using reusable, decoupled Terraform modules.

It enforces a strict **3-Tier Zero-Trust Network Architecture**, mandatory resource tagging, state isolation, and zero-dollar idle cost compatibility with Azure for Students / free-tier subscriptions.

---

## Architecture Overview

```
+-----------------------------------------------------------------------------------------+
|                                    TERRAFORM CLI                                        |
|                          terraform init | plan | apply                                  |
+-----------------------------------------------------------------------------------------+
                                             |
                                             v
+-----------------------------------------------------------------------------------------+
|                                REUSABLE MODULE CATALOG                                  |
|     modules/network        |       modules/security       |    modules/storage_vault     |
| (RG, VNet, 3-Tier Subnets) | (NSG Rules & Subnet Assoc)   | (Storage Account, Key Vault)|
+-----------------------------------------------------------------------------------------+
                     |                                              |
                     v                                              v
+------------------------------------------+  +-------------------------------------------+
|          ENVIRONMENT: DEV                |  |           ENVIRONMENT: PROD               |
|  Resource Group: rg-dev (Southeast Asia)        |  |  Resource Group: rg-prod (Southeast Asia)        |
|  Address Space: 10.10.0.0/16             |  |  Address Space: 10.20.0.0/16              |
|                                          |  |                                           |
|  +------------------------------------+  |  |  +-------------------------------------+  |
|  | Web Subnet: 10.10.1.0/24           |  |  |  | Web Subnet: 10.20.1.0/24            |  |
|  | NSG: Allow HTTPS:443 from Internet |  |  |  | NSG: Allow HTTPS:443 from Internet  |  |
|  |      DenyAllInbound (Priority 4096)|  |  |  |      DenyAllInbound (Priority 4096) |  |
|  +------------------------------------+  |  |  +-------------------------------------+  |
|                   |                      |  |                    |                      |
|                   v (TCP 8080 only)      |  |                    v (TCP 8080 only)       |
|  +------------------------------------+  |  |  +-------------------------------------+  |
|  | App Subnet: 10.10.2.0/24           |  |  |  | App Subnet: 10.20.2.0/24            |  |
|  | NSG: Allow TCP:8080 from Web Subnet|  |  |  | NSG: Allow TCP:8080 from Web Subnet |  |
|  |      DenyAllInbound (Priority 4096)|  |  |  |      DenyAllInbound (Priority 4096) |  |
|  +------------------------------------+  |  |  +-------------------------------------+  |
|                   |                      |  |                    |                      |
|                   v (TCP 5432 only)      |  |                    v (TCP 5432 only)       |
|  +------------------------------------+  |  |  +-------------------------------------+  |
|  | DB Subnet: 10.10.3.0/24            |  |  |  | DB Subnet: 10.20.3.0/24             |  |
|  | NSG: Allow TCP:5432 from App Subnet|  |  |  | NSG: Allow TCP:5432 from App Subnet  |  |
|  |      DenyAllInbound (Priority 4096)|  |  |  |      DenyAllInbound (Priority 4096) |  |
|  +------------------------------------+  |  |  +-------------------------------------+  |
|                                          |  |                                           |
|  Security & Secrets:                     |  |  Security & Secrets:                      |
|  - Storage Account: stdev<unique_id>     |  |  - Storage Account: stprod<unique_id>     |
|  - Key Vault: kv-dev-<unique_id>         |  |  - Key Vault: kv-prod-<unique_id>         |
+------------------------------------------+  +-------------------------------------------+
```

A visual architecture diagram is provided in [`docs/architecture-diagram.html`](file:///home/muhammad-bilal/projects/azure-terraform-multi-env/docs/architecture-diagram.html). Open it in any browser for an interactive blueprint including visual packet flows, security policy breakdowns, and CIDR plans.

---

## Directory Tree

```
azure-terraform-multi-env/
├── .gitignore
├── README.md
├── docs/
│   └── architecture-diagram.html
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars.example
│   │   └── variables.tf
│   └── prod/
│       ├── main.tf
│       ├── outputs.tf
│       ├── terraform.tfvars.example
│       └── variables.tf
└── modules/
    ├── network/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── security/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    └── storage_vault/
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

### Module Responsibilities

| Module | Purpose | Managed Azure Resources |
| :--- | :--- | :--- |
| **`modules/network`** | Foundations & Segmentation | `azurerm_resource_group`, `azurerm_virtual_network`, `azurerm_subnet` (Web, App, DB) |
| **`modules/security`** | Zero-Trust Perimeter & Lateral Defense | `azurerm_network_security_group` (x3), `azurerm_subnet_network_security_group_association` (x3) |
| **`modules/storage_vault`** | Secrets & Artifact Storage | `random_string`, `azurerm_storage_account` (TLS 1.2, Private), `azurerm_key_vault` (RBAC) |

---

## Zero-Trust Security Design Matrix

Default Azure NSGs include a built-in rule `AllowVnetInBound` (Priority 65000), which permits any subnet in a Virtual Network to talk to any other subnet. In high-compliance enterprise environments, this violates the principle of least privilege and allows lateral traversal upon perimeter compromise.

This architecture mitigates lateral movement by appending an explicit **`Deny-All-Inbound` rule at Priority 4096** across all NSGs, enforcing an uncompromising **Default Deny** posture:

| Subnet | NSG Name | Priority | Direction | Action | Protocol | Port | Authorized Source | Intended Purpose |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :--- | :--- |
| **`snet-web`** | `nsg-web-{env}` | 100 | Inbound | **Allow** | TCP | `443` | `Internet` | Public HTTPS ingress for web services / reverse proxies |
| **`snet-web`** | `nsg-web-{env}` | 4096 | Inbound | **Deny** | Any | `*` | `*` | Blocks unapproved inbound traffic |
| **`snet-app`** | `nsg-app-{env}` | 100 | Inbound | **Allow** | TCP | `8080` | `web_subnet_cidr` | App layer API access restricted solely to the Web tier |
| **`snet-app`** | `nsg-app-{env}` | 4096 | Inbound | **Deny** | Any | `*` | `*` | Blocks direct public traffic and unauthorized lateral access |
| **`snet-db`** | `nsg-db-{env}` | 100 | Inbound | **Allow** | TCP | `5432` | `app_subnet_cidr` | PostgreSQL access restricted solely to the App tier |
| **`snet-db`** | `nsg-db-{env}` | 4096 | Inbound | **Deny** | Any | `*` | `*` | Total database isolation from Web tier and Internet |

> [!NOTE]
> Under this segmentation model, the **Web tier cannot communicate directly with the Database tier**. Web workloads must traverse the Application API tier, eliminating direct-to-database compromise vectors.

---

## IP Allocation & Subnet Planning

| Environment | Virtual Network CIDR | Web Subnet (`snet-web`) | App Subnet (`snet-app`) | DB Subnet (`snet-db`) | Available IPs/Subnet |
| :--- | :--- | :--- | :--- | :--- | :---: |
| **Dev** | `10.10.0.0/16` | `10.10.1.0/24` | `10.10.2.0/24` | `10.10.3.0/24` | 251 |
| **Prod** | `10.20.0.0/16` | `10.20.1.0/24` | `10.20.2.0/24` | `10.20.3.0/24` | 251 |

*Note: Azure reserves 5 IP addresses per subnet (first 4 and last 1).*

---

## Cost Optimization & Azure for Students Guarantee

This repository is tailored for enterprise architectural rigor while incurring **$0.00/month in idle compute charges**, making it safe for **Azure for Students ($100 credit)** and developer sandboxes:

1. **Zero Expensive Gateways:** No Azure Application Gateway, Azure Firewall ($1.25/hr), NAT Gateway ($0.045/hr), or Bastion hosts ($0.19/hr) are provisioned.
2. **Zero Compute Run-Rates:** No Virtual Machines or App Service Plans are created by default.
3. **Free Networking Core:** Azure Resource Groups, Virtual Networks, Subnets, and Network Security Groups incur zero hourly cost.
4. **Standard_LRS Storage:** Storage accounts use locally redundant storage (`Standard_LRS`) and cost fractions of a cent unless large volumes of state/artifacts are stored.
5. **Standard Key Vault with RBAC:** Azure Key Vault uses standard SKU operations (~$0.03 per 10,000 transactions) without expensive dedicated HSM modules.
6. **Clean Teardown:** Key Vault has `purge_protection_enabled = false` and provider features configured to allow immediate `terraform destroy` without soft-delete retention conflicts.

---

## Governance & Mandatory Tagging

Every managed resource is automatically labeled with standardized governance tags:

```hcl
Environment = var.environment              # e.g., "dev" or "prod"
ManagedBy   = "Terraform"                  # Identifies IaC ownership
Project     = "Multi-Env-Azure-IaC"        # Project attribution
```

Custom tags (such as `Owner`, `CostCenter`, `Criticality`) can be supplied via `custom_tags` variable in `terraform.tfvars` and are automatically merged.

---

## Quickstart Guide

### Prerequisites
- [Terraform CLI &ge; 1.5.0](https://developer.hashicorp.com/terraform/downloads)
- [Azure CLI (az)](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

### Step 1: Azure Authentication
Authenticate your Azure CLI session:
```bash
az login
az account show --output table
```

### Step 2: Provision Development Environment
Navigate to the `dev` environment directory:
```bash
cd environments/dev

# Create your local variable definitions from the template
cp terraform.tfvars.example terraform.tfvars

# Initialize Terraform modules and AzureRM provider
terraform init

# Validate configuration syntax
terraform validate

# Review the execution plan (13 resources to create)
terraform plan

# Apply infrastructure deployment (when ready)
# terraform apply
```

### Step 3: Provision Production Environment
Navigate to the `prod` environment directory:
```bash
cd ../../environments/prod

# Create your local variable definitions from the template
cp terraform.tfvars.example terraform.tfvars

# Initialize Terraform modules and AzureRM provider
terraform init

# Validate configuration syntax
terraform validate

# Review the execution plan (13 resources to create)
terraform plan

# Apply infrastructure deployment (when ready)
# terraform apply
```

### Step 4: Clean Teardown
To avoid unexpected charges when finished testing:
```bash
# Inside environments/dev or environments/prod:
terraform destroy -auto-approve
```

---

## Security Best Practices Implemented

- [x] **State Isolation:** Dev and Prod maintain independent state namespaces and execution directories to eliminate cross-environment blast radius.
- [x] **No Hardcoded Secrets:** Zero credentials or access keys committed; Key Vault uses native Azure RBAC authorization (`rbac_authorization_enabled = true`).
- [x] **TLS 1.2 Enforcement:** Storage account enforces `min_tls_version = "TLS1_2"`.
- [x] **Disabled Public Nested Blob Items:** Prevents accidental public exposure of blob container items.
- [x] **Gitignore Shielding:** Ignores local state files (`*.tfstate`), variable definition files (`*.tfvars`), and runtime logs.
- [x] **Globally Unique Naming:** `random_string` generator guarantees collision-free storage account and key vault names across the global Azure tenant space.
- [x] **Provider Pinning:** Providers locked to `hashicorp/azurerm ~> 5.0` and `hashicorp/random ~> 3.6` ensuring deterministic reproducibility.

---

## Contributing & License

This project is licensed under the [MIT License](LICENSE). Contributions, issues, and feature requests are welcome.
