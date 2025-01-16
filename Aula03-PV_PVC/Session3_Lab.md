# Lab 3: Storage in Kubernetes

## Overview
This lab introduces the concepts of Kubernetes storage, including Persistent Volumes (PVs), Persistent Volume Claims (PVCs), and StatefulSets. You will learn to manage stateful applications and understand how storage works in Kubernetes.

---

## Objectives
- Understand Kubernetes volume types.
- Create and use Persistent Volumes (PVs) and Persistent Volume Claims (PVCs).
- Deploy stateful applications using StatefulSets.

---

## Instructions

### 1. Prerequisites
Ensure you have a running Kubernetes cluster (e.g., Minikube) and `kubectl` configured. Start Minikube if needed:
```bash
minikube start
```

---

### 2. Working with Persistent Volumes and Claims
#### Step 1: Create a Persistent Volume
Save the following content to `persistent-volume.yaml`:
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-example
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/data
```

Apply the Persistent Volume:
```bash
kubectl apply -f persistent-volume.yaml
```

#### Step 2: Create a Persistent Volume Claim
Save the following content to `persistent-volume-claim.yaml`:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-example
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
```

Apply the Persistent Volume Claim:
```bash
kubectl apply -f persistent-volume-claim.yaml
```

Verify the PV and PVC:
```bash
kubectl get pv
kubectl get pvc
```

---

### 3. Deploying a Stateful Application
#### Step 1: Create a StatefulSet
Save the following content to `statefulset.yaml`:
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: nginx-statefulset
spec:
  serviceName: "nginx"
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        volumeMounts:
        - name: storage
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: storage
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi
```

Apply the StatefulSet:
```bash
kubectl apply -f statefulset.yaml
```

Verify the Pods and Persistent Volume Claims:
```bash
kubectl get pods
kubectl get pvc
```

---

### 4. Testing Persistent Storage
#### Step 1: Access the Pod and Test
Get the name of one of the Pods:
```bash
kubectl get pods
```

Access the Pod:
```bash
kubectl exec -it <pod-name> -- /bin/bash
```

Create a file in the mounted directory:
```bash
echo "Hello from StatefulSet" > /usr/share/nginx/html/index.html
```

Exit the Pod and delete it:
```bash
kubectl delete pod <pod-name>
```

Check that the file persists by accessing the new Pod created by the StatefulSet:
```bash
kubectl exec -it <new-pod-name> -- cat /usr/share/nginx/html/index.html
```

---

## Exercises
1. **Create a Custom Persistent Volume:**
   - Create a new PV with 2Gi of storage and bind it to a new PVC.
2. **Modify the StatefulSet:**
   - Add an environment variable to the StatefulSet and verify it in the Pods.
3. **Test Persistence:**
   - Repeat the persistence test with a different file in a new directory.

---

## Deliverables
- Screenshots of the StatefulSet and PVCs running.
- YAML files for the PV, PVC, and StatefulSet.
