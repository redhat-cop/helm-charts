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

## Add Helm Chart Repo

Add the chart repo
```bash
helm repo add redhat-cop https://redhat-cop.github.io/helm-charts
helm repo update
```
## New cluster with no TSSC CRD's

If your cluster does not contain the TSSC CRD:
```bash
oc get crd tsscplatforms.redhatgov.io
```

You must first install it as a cluster admin user using the operator subscription which we can uninstall once done.
```bash
cd ./ploigos-subs
helm upgrade --install ploigos-subs . --namespace devsecops --create-namespace
helm uninstall ploigos-subs --namespace devsecops
```
## Cluster that contains TSSC CRD's

Once to TSSC CRD has been installed in the cluster, install the operator and platform into the `devsecops` namespace
```bash
helm upgrade --install ploigos redhat-cop/ploigos --namespace devsecops
```

## Deleting

Deleting the helm chart works, however the ploigos operator does not yet clean up tidily, so run:
```bash
helm uninstall ploigos --namespace devsecops
oc delete $(oc get subscription -o name) -n devsecops
oc delete project devsecops
```
