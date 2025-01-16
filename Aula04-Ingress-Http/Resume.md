### Conceitos e Funcionamento do Lab: Networking no Kubernetes

O Lab aborda os principais conceitos de **rede no Kubernetes** e utiliza recursos como o modelo de rede do cluster, controladores de Ingress e DNS para expor aplicações. Abaixo estão as explicações detalhadas sobre cada conceito utilizado no markdown fornecido:

---

### **1. Kubernetes Networking Basics**

#### **Como funciona**

O modelo de rede do Kubernetes garante que:

1. Todos os Pods em um cluster podem se comunicar entre si diretamente, independentemente de estarem no mesmo nó ou não.
2. Serviços oferecem uma camada de abstração para acessar os Pods, permitindo que os usuários interajam com a aplicação sem se preocupar com os Pods individuais.

#### **Principal função**

Prover conectividade e abstração entre os componentes do cluster, permitindo comunicação eficiente entre Pods, serviços e usuários externos.

---

### **2. Ingress Controller**

#### **Como funciona**

O **Ingress Controller** é um componente que gerencia objetos de **Ingress**. Ele atua como um proxy reverso e encaminha solicitações HTTP/HTTPS externas para os serviços do cluster com base em regras definidas. Exemplos de controladores incluem **NGINX**, **HAProxy** e outros.

#### **Principal função**

- Expor aplicações rodando no cluster para o mundo externo.
- Gerenciar o roteamento de tráfego HTTP/HTTPS com base em:
    - Host (ex.: `hello.local`).
    - Caminhos (ex.: `/api`, `/health`).
- Suporte para **TLS** (HTTPS) e regras avançadas de roteamento.

---

### **3. DNS no Kubernetes**

#### **Como funciona**

- O DNS interno do Kubernetes resolve nomes de serviços para seus IPs ClusterIP.
- No exemplo, o DNS externo (modificado via `/etc/hosts`) mapeia o domínio `hello.local` para o IP do Ingress Controller no Minikube.

#### **Principal função**

Permitir que aplicações e usuários acessem serviços Kubernetes por meio de nomes amigáveis (ex.: `hello.local`), em vez de endereços IP.

---

### **4. Recursos Utilizados no Lab**

#### **Deployment**

- Define e gerencia réplicas de Pods.
- No exemplo, foi usado o seguinte Deployment:
```
    apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hello-app
  template:
    metadata:
      labels:
        app: hello-app
    spec:
      containers:
      - name: hello-app
        image: hashicorp/http-echo:0.2.3
        args:
          - "-text=Hello, Kubernetes!"
        ports:
          - containerPort: 5678
```

- **Função**: Manter a aplicação "Hello, Kubernetes!" em execução com duas réplicas de Pods.

---

#### **Service**

- Cria uma interface de rede para expor os Pods de um Deployment.
- No exemplo, foi usado um **Service** com tipo `ClusterIP`:
```
apiVersion: v1
kind: Service
metadata:
  name: hello-service
spec:
  selector:
    app: hello-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5678
  type: ClusterIP

```

- **Função**: Permitir que outros recursos no cluster (como o Ingress) acessem os Pods da aplicação.

---

#### **Ingress**

- Define regras para expor aplicações para o tráfego externo.
- No exemplo, foi criado um **Ingress**:
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: hello.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: hello-service
            port:
              number: 80

```

- **Função**:
    - Expor a aplicação externamente através do domínio `hello.local`.
    - Roteamento baseado em host e caminhos para serviços específicos.

---

#### **/etc/hosts**

- Atualizar o arquivo **`/etc/hosts`** mapeia `hello.local` para o IP do Ingress Controller:
    
```
    <MINIKUBE_IP> hello.local
```
    
- **Função**: Facilitar o acesso local à aplicação em desenvolvimento.
    

---

### **Resumo**

Esse Lab introduz os fundamentos de networking no Kubernetes, abordando:

- **Modelo de rede**: Comunicação entre Pods e serviços.
- **Ingress**: Exposição de aplicativos com roteamento HTTP/HTTPS.
- **DNS**: Acesso amigável a serviços através de nomes.

Esses conceitos são cruciais para garantir que aplicações Kubernetes estejam acessíveis e seguras, tanto dentro quanto fora do cluster.