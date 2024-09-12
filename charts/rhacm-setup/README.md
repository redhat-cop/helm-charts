

# rhacm-setup

  [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

  ![Version: 1.0.14](https://img.shields.io/badge/Version-1.0.14-informational?style=flat-square)

 

  ## Description

  Setup and configure Advanced Cluster Managerment. Replaces the Chart rhacm-full-stack.

This Helm Chart is installing and configuring Advanced Cluster Management (ACM)

## Dependencies

This chart has the following dependencies:

| Repository | Name | Version |
|------------|------|---------|
| https://redhat-cop.github.io/helm-charts | tpl | ~1.0.0 |

It is best used with a full GitOps approach such as Argo CD does. For example, https://github.com/tjungbauer/openshift-clusterconfig-gitops (for example in the folder clusters/management-cluster/setup-acm)

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| tjungbauer | <tjungbau@redhat.com> | <https://blog.stderr.at/> |

## Sources
Source:
* <https://github.com/tjungbauer/helm-charts>
* <https://charts.stderr.at/>
* <https://github.com/tjungbauer/openshift-clusterconfig-gitops>

Source code: https://redhat-cop.github.io/helm-charts/tree/main/charts/rhacm-setup

## Parameters

Verify the subcharts for additional settings:

* [helper-operator](https://github.com/tjungbauer/helm-charts/tree/main/charts/helper-operator)
* [helper-status-checker](https://github.com/tjungbauer/helm-charts/tree/main/charts/helper-operator)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| helper-operator.operators.advanced-cluster-management.enabled | bool | `false` |  |
| helper-operator.operators.advanced-cluster-management.namespace.create | bool | `true` |  |
| helper-operator.operators.advanced-cluster-management.namespace.name | string | `"open-cluster-management"` |  |
| helper-operator.operators.advanced-cluster-management.operatorgroup.create | bool | `false` |  |
| helper-operator.operators.advanced-cluster-management.operatorgroup.notownnamespace | bool | `false` |  |
| helper-operator.operators.advanced-cluster-management.subscription.approval | string | `"Automatic"` |  |
| helper-operator.operators.advanced-cluster-management.subscription.channel | string | `"release-2.10"` |  |
| helper-operator.operators.advanced-cluster-management.subscription.operatorName | string | `"advanced-cluster-management"` |  |
| helper-operator.operators.advanced-cluster-management.subscription.source | string | `"redhat-operators"` |  |
| helper-operator.operators.advanced-cluster-management.subscription.sourceNamespace | string | `"openshift-marketplace"` |  |
| helper-operator.operators.advanced-cluster-management.syncwave | string | `"0"` |  |
| helper-status-checker.checks[0].namespace.name | string | `"open-cluster-management"` |  |
| helper-status-checker.checks[0].operatorName | string | `"advanced-cluster-management"` |  |
| helper-status-checker.checks[0].serviceAccount.name | string | `"sa-acm-status-checker"` |  |
| helper-status-checker.checks[0].syncwave | int | `3` |  |
| helper-status-checker.enabled | bool | `false` |  |
| override-rhacm-operator-version | string | `"release-2.10"` | Anchor for the operator version |
| rhacm.multiclusterhub.availabilityConfig | string | `"Basic"` | Specifies deployment replication for improved availability. Options are: Basic and High @efault: -- Basic |
| rhacm.multiclusterhub.enabled | bool | false | Enable MultiClusterHub object |
| rhacm.multiclusterhub.syncwave | string | 3 | Syncwave for the MultiClusterHub |
| rhacm.multiclusterhub.tolerations | list | empty | If you want this component to only run on specific nodes, you can configure tolerations of tainted nodes. |
| rhacm.namespace.name | string | `"open-cluster-management"` |  |

## Example values

```yaml
---
---
# -- Anchor for the operator version
override-rhacm-operator-version: &rhacmversion release-2.10

# Install Operator RHACM
# Deploys Operator --> Subscription and Operatorgroup
# Syncwave: 0
helper-operator:
  operators:
    advanced-cluster-management:
      enabled: false
      syncwave: '0'
      namespace:
        name: open-cluster-management
        create: true
      subscription:
        channel: *rhacmversion
        approval: Automatic
        operatorName: advanced-cluster-management
        source: redhat-operators
        sourceNamespace: openshift-marketplace
      operatorgroup:
        create: false
        notownnamespace: false

# Using sub-chart helper-status-checker
helper-status-checker:
  enabled: false

  checks:

    - operatorName: advanced-cluster-management
      namespace:
        name: open-cluster-management
      syncwave: 3

      serviceAccount:
        name: "sa-acm-status-checker"

rhacm:
  namespace:
    name: open-cluster-management

  # Configure MultiClusterHub
  multiclusterhub:
    enabled: false
    availabilityConfig: Basic
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release repo/<chart-name>>
```

The command deploys the chart on the Kubernetes cluster in the default configuration.

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.12.0](https://github.com/norwoodj/helm-docs/releases/v1.12.0)
