# Lab 5: Kubernetes Revision

## Overview
This lab focuses on reviewing and consolidating your understanding of Kubernetes concepts covered so far. You will deploy a multi-tier application using deployments, services, volumes, and networking resources.

---

## Objectives
- Reinforce knowledge of Kubernetes core concepts.
- Practice using deployments, services, volumes, and Ingress resources together.
- Deploy and troubleshoot a multi-tier application.

---

## Instructions

### 1. Prerequisites
Ensure you have a running Kubernetes cluster (e.g., Minikube) and `kubectl` configured. Start Minikube if needed:
```bash
minikube start
```

Enable the NGINX Ingress controller:
```bash
minikube addons enable ingress
```

---

### 2. Multi-Tier Application Setup
We will deploy a basic web application with a frontend and a backend.

#### Step 1: Create Backend Deployment and Service
Save the following content to `backend-deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: hashicorp/http-echo:0.2.3
        args:
          - "-text=Hello from the Backend!"
        ports:
          - containerPort: 5678
```

Save the following content to `backend-service.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  selector:
    app: backend
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 5678
  type: ClusterIP
```

Apply the files:
```bash
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
```

#### Step 2: Create Frontend Deployment and Service
Save the following content to `frontend-deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: nginx:latest
        ports:
          - containerPort: 80
```

Save the following content to `frontend-service.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
spec:
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
```

Apply the files:
```bash
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
```

#### Step 3: Create Ingress Resource
Save the following content to `ingress.yaml`:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: app.local
    http:
      paths:
      - path: /backend
        pathType: Prefix
        backend:
          service:
            name: backend-service
            port:
              number: 8080
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
```

Apply the Ingress resource:
```bash
kubectl apply -f ingress.yaml
```

Add the DNS entry:
```plaintext
<MINIKUBE_IP> app.local
```

---

### 3. Persistent Storage for Backend
#### Step 1: Create Persistent Volume and Claim
Save the following content to `storage.yaml`:
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: backend-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: backend-pvc
spec:
  resources:
    requests:
      storage: 1Gi
  accessModes:
    - ReadWriteOnce
```

Apply the storage configuration:
```bash
kubectl apply -f storage.yaml
```

#### Step 2: Update Backend Deployment
Update the backend deployment to mount the PersistentVolume. Save the following to `backend-deployment-with-storage.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: hashicorp/http-echo:0.2.3
        args:
          - "-text=Hello from the Backend!"
        ports:
          - containerPort: 5678
        volumeMounts:
          - mountPath: "/data"
            name: backend-storage
      volumes:
      - name: backend-storage
        persistentVolumeClaim:
          claimName: backend-pvc
```

Apply the updated deployment:
```bash
kubectl apply -f backend-deployment-with-storage.yaml
```

---

## Exercises
1. **Update Application Routing:**
   - Modify the Ingress resource to add a new path for another application.
2. **Add Persistent Storage to Frontend:**
   - Create and attach a PersistentVolume for the frontend.
3. **Scale the Application:**
   - Scale the frontend deployment to 5 replicas and observe the changes.

---

## Deliverables
- Screenshots showing all resources (`kubectl get all`) and application functionality.
- YAML files for all configurations.
- A short summary of any issues faced and how they were resolved.
