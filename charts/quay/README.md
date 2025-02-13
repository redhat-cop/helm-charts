# Quay

Quay is a powerful container registry platform with many features and components, and is highly configurable. Below values would help you to store your Quay configurations easily.

## Prereqs

Requires Quay Operator. You can use [Operator Installer Helm Chart](https://github.com/redhat-cop/helm-charts/tree/main/charts/operators-installer) to deploy it.

Example values:

```yaml
operators:
- channel: stable-3.8
  installPlanApproval: Manual
  name: quay-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
  csv: quay-operator.v3.8.12
```

## Installation

Add the redhat-cop helm chart repo:

```bash
helm repo add redhat-cop https://redhat-cop.github.io/helm-charts
helm repo update
```
Deploy the helm chart:

```bash
helm install quay redhat-cop/quay
```

The above command deploys Quay on a cluster. Create your custom values.yaml file to include your customizations. The [configuration](#configuration) section lists the parameters that can be configured during installation.


```bash
helm install quay redhat-cop/quay -f your-custom-values.yaml
```

## Configuration
The following table lists the configurable parameters of the Quay chart and their default values.

| Parameter                   | Description                                                                         |
|-----------------------------|-------------------------------------------------------------------------------------|
| quay_registry_config_bundle | Components of the config bundle to include your own AD onfig, TLS/SSL certificate + key pair, etc |
| registry_components         | Components and dependencies for the quay registry. Enable/disable by editing the values file.|
| infra_nodes                 | Togglable value to pin the Quay registry to the infra nodes. Default is false.      |

## Uninstallation

```bash
helm uninstall quay
```
