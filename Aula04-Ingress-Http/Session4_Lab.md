# Lab 4: Networking in Kubernetes

## Overview
This lab focuses on networking in Kubernetes, including the cluster's networking model, Ingress controllers, and DNS within the cluster. You will learn how to expose applications and configure routing rules using Ingress resources.

---

## Objectives
- Understand Kubernetes networking basics.
- Configure an Ingress controller to expose an application.
- Set up a DNS entry for application access.

---

## Instructions

### 1. Prerequisites
Ensure you have a running Kubernetes cluster (e.g., Minikube) and `kubectl` configured. Start Minikube if needed:
```bash
minikube start
```

Enable the NGINX Ingress controller in Minikube:
```bash
minikube addons enable ingress
```

---

### 2. Deploying a Sample Application
#### Step 1: Create a Deployment
Save the following content to `deployment.yaml`:
```yaml
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

Apply the deployment:
```bash
kubectl apply -f deployment.yaml
```

#### Step 2: Create a Service
Save the following content to `service.yaml`:
```yaml
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

Apply the service:
```bash
kubectl apply -f service.yaml
```

---

### 3. Configuring Ingress
#### Step 1: Create an Ingress Resource
Save the following content to `ingress.yaml`:
```yaml
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

Apply the Ingress resource:
```bash
kubectl apply -f ingress.yaml
```

#### Step 2: Add DNS Entry
For Minikube, get the IP of the Ingress controller:
```bash
minikube ip
```

Edit your `/etc/hosts` file to add a DNS entry:
```plaintext
<MINIKUBE_IP> hello.local
```

Test the application:
```bash
curl http://hello.local
```

---

### 4. Testing and Validation
#### Step 1: Verify Resources
Check the deployment, service, and ingress:
```bash
kubectl get deployments
kubectl get services
kubectl get ingress
```

#### Step 2: Access the Application
Open a browser and navigate to `http://hello.local`. You should see the message `Hello, Kubernetes!`.

---

## Exercises
1. **Modify the Application:**
   - Change the text displayed by the application and update the deployment.
2. **Add a New Path to Ingress:**
   - Add a new path `/health` to the Ingress and point it to another service or application.
3. **Test with HTTPS:**
   - Configure TLS for the Ingress resource and test access via HTTPS.

---

## Deliverables
- Screenshots of the Ingress resource and application working.
- YAML files for the Deployment, Service, and Ingress.
