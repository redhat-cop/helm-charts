# ⚓️ ArgoCD Operator Helm Deploy

ArgoCD Helm Chart customizes and deploys the [RedHat GitOps Operator](https://github.com/redhat-developer/gitops-operator) written by Red Hat.

## Installing the chart

To install the chart from source:
```bash
# within this directory charts/gitops-operator
helm upgrade --install argocd -f values.yaml . --create-namespace --namespace labs-ci-cd
```

The above command creates objects with default naming convention and configuration.

To install the chart from the published chart (with defaults):
```bash
# add the redhat-cop repository
helm repo add redhat-cop https://redhat-cop.github.io/helm-charts

# having added redhat-cop helm repository
helm upgrade --install argocd redhat-cop/gitops-operator --create-namespace --namespace labs-ci-cd
```

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

RBAC for each ArgoCD instance is `cluster-admin` scoped by default. You can create `namespaced` ArgoCD instances by specifying `teamInstancesAreClusterScoped: false`. This setting does not deploy any excess RBAC and uses the defaults from the gitops-operator.

If you want fine-grained access, you may set `clusterRoleRulesController` and `clusterRoleRulesServer` with Role rules that suit your purpose.

The default GitOps ArgoCD instance is _not_ deployed in the `openshift-gitops` operator project. You can enable it by setting `disableDefaultArgoCD: false`

You _do not_ need to override the ArgoCD `applicationInstanceLabelKey`. It is automatically generated based on the namespace name.

Anything configurable in the Operator is passed to the ArgoCD custom resource provided by the Operator. See `argocd_cr` in `values.yaml` for example defaults. For more detailed overview of what's included, checkout the [ArgoCD Operator Docs](https://argocd-operator.readthedocs.io/en/latest/reference/argocd/).

If you wish to use ArgoCD to manage this chart directly (or as a helm chart dependency) you may need to make use of the `ignoreHelmHooks` flag to ignore helm lifecycle hooks.

One example might be deploying team instances without the Operator and helm lifecycle hooks.
```bash
helm upgrade --install foo redhat-cop/gitops-operator --set operator=null --set ignoreHelmHooks=true
```

Or deploying just the Operator, no helm lifecycle hooks and no team instances.
```bash
helm upgrade --install foo redhat-cop/gitops-operator --set namespaces=null --set ignoreHelmHooks=true
```

## Teams and ArgoCD

Checkout the [TEAM DOCS](TEAM_DOCS.md) if you would like to understand more on how to use this chart with your teams.

![docs/images/cluster-argo.png](docs/images/cluster-argo.png)
