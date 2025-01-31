# Projeto Terraform: Multi-Client Kubernetes Cluster utilizando Odoo Deployment

![Static Badge](https://img.shields.io/badge/ETIC-Cloud%20Computing-blue?style=flat-square&label=ETIC&labelColor=purple&color=blue)

![Static Badge](https://img.shields.io/badge/Status-Completo-green?style=flat-square&label=Status&labelColor=Gray&color=green)


## Objetivo do projeto

Desenvolver um projeto Terraform abrangente que atenda aos seguintes requisitos avançados:

- Criação de uma infraestrutura flexível que suporte a implantação para três clientes distintos: Netflix, Meta e Rockstar.
- Implementação de mecanismos de configuração específicos para cada cliente usando variáveis e workspaces.
- Implantação de um cluster Kubernetes usando Minikube.
- Implementação de recursos Terraform para a implantação do aplicativo Odoo.
- Acesso HTTPS seguro para o aplicativo Odoo em ambientes de produção.

## Estrutura do projeto

O projeto está organizado da seguinte forma:
`````
.
├── cert-manager.yaml
├── clients
│   ├── meta.tfvars
│   ├── netflix.tfvars
│   └── rockstar.tfvars
├── cluster_state.txt
├── main.tf
├── modules
│   ├── ingress
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── kubernetes-cluster
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── odoo-deploy
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── postgres
│       ├── main.tf
│       ├── outuputs.tf
│       └── variables.tf
├── outputs.tf
├── Project_readme.md
├── README.MD
├── terraform.tfstate
├── terraform.tfstate.backup
├── terraform.tfstate.d
│   └── netflix
│       ├── terraform.tfstate
│       └── terraform.tfstate.backup
└── variables.tf
`````

## Definições de variáveis e propósitos

### `variables.tf`

- **`client_name`**: Nome do cliente para o qual a infraestrutura está sendo provisionada.
- **`region`**: Região onde os recursos serão implantados.
- **`cluster_name`**: Nome do cluster Kubernetes.
- **`namespace`**: Namespace do Kubernetes para o cliente específico.

## Deployment Instructions

### Pré-requisitos

- **Terraform**: Certifique-se de que o Terraform está instalado. Você pode baixá-lo em [terraform.io](https://www.terraform.io/downloads.html).
- **kubectl**: Necessário para gerenciar o cluster Kubernetes. Instale-o a partir de [kubernetes.io](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
- **Minikube**: Para criar clusters Kubernetes localmente. Instale-o a partir de [minikube.sigs.k8s.io](https://minikube.sigs.k8s.io/docs/start/).
- **Cert-Manager**: Para gerenciar certificados SSL/TLS no Kubernetes. Instale-o conforme as instruções em [cert-manager.io](https://cert-manager.io/docs/installation/).

### Passo a Passo

1. Clone o repositório:
    ```sh
    git clone https://github.com/G00li/cloud-computing-syllabus
    cd cloud-computing-syllabus
    cd Projeto
    ```
2. Inicialize o Minikube: 
    ```bash 
    minikube start
    ```
3. Inicialize o Terraform:
    ```sh
    terraform init
    ```
4. Aplique o *cert-manager.yaml*:
    ````bash
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml
    ````

5. Crie o workspace do cliente:
    ```sh
    terraform workspace new <workspace-name>
    ```
    > Caso deseja obter uma lista dos workspaces existentes
    
      ```
      terraform workspace list
      ```
    
    > Caso deseja selecionar algum da lista: 
      ````
        terraform workspace select <workspace-name>

6. Atualize o seu /etc/hosts: 
  
   - 6.1 - Obtenha o Ip do minikube: 
      ````
        minikube IP 
      `````
    - 6.2 Atualize o /etc/hosts: 
      ```bash
        sudo nano /etc/hosts
      ```
    - 6.3 - Adicione o IP do minikube com o endereço de dominio do cliente: 
      ````
      ex: 
      <Minikube-IP>   <cliente-domain>
      192.168.49.2    netflix.example.com
      ````
7. Aplique a configuração do Terraform:
    ```sh
    terraform apply -var-file=clients/<client-name>.tfvars
    ```

8. Acesse a sua aplicação através do link: https://<dominioaAlicação>
    > Poderá utilizar o ```curl``` para validar que sua aplicação está online

9. Confirme se o namespace da sua aplicação foi criado de forma automática: 
    ```bash
      kubectl get namespaces
      ````
    > Caso nao tenha sido criada de forma automática, poderá criar através do comando ``` kubectl create namespace <Nome do namespace>```
    
    > Caso queira fazer a verificação: ```kubectl get namespaces```


## Documentação de apoio: 
- [Providers Teraform](https://registry.terraform.io/browse/providers)
- [Configuração Terraform](https://developer.hashicorp.com/terraform/language)
