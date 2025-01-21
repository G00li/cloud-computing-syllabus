[Documentação](https://developer.hashicorp.com/terraform?product_intent=terraform)

[Hashicorp](https://www.hashicorp.com/products/terraform)

[Terraform Tutorial](https://developer.hashicorp.com/terraform/tutorials/configuration-language/resource)

 **Todos os ficheiros (.tf) devem está no mesmo contexto** 
## 1. Para iniciar o Terraform

```
Terraform init
```


## 2. Pesquisar o provider no Terraform Registry 

[Terraform Registry](https://registry.terraform.io/browse/providers)

No Terraform, um **provider** é o componente que atua como um "plugin" para interagir com diferentes APIs ou serviços (como AWS, Azure, Google Cloud, Kubernetes, etc.). Ele traduz as configurações do Terraform em chamadas específicas para esses serviços, permitindo que você gerencie recursos de infraestrutura de forma consistente.

### Funcionalidade do **Provider** no Terraform:

1. **Conexão com APIs:**
    
    - O provider lida com a autenticação e as comunicações necessárias para interagir com os serviços.
    - Por exemplo, o provider da AWS configura os tokens de acesso para criar instâncias EC2 ou buckets S3.
2. **Definição de Recursos:**
    
    - Ele expõe tipos de recursos e dados disponíveis para configuração.
    - Por exemplo, com o provider do AWS, você pode usar recursos como `aws_instance` e `aws_s3_bucket`.
3. **Abstração da Infraestrutura:**
    
    - O provider abstrai a complexidade das APIs subjacentes, permitindo que você gerencie infraestrutura em diferentes provedores usando o mesmo formato de configuração HCL (HashiCorp Configuration Language).
4. **Modularidade:**
    
    - Você pode usar múltiplos providers em uma configuração para gerenciar diferentes serviços em conjunto. Por exemplo, usar AWS para computação e Cloudflare para DNS.

## 3. Executar o plan 

```
Terraform plan -out=plan 
```

O comando `terraform plan` é usado no Terraform para simular as mudanças que serão aplicadas à infraestrutura antes de executá-las. Ele compara o estado atual da infraestrutura (conforme armazenado no **estado do Terraform**) com o estado desejado definido nos arquivos de configuração e gera um **plano de execução**.

### Funcionalidade do `terraform plan`:

1. **Simulação das Alterações:**
    
    - O comando exibe quais recursos serão **criados**, **atualizados** ou **destruídos** sem realmente fazer essas mudanças.
    - Isso ajuda a entender o impacto das alterações antes de aplicá-las.
2. **Identificação de Erros:**
    
    - O comando verifica a configuração do Terraform em busca de erros de sintaxe ou lógica, como argumentos inválidos ou dependências ausentes.
3. **Visualização do Plano:**
    
    - O plano detalhado mostra:
        - Recursos que serão adicionados (`+`).
        - Recursos que serão destruídos (`-`).
        - Recursos que serão atualizados (`~`), com os detalhes das mudanças.
4. **Uso com `-out`:**
    
    - É possível salvar o plano gerado em um arquivo usando o argumento `-out`:
        
	```
        terraform plan -out=plan.tfplan
	``` 
	- Isso permite executar o comando `terraform apply` posteriormente com o mesmo plano, garantindo que as mudanças previstas sejam exatamente as aplicadas.
		
1. **Execução Segura:**
    
    - O `terraform plan` é especialmente útil para equipes que precisam revisar as alterações antes de implementá-las em um ambiente de produção.

## 4. Output plan 

```
terraform apply plan
```

**Faz o apply do ficheiro (plan) que geramos.** 
**Cria o minikube nesse momento.** 

O comando `terraform apply plan` é usado para aplicar um **plano de execução** previamente gerado com o comando `terraform plan -out=<arquivo>`. Seu objetivo é implementar as mudanças na infraestrutura exatamente como definidas no plano salvo, garantindo que as ações executadas sejam consistentes com o que foi revisado.

### Objetivo do `terraform apply plan`

1. **Consistência:**
    
    - Garante que o plano revisado anteriormente seja aplicado sem alterações, mesmo que as configurações ou o estado tenham mudado desde a geração do plano.
2. **Execução Segura:**
    
    - É útil em ambientes de produção ou em pipelines CI/CD, onde previsibilidade e controle são essenciais.
3. **Evitar Recriação do Plano:**
    
    - Ao usar um plano salvo, você economiza tempo e elimina a necessidade de regenerar o plano antes de aplicar.

## 5. Realizando um Destroy 

1. Faz o destroy do plan com o comando 
```
   Terraform apply -out=plan -destroy
```

2. Gera um novo plan
```
Terraform apply -out=plan  
```

3. Aplica o plan
```
Terraform apply plan
```
Provavelmente gera um erro: 
```
		Erro: Saved Plan is stable
		the given plan file can no longer be applied because the state was chenged by another opreration

```
4. Cria um novo plan
```
Terraform plan -out=plan 
```

`must be replaced`
Serviço necessariamente vai ser destruído. Independente se tiver rodando alguma aplicação

5. Aplica o novo plan
```
Terraform apply plan 
```
- Vai destruir o anterior por completo e vai criar um novo do 0. 



## 5. Após aplicar um novo provider 

Realizar o comando: 
```
terraform init -upgrade 
```

