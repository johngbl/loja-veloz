**Loja Veloz — MVP Microsserviços**

Breve: repositório de exemplo para um e-commerce em microsserviços com foco em Docker, Kubernetes e CI/CD. Esta versão fornece um MVP funcional com serviços mínimos, manifests Kubernetes, esqueleto Terraform para provisionamento e pipeline GitHub Actions para build/push de imagens.

**Arquitetura**
- Gateway: ponto de entrada HTTP (rota pública).
- Pedidos: serviço de domínio para criar/consultar pedidos.
- Pagamentos: serviço que simula processamento de pagamento.
- Estoque: serviço de gestão de estoque.
- Banco: PostgreSQL central usado por todos os serviços.

**Estrutura principal (arquivos importantes)**
- [compose.yaml](compose.yaml) : Docker Compose para desenvolvimento local (Postgres + serviços).
- [src/Dockerfile.nodejs.template](src/Dockerfile.nodejs.template) : template multi-stage Node.js (alpine, non-root).
- [src/gateway](src/gateway) , [src/pedidos](src/pedidos) , [src/pagamentos](src/pagamentos) , [src/estoque](src/estoque) : serviços com Dockerfile e app minimal.
- [k8s/deployments/deployment.yaml](k8s/deployments/deployment.yaml) : Deployments (gateway + base para outros) e HPA.
- [k8s/services/service.yaml](k8s/services/service.yaml) : Services (LoadBalancer para gateway, ClusterIP para demais).
- [k8s/configs/configmap.yaml](k8s/configs/configmap.yaml) : ConfigMap com URLs e DB_NAME.
- [k8s/configs/secret.yaml](k8s/configs/secret.yaml) : Secret com DB_PASS (base64). Atualize antes do deploy.
- [terraform/main.tf](terraform/main.tf) e [terraform/variables.tf](terraform/variables.tf) : esqueleto para provisionar DOKS (DigitalOcean) — ajustar conforme necessidade.
- [.github/workflows/main.yml](.github/workflows/main.yml) : pipeline GitHub Actions para Lint, Build e Push.

**Pré-requisitos locais**
- Docker Engine
- Docker Compose (v2 integrado ao Docker CLI)
- Node.js (para desenvolvimento local opcional)
- kubectl (para deploy em cluster)
- terraform (se for usar os módulos Terraform)

**Executar local com Docker Compose**
1) Build e subir os serviços:

```powershell
docker compose -f compose.yaml up --build
```

2) Verificar logs/health:

```powershell
docker compose -f compose.yaml ps
docker compose -f compose.yaml logs -f gateway
```

Gateway local ficará disponível em http://localhost:3000 (endpoint /health). O Postgres estará em um volume nomeado postgres_data.

**Build e push das imagens (local / CI)**
- O pipeline e o compose usam tags no formato SEU_USUARIO/loja-veloz-SERVICO:latest.
- Configure no GitHub Secrets: DOCKER_USERNAME, DOCKER_PASSWORD.

Comandos locais para build/push (exemplo):

```bash
# substituir SEU_USUARIO
docker build -t SEU_USUARIO/loja-veloz-gateway:latest ./src/gateway
docker push SEU_USUARIO/loja-veloz-gateway:latest
```

**Deploy no Kubernetes**
1) Ajuste os manifestos em k8s/ se necessário (substitua imagens REPLACE_WITH_REGISTRY por suas imagens).
2) Atualize o Secret em k8s/configs/secret.yaml com a senha real do banco encondida em base64 (ex: echo -n 'loja_pass' | base64).
3) Aplicar recursos:

```bash
kubectl apply -f k8s/configs
kubectl apply -f k8s/services
kubectl apply -f k8s/deployments
```

4) Checar status:

```bash
kubectl -n default get pods,svc,hpa -o wide
kubectl describe deployment loja-veloz-gateway-deployment
```

Observação: o Service do gateway está como LoadBalancer. Em clusters locais (kind/minikube) use port-forward ou altere para NodePort para testes.

**Terraform (esqueleto)**
- O projeto inclui um exemplo para DigitalOcean DOKS em terraform/main.tf. Se preferir GKE/AKS/EKS troque os providers.
- Valores sensíveis (DO token) não devem ficar em arquivo; use variáveis de ambiente ou secrets do CI.

Exemplo rápido:

```bash
export TF_VAR_do_token="<seu_token_do>"
terraform init
terraform apply
```

**CI/CD (GitHub Actions)**
- O workflow em .github/workflows/main.yml executa Lint (simulado), Build e Push para Docker Hub (usa secrets DOCKER_USERNAME e DOCKER_PASSWORD).
- Formato de tags: SEU_USUARIO/loja-veloz-SERVICO:latest

**Variáveis e segredos (resumo)**
- Segredos GitHub: DOCKER_USERNAME, DOCKER_PASSWORD
- Kubernetes Secret: DB_PASS (base64) em [k8s/configs/secret.yaml](k8s/configs/secret.yaml)
- ConfigMap: DB_NAME em [k8s/configs/configmap.yaml](k8s/configs/configmap.yaml)

**Boas práticas e notas de segurança**
- Não deixe senhas em texto plano no repositório. Use GitHub Secrets / Vault.
- Use imagens com tag imutável (sha) em produção, não latest.
- Ative Network Policies e RBAC no cluster em produção.
- Configure readiness/liveness probes e limites de recurso (já incluídos nos deployments).

**Próximos passos sugeridos**
- Integrar um registry privado (e.g., Amazon ECR, GitHub Container Registry).
- Adicionar testes automatizados e stage no pipeline (unit/integration).
- Implementar TLS e ingress (Ingress Controller) para o gateway.
- Substituir esqueleto Terraform pelo provider da nuvem escolhida e adicionar módulos para RDS/Managed DB.

Se quiser, eu atualizo agora as imagens em compose.yaml com o seu usuário Docker e executo um build local aqui. Deseja que eu faça isso? 

*** Obrigado — pronto para próximos passos! ***
