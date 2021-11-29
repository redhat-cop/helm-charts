# ⚓️ ArgoCD Operator Helm Deploy

ArgoCD Helm Chart customizes and deploys the [RedHat GitOps Operator](https://github.com/redhat-developer/gitops-operator) written by Red Hat.

## Installing the chart

To install the chart from source:
```bash
helm upgrade --install argocd -f values.yaml . --create-namespace --namespace labs-ci-cd
```

The above command creates objects with default naming convention and configuration.

## Removing

To delete the chart:
```bash
helm uninstall argocd --namespace labs-ci-cd
```

## Configuration

The [values.yml](values.yaml) file contains instructions for common chart overrides.

You can install multiple team instances of ArgoCD into different namespaces, just add your namespace to this list. Namespaces should be created separately first e.g. in the bootstrap chart or as shown above for a single namespace called `labs-ci-cd`.
```yaml
# add to this list to deploy 'argocd' to multiple namespaces
namespaces:
- labs-ci-cd
```

RBAC for each ArgoCD instance is cluster admin scoped. You will need to modify and adjust the `templates` Cluster Roles if this does not suit your purposes.

The default GitOps ArgoCD instance is _not_ deployed in the `openshift-gitops` operator project. You can enable it by setting `disableDefaultArgoCD: false`

You _do not_ need to override the ArgoCD `applicationInstanceLabelKey`. It is automatically generated based on the namespace name.

Anything configurable in the Operator is passed to the ArgoCD custom resource provided by the Operator. See `argocd_cr` in `values.yaml` for example defaults. For more detailed overview of what's included, checkout the [ArgoCD Operator Docs](https://argocd-operator.readthedocs.io/en/latest/reference/argocd/).

If you wish to use ArgoCD to manage this chart directly (or as a helm chart dependency) you may need to make use of the `ignoreHelmHooks` flag to ignore helm lifecycle hooks.

One example might be deploying team instances without the Operator and helm lifecycle hooks.
```bash
helm template foo charts/gitops-operator --set operator= --set ignoreHelmHooks=true | oc apply -f-
```

Or deploying just the Operator, no helm lifecycle hooks and no team instances.
```bash
helm template foo charts/gitops-operator --set namespaces= --set ignoreHelmHooks=true | oc apply -f-
```
