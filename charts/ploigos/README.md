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

## Installation

Add the chart repo
```bash
helm repo add redhat-cop https://redhat-cop.github.io/helm-charts
helm repo update
```

Once to TSSC CRD has been installed in the cluster, install the operator and platform into the `devsecops` namespace
```bash
helm upgrade --install ploigos redhat-cop/ploigos --namespace devsecops --create-namespace
```
## Deleting

Deleting the helm chart works, however the ploigos operator does not yet clean up tidily yet, so you can run:
```bash
helm uninstall ploigos --namespace devsecops
oc delete $(oc get subscription -o name) -n devsecops

oc patch keycloakrealms.keycloak.org openshift -n devsecops --type='json' -p='[{"op": "remove" , "path": "/metadata/finalizers" }]'
oc patch keycloakusers.keycloak.org workshop-admin openshift-admin openshift-admin user{1..3} -n devsecops --type='json' -p='[{"op": "remove" , "path": "/metadata/finalizers" }]'
oc patch keycloakclients.keycloak.org gitea-client openshift-client sonarqube-client -n devsecops -n devsecops --type='json' -p='[{"op": "remove" , "path": "/metadata/finalizers" }]'
oc patch tsscplatform tsscplatform -n devsecops --type='json' -p='[{"op": "remove" , "path": "/metadata/finalizers" }]'
oc delete project devsecops
```
