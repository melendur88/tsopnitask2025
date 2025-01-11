## Task Overview
This repository contains the implementation of the provided task to set up a semi-platform for deploying and managing a Spring Boot API application using Kubernetes, Helm, and Argo CD. The solution was developed and tested on **Minikube** due to the lack of access to a full-fledged cluster. Below are the key details and considerations.

## Features Implemented
1. **Application Deployment in Kubernetes**:
   - A `Deployment` for the Spring Boot API was created using `busybox` to simulate application behavior with configurable profiles (`dev` and `prd`).
   - Kubernetes secrets and config maps are used to securely provide sensitive and configuration-specific data to the application.

2. **Helm Chart**:
   - A simple Helm Chart manages all Kubernetes resources (Deployment, Service, Secrets, ConfigMaps, etc.).
   - Values specific to environments (`dev` and `prd`) are stored in separate YAML files for flexibility.

3. **Argo CD Integration**:
   - The solution includes an `ApplicationSet` definition to deploy the application across multiple environments.

## Challenges and Considerations

### Minikube Usage
The implementation was tested and verified using **Minikube**, as no distinct clusters were available. To run this setup on separate clusters:
1. Modify the `ApplicationSet` generator to target a single desired cluster:
   ```yaml
   generators:
     - list:
         elements:
           - cluster: https://<desired-cluster-api-endpoint>
             environment: dev
   ```
   Replace `<desired-cluster-api-endpoint>` with the appropriate Kubernetes API server endpoint.

2. I've used generators with forced two enviroments to be sure that everything its running and clear.

3. If there is need to run one env (prod, or dev) on seperate cluster, snsure that the destination server and namespace are correctly configured for the targeted cluster in the `ApplicationSet`:
   ```yaml
   destination:
     server: https://<desired-cluster-api-endpoint>
     namespace: <target-namespace>
   ```

### PreStop and `wget`
The task required a `wget` command to be executed on the `/service/shutdown` endpoint during pod termination (`preStop`). I implemented this as follows:
```yaml
lifecycle:
  preStop:
    exec:
      command: ["/bin/sh", "-c", "wget -q -O- http://localhost:8080/service/shutdown && echo Shutdown triggered >> /app/shutdown.log"]
```

#### Concerns
- **Ambiguity in Requirements**: There were uncertainties regarding how exactly the `wget` command was expected to function and how its success should be validated. I interpreted the task to mean that the command should send a `GET` request to the local application and log its success.
- **Follow-up**: An email was sent for clarification, but no response was received. The implementation is based on my understanding of the requirement.

## How to Use

### Prerequisites
- Any Kubernetes Cluster. 
- **Helm** installed.
- **Argo CD** configured and running in your Kubernetes cluster.

### Steps
1. Deploy the application using the Helm Chart:
   ```bash
   helm install spring-boot-api ./helm-chart -f ./helm-chart/values-dev.yaml
   ```

2. Apply the `ApplicationSet` to enable GitOps management via Argo CD:
   ```bash
   kubectl apply -f argo-appset/application-set.yaml
   ```

3. To run the setup on a distinct cluster, follow the steps mentioned in the **Minikube Usage** section.

## Notes
- The solution is designed to be flexible and environment-agnostic, with minor modifications required for multi-cluster setups.
- If using Minikube, ensure that the necessary resources (memory, CPU) are allocated to avoid resource constraints.

---
If you encounter any issues or need clarification, feel free to reach out.
