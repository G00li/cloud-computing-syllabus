# PersistentVolume (PV) e PersistentVolumeClaim (PVC) no Kubernetes

No Kubernetes, **PersistentVolume (PV)** e **PersistentVolumeClaim (PVC)** são recursos usados para gerenciar armazenamento persistente em um cluster. Eles ajudam a desacoplar o armazenamento físico da lógica das aplicações, proporcionando flexibilidade e consistência.

---

## **PersistentVolume (PV)**
- **Definição**: Representa o armazenamento físico disponível no cluster, configurado pelo administrador.
- **Função**: Prover acesso a recursos de armazenamento externo (discos locais, NFS, AWS EBS, GCP PD, etc.) para Pods no cluster.
- **Características**:
  - Configurado pelo administrador.
  - Pode ser pré-provisionado ou provisionado dinamicamente (usando Storage Classes).
  - Define atributos como capacidade, tipo de acesso e a origem do armazenamento.

---

## **PersistentVolumeClaim (PVC)**
- **Definição**: É uma solicitação de armazenamento feita por usuários ou aplicações.
- **Função**: Solicitar recursos de armazenamento com requisitos específicos, como capacidade e modos de acesso.
- **Características**:
  - Criado pelos desenvolvedores ou equipes de aplicação.
  - É vinculado a um PV que atende aos critérios solicitados.

---

## **Funcionamento do PV e PVC**
1. O administrador cria um **PV**, especificando atributos como capacidade e modos de acesso.
2. O usuário cria um **PVC**, solicitando armazenamento com critérios específicos.
3. O Kubernetes verifica os PVs disponíveis e vincula automaticamente o PVC a um PV compatível.
4. O PVC é usado pelos Pods para acessar o armazenamento.

---

## **Configuração de PV e PVC**

### **Exemplo de PersistentVolume (PV)**
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: example-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: "/mnt/data"
```

- **`capacity`**: Define o tamanho do volume.
- **`accessModes`**:
    - `ReadWriteOnce` (RWO): Montável como leitura/escrita por um único nó.
    - `ReadOnlyMany` (ROX): Montável como leitura por vários nós.
    - `ReadWriteMany` (RWX): Montável como leitura/escrita por vários nós.
- **`persistentVolumeReclaimPolicy`**:
    - `Retain`: O PV não é apagado após a liberação.
    - `Recycle`: O PV é limpo e fica disponível novamente.
    - `Delete`: O PV é excluído do armazenamento.

----------------------------------------------------------
### **Exemplo de PersistentVolumeClaim (PVC)**
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: example-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

- **`accessModes`**: Deve coincidir com os modos definidos no PV.
- **`resources.requests.storage`**: Tamanho do armazenamento solicitado.

---

### **Exemplo de uso no Pod**

```
apiVersion: v1
kind: Pod
metadata:
  name: pod-with-pvc
spec:
  containers:
    - name: app-container
      image: nginx
      volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: storage-volume
  volumes:
    - name: storage-volume
      persistentVolumeClaim:
        claimName: example-pvc
```

- O PVC **`example-pvc`** é vinculado ao PV correspondente.
- O armazenamento é montado no caminho **`/usr/share/nginx/html`** no contêiner.

---

## **Função principal**

A principal função do PV e PVC é fornecer **armazenamento persistente** para as aplicações no Kubernetes, independentemente do ciclo de vida dos Pods. Assim, mesmo que um Pod seja destruído e recriado, os dados permanecem acessíveis.

---

## **Quando usar PV e PVC?**

1. **Aplicações com estado (stateful)**:
    - Bancos de dados (MySQL, PostgreSQL, MongoDB).
    - Sistemas de arquivos compartilhados.
2. **Armazenamento durável**:
    - Logs persistentes.
    - Dados que precisam sobreviver a reinicializações ou atualizações dos Pods.
3. **Desacoplamento da infraestrutura**:
    - Separar configurações de armazenamento dos Pods, facilitando migrações e mudanças de infraestrutura.

---

Ao usar PV e PVC, você proporciona armazenamento confiável e persistente, abstraindo a complexidade do gerenciamento de infraestrutura para os desenvolvedores e aplicações.