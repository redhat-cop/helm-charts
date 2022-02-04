# ⚓️ ArgoCD Operator Helm Deploy

> :warning: **DEPRECATED**: This chart is no longer maintained. You can use the functionally equivalent [gitops-operator](https://github.com/redhat-cop/helm-charts/tree/master/charts/gitops-operator) chart instead.

ArgoCD Helm Chart customises and deploys the [ArgoCD](https://argoproj.github.io/argo-cd/getting_started/) project using the [Operator](https://argocd-operator.readthedocs.io/en/latest/) written by Red Hat.

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

## Troubleshooting

If your chart only partially installed you can try disabling hooks when deleting
```bash
helm delete argocd --no-hooks
```

## Configuration

The [values.yml](values.yaml) file contains instructions for common chart overrides.

Anything configurable in the Operator is passed to the ArgoCD custom resource provided by the Operator. For more detailed overview of what's included, checkout the [ArgoCD Operator Docs](https://argocd-operator.readthedocs.io/en/latest/reference/argocd/)

If you wish to use ArgoCD to manage this chart directly (or as a helm chart dependency) you may need to make use of the `ignoreHelmHooks` flag to ignore helm lifecycle hooks. For example as a Helm Chart dependency to UJ bootstrap:
```bash
argocd app create bootstrap-journey \
  --dest-namespace labs-bootstrap \
  --dest-server https://kubernetes.default.svc \
  --repo https://github.com/rht-labs/ubiquitous-journey.git \
  --revision master \
  --sync-policy automated \
  --path "bootstrap" \
  --helm-set argocd-operator.ignoreHelmHooks=true \
  --values "values-bootstrap.yaml"
```
