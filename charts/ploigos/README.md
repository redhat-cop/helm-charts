# Ploigos

A Wrapper Helm Chart to deploy the [ploigos platform](https://github.com/ploigos) - check there for the full ploigos documentation. In particular [the operator repository.](https://github.com/ploigos/ploigos-software-factory-operator)

Plogios is an opinionated trusted software supply chain utilizing this toolchain:

- Tekton
- Jenkins
- Quay
- Keycloak
- ArgoCD
- Gitea
- Sonarqube
- Code Ready Workspaces
- Mattermost
- Nexus
- Selenium Grid

The pipeline steps are implemented in python using this [step-runner-library](https://github.com/ploigos/ploigos-step-runner).

Once you have installed the platform you can use the `TsscPipeline CRD`

# Usage

As a cluster admin user, to install plogios operator and platform into the `devsecops` namespace
```bash
helm repo add redhat-cop https://redhat-cop.github.io/helm-charts
helm repo update
helm upgrade --install ploigos redhat-cop/ploigos --namespace devsecops --create-namespace
```

Deleting the helm chart works, however the ploigos operator does not yet clean up tidily, so run:
```bash
helm delete ploigos --namespace devsecops
oc delete $(oc get subscription -o name) -n devsecops
oc delete project devsecops
```
