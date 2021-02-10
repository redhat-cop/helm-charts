# ⚓️ ArgoCD Operator Helm Deploy

ArgoCD Helm Chart customises and deploys the [ArgoCD](https://argoproj.github.io/argo-cd/getting_started/) project using the [Operator](https://argocd-operator.readthedocs.io/en/latest/) written by Red Hat.

## Installing the chart

To install the chart from source:
```bash
helm upgrade --install argocd -f values.yaml . --create-namespace --namespace labs-ci-cd
```

The above command creates objects with default naming convention and configuration.

## Removing

To delete the chart:
```
helm uninstall argocd --namespace labs-ci-cd
```

## Configuration

The [values.yml](values.yaml) file contains instructions for common chart overrides.

For more detailed overview of what's configurable, checkout the [ArgoCD Operator Docs](https://argocd-operator.readthedocs.io/en/latest/reference/argocd/)
