
# OperatorHub

[OperatorHub](https://operatorhub.io/) is a central location to find the wide array of great Operators that have been built by the community. Packaging of the Operators indexed in OperatorHub.io relies on the  [Operator Lifecycle Manager](https://github.com/operator-framework/operator-lifecycle-manager) (OLM) to install, manage and update Operators consistently on any Kubernetes cluster.

The OperatorHub and OLM are available via the OpenShift Container Platform web console as well and is the interface that cluster administrators use to discover and install Operators.

## Introduction

This chart enables specific operators as it creates a subscription for the specific operator. For this, it creates a Subscription resource instance and a OperatorGroup for the relevant operator's subscription. A ClusterServiceVersion (CSV) is created automatically since the value of CSV is set in the Subscription, so all of the custom resources relevant to the operator are created.


## Installing the chart

To install the chart:

```bash
$ helm repo add rht-labs-charts https://rht-labs.github.io/charts
```
After installing the chart, create a YAML file to specify the overrides in the following structure:

```yaml
operators:
  - name: subscription-name
    namespace: operator-namespace
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

Change the values regarding to the operator you want to use. See the [Configuration](#configuration) section for the overrides' descriptions.

```bash
$ helm install -f custom-values.yaml rht-labs-charts/operatorhub
```
Or you can just pass custom the parameters without creating a YAML file:

```bash
$ helm install rht-labs-charts/operatorhub --set operators[0].name=OPERATOR_NAME,operators[0].namespace=OPERATOR_NAMESPACE ...
```

## Uninstalling the chart

To uninstall/delete the deployment:

```bash
$ helm uninstall <name of chart>
```

## <a name="configuration"></a>Configuration

The following table lists the configurable parameters of the OperatorHub chart and their default values.

| Parameter (For each operator)                             | Description                                                                  | Default                                        |
| ------------------------------------- | ---------------------------------------------------------------------------- | ---------------------------------------------- |
| `name`                        | Name of the Subscription                                                  | `subscription-name`                                          |
| `namespace`                        | Name of the Subscription                                                  | `operator-namespace`                                          |
| `subscription.channel`                        | Name of the Subscription                                                  | `operator-channel`                                          |
| `subscription.approval`                        | Name of the Subscription                                                  | `approval-type`                                          |
| `subscription.operatorName`                        | Name of the Subscription                                                  | `operator-name`                                          |
| `subscription.sourceName`                        | Name of the Subscription                                                  | `catalog-source`                                          |
| `subscription.sourceNamespace`                        | Name of the Subscription                                                  | `operator-namespace`                                          |
...

For overriding variables see: [Customizing the chart](https://docs.helm.sh/using_helm/#customizing-the-chart-before-installing)

<!--stackedit_data:
eyJoaXN0b3J5IjpbNjMyMTc4NjE3LC0yMDMyNzI1ODAzLDE3NT
g5MDcyMjIsLTM0NjYzODg5OCwtMTI4ODMxMzY3MywzNDMzMzc2
ODddfQ==
-->