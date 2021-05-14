
# OperatorHub

[OperatorHub](https://operatorhub.io/) is a central location to find the wide array of great Operators that have been built by the community. Packaging of the Operators indexed in OperatorHub.io relies on the  [Operator Lifecycle Manager](https://github.com/operator-framework/operator-lifecycle-manager) (OLM) to install, manage and update Operators consistently on any Kubernetes cluster.

The OperatorHub and OLM are [available](https://docs.openshift.com/container-platform/4.3/operators/olm-understanding-operatorhub.html) via the OpenShift Container Platform web console as well and is the interface that cluster administrators use to discover and install Operators.

## Introduction

This chart enables specific operators as it creates a subscription for the specific operator. For this, it creates a Subscription resource instance and a OperatorGroup for the relevant operator's subscription. A ClusterServiceVersion (CSV) is created automatically since the value of CSV is set in the Subscription, so all of the custom resources relevant to the operator are created.

If [installModes](https://docs.openshift.com/container-platform/4.5/operators/understanding/olm/olm-understanding-operatorgroups.html#olm-operatorgroups-membership_olm-understanding-operatorgroups) are specified, then the CSV object is patched accordingly.

If the [namespaceSelector](https://docs.openshift.com/container-platform/4.5/operators/understanding/olm/olm-understanding-operatorgroups.html#olm-operatorgroups-target-namespace_olm-understanding-operatorgroups) is set, then instead of targeting just the own Nnamespace, the operator will select multiple NS based on the label provided.

## Installing the chart

To add the chart repo:

```bash
$ helm repo add rht-labs https://rht-labs.github.io/rht-labs
```
After adding the chart repo, create a YAML file to specify the overrides in the following structure:

```yaml
namespace: operator-namespace
operators:
  - name: subscription-name
    subscription:
      channel: operator-channel
      approval: approval-type
      operatorName: operator-name
      sourceName: catalog-source
      sourceNamespace: catalog-source-namespace
      csv: optional-catalog-source-version
    operatorgroup:
      create: true
```

Change the values regarding to the operator you want to use. (See the [Configuration](#Configuration) section for the overrides' descriptions.)

To install the chart:

```bash
$ helm install -f custom-values.yaml rht-labs/operatorhub
```
Or you can just pass custom parameters without creating a YAML file:

```bash
$ helm install rht-labs/operatorhub --set operators[0].name=OPERATOR_NAME,operators[0].namespace=OPERATOR_NAMESPACE ... (set all the mandatory variables)
```
For more info about overriding variables see: [Customizing the chart](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing)

## Uninstalling the chart

To uninstall/delete the deployment:

```bash
$ helm uninstall <name of chart>
```

## Configuration

The following table lists the configurable parameters of the OperatorHub chart and their default values.

| Parameter (For each `operator`)                             | Description                                                               | Default                  |
| ------------------------------------- | ----------------------------------------------------------------------------------------------- | ------------------------ |
| `name`                                | Name of the Subscription                                                                        |                          |
| `namespace`                           | The namespace the Subscription will be created in                                               |                          |
| `subscription.channel`                | Operator's subscription channel which is specific for the operator                              |                          |
| `subscription.approval`               | Subscription's install plan approval                                                            | `Automatic`              |
| `subscription.operatorName`           | Name of the operator                                                                            |                          |
| `subscription.sourceName`             | Operator's source which the operator belongs to                                                 | `redhat-operators`       |
| `subscription.sourceNamespace`        | Operator's namespace where the operator will be pulled from                                     | `openshift-marketplace`  |
| `subscription.csv`                    | ClusterServiceVersion's name which will be created regarding to the operator                    |                          |
| `operatorgroup.create`                | An OperatorGroup will be created with the same name of the Subscription if the value is `true`  | `true`                   |
| `operatorgroup.namespaceSelector`     | Optional. (It will be deprecated in futures releases). An OperatorGroup [namespace Selector](https://docs.openshift.com/container-platform/4.5/operators/understanding/olm/olm-understanding-operatorgroups.html#olm-operatorgroups-target-namespace_olm-understanding-operatorgroups) in case your operator needs to watch more than one ns. Example: `"monitoring: yes"`.                                                                                                                                     |
| `operatorgroup.installModes:`         | Optional. Change operator [install modes](https://docs.openshift.com/container-platform/4.5/operators/understanding/olm/olm-understanding-operatorgroups.html#olm-operatorgroups-membership_olm-understanding-operatorgroups) in the ClusterServiceVersion object.                                 |                          |

Prometheus Operator example, with `namespaceSelector` and `installModes`:

```yaml
namespace: prometheus-operator
operators:
  - name: prometheus-operator
    subscription:
      channel: beta
      approval: Automatic
      operatorName: prometheus
      sourceName: community-operators
      sourceNamespace: openshift-marketplace
      csv: prometheusoperator.0.37.0
    operatorgroup:
      create: true
      namespaceSelector: 'labelKey: LabelValue'
    installModes:
      OwnNamespace: true
      SingleNamespace: false
      MultiNamespace: true
      AllNamespaces: false

```
