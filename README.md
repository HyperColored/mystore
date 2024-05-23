# Store test application

## Technology stack

### Application

- **Code management**: Git
- **Frontend**: HTML, CSS, Vue, Ts, Js
- **Backend**: Go
- **CI/CD**: Gitlab CI
- **Container environment**: Docker
- **Testing**: Unit, Gitlab SAST, SonarQube
- **Repository**: Gitlab CI, Nexus

### Infrastructure

- **Cloud provider**: Yandex.Cloud
- **Container environment**: Docker
- **Container management**: Kubernetes
- **Infrastructure**: Terraform, S3
- **Artifact repository**: Nexus
- **CI/CD**: Gitlab CI
- **Monitoring**: Prometheus, Alertmanager, Loki, Grafana
- **Web server**: Ingress-controller, Network Load Balancer, Cert-manager, DNS, Nginx
- **Deployment**: Helm
- **Code Management**: Git, Gitlab CI, IaC

## Dependencies

### Backend

| Key | Value | 
|--------------|-----------|
| go | 1.17 |
| Docker image go | golang:1.17.13-alpine3.16 |
| Docker image release | scratch |

### Frontend

| Key | Value | 
|--------------|-----------|
| axios | ^0.24.0 |
| cookie | ^0.4.1 |
| core-js | ^3.6.5 |
| svelte-debouncer | ^0.0.5 |
| vue | ^3.2.26 |
| vue-router | ^4.0.0-0 |
| vuex | ^4.0.2 |
| typescript | ~4.1.5 |
| webpack | ^4.39.3 |
| node | 6.9.0 |
| Docker image nginx | nginx:1.25.1 |
| Docker image node | node:16-alpine |

More in `package.json` and `package-lock.json`

## CI/CD variables

### Gitlab CI project:

| Key | Value |
|--------------|-----------|
| `DOCKERHUB_PASS` | Dockerhub password credential |
| `DOCKERHUB_USER` | Dockerhub login credential |
| `SONAR_LOGIN_BACK` | Sonarqube backend token |
| `SONAR_LOGIN_FRONT` | Sonarqube frontend token |
| `NEXUS_REPO_PASSWORD` | Nexus user password credential |
| `NEXUS_REPO_USER` | Nexus user login credential |
| `NEXUS_REPO_URL_BACKEND` |  Nexus backend repo URL |
| `NEXUS_REPO_URL_FRONTEND` | Nexus frontend repo URL |
| `SONAR_PROJECT_KEY_BACK` | Sonarqube backend project key |
| `SONAR_PROJECT_KEY_FRONT` | Sonarqube frontend project key |
| `SONAR_URL` | Sonarqube service URL |

# Infrastructure

## Dependencies

| Key | Values | 
|--------------|-----------|
| terraform.required_providers | >= 0.94 |
| terraform.version | >= 1.4.0 |
| Yandex Cloud CLI | 0.108.1 |
| kubectl | v5.0.1 |
| helm | v3.12.0 |
| cert-manager | v1.12.0 |

## Infrastructure creation

### Preparatory steps

- [Register YC account](https://cloud.yandex.ru/docs/billing/quickstart/)
- [Folder creation](https://cloud.yandex.ru/docs/resource-manager/operations/folder/create)
- [Create service account with Editor permissions](https://cloud.yandex.ru/docs/iam/quickstart-sa#create-sa)
- [Create static key for SA](https://cloud.yandex.ru/docs/iam/concepts/authorization/key)

### Infrastructure automatic creation

- Clone repository

```
git@gitlab.com:sheriotanda.zh/mystore.git
```

- Move to terraform folder

```
cd terraform
```

- Create new token in order to gain access to cloud management using terraform

```
IAM_TOKEN=`yc iam create-token`
```

- Write this key to the tfvars file:

```
 touch ./terraform.tfvars
 echo $IAM_TOKEN > ./terraform.tfvars
```

- Execute:

```
terraform init
terraform apply -auto-approve
```

### Enable access to the cluster for CI/CD purpose

- return to the repo root folder

```
cd ../
```

- check the list of clusters available from the cloud:

```
yc managed-kubernetes cluster list
```

- create configuration neede for gaining access to the cloud:

```
yc managed-kubernetes cluster get-credentials <cluster_id> --external --kubeconfig ./.kube/config
```

- [Install latest version of kubectl utility](https://kubernetes.io/ru/docs/tasks/tools/install-kubectl/)
- Create 3 objects in cloud cluster (ClusterRoleBinding, Secret и ServiceAccount) using manifest:

```
kubectl create -f k8s-additional/sa.yaml
```

## Services installation

### Preparatory steps

- [Install helm](https://helm.sh/ru/docs/intro/install/)

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo update
```

### Ingress

- Install Ingress-controller

```
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx
```

## Application installation

- is automatic via CI/CD configuration

## Infrastructure destruction

```
terraform destroy -auto-approve
```