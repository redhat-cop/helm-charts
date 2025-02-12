

# cost-management

  [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

  ![Version: 1.0.10](https://img.shields.io/badge/Version-1.0.10-informational?style=flat-square)

 

  ## Description

  Setup and configure cost-management Operator

This Helm Chart is installing and configuring the Cost Management operator, using the following workflow:

1. Create required Namespace
2. Installing the Compliance operator by applying the Subscription and OperatorGroup object. (In addition, the InstallPlan can be approved if required)
3. Verifying if the operator is ready to use Install and configure the compliance operator.
4. Apply a ScanSettingBinding and, optionally, a TailoredProfile.

## Dependencies

This chart has the following dependencies:

| Repository | Name | Version |
|------------|------|---------|
| https://redhat-cop.github.io/helm-charts | helper-operator | ~1.0.21 |
| https://redhat-cop.github.io/helm-charts | helper-status-checker | ~4.0.0 |
| https://redhat-cop.github.io/helm-charts | tpl | ~1.0.0 |

It is best used with a full GitOps approach such as Argo CD does. For example, https://github.com/tjungbauer/openshift-clusterconfig-gitops

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| tjungbauer | <tjungbau@redhat.com> | <https://blog.stderr.at/> |

## Sources
Source:

Source code: https://redhat-cop.github.io/helm-charts/tree/main/charts/network-observability

## Parameters

:bulb: **TIP**: See README files of sub Charts for additional possible settings: [helper-operator](https://github.com/tjungbauer/helm-charts/tree/main/charts/helper-operator) and [helper-status-checker](https://github.com/tjungbauer/helm-charts/tree/main/charts/helper-operator).

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| costmgmt.airgapped | bool | false | Is the cluster running in an airgapped or disconnected environment, we cannot upload the cost management data. |
| costmgmt.auth_secret | string | `"mysecret"` | The secret with the user and password used for uploads. |
| costmgmt.auth_type | string | token | Authentication: Valid values are:  - "basic" (deprecated) : Enables authentication using user and password from authentication secret.  - "service-account" : Enables authentication using client_id and client_secret from the secret containing service account information.  - "token" (default): Uses cluster token for authentication. If the cluster is running in airgapped mode, then these settings can be ignored. |
| costmgmt.enabled | bool | false | Enable or disable the configuration of the cost management operator |
| costmgmt.max_reports_to_store | int | 30 | Represents the maximum number of reports to store. The default is 30 reports which corresponds to approximately 7 days worth of data given the other default values. |
| costmgmt.max_size_MB | int | 100 | Represents the max file size in megabytes that will be compressed for upload to Ingress. Must be less or euqal 100. |
| costmgmt.name | string | costmanagementmetricscfg | Name of the cost manager CRD |
| costmgmt.promconfig_collect_previous_data | string | true | Represents whether or not the operator will gather previous data upon CostManagementMetricsConfig creation. This toggle only changes operator behavior when a new CostManagementMetricsConfig is created. When `true`, the operator will gather all existing Prometheus data for the current month. |
| costmgmt.promconfig_context_time | int | 120 | How long a query to prometheus should run in seconds before timing out. |
| costmgmt.promconfig_disable_metric_coll_cost_management | string | false | Whether or not the operator will generate reports for cost-management metrics. |
| costmgmt.promconfig_disable_metric_coll_resource_optimization | string | false | Whether or not the operator will generate reports for resource-optimization metrics. |
| costmgmt.promconfig_service_address | string | "https://thanos-querier.openshift-monitoring.svc:9091" | Service addess to prometheus. For development only. |
| costmgmt.promconfig_skip_tls_verification | string | false | Skip TLS verification to thanos-querier endpoint. |
| costmgmt.upload_cycle | int | 360 | Represents the number of minutes between each upload schedule. |
| costmgmt.upload_toggle | bool | true | If `false`, the operator will not upload to console.redhat.com or check/create sources. |
| helper-operator.operators.cost-management-operator.enabled | bool | false | Enabled yes/no |
| helper-operator.operators.cost-management-operator.namespace.create | bool | "" | Description of the namespace. |
| helper-operator.operators.cost-management-operator.namespace.name | string | `"costmanagement-metrics-operator"` | The Namespace the Operator should be installed in. The cost-management operator should be deployed into **costmanagement-metrics-operator** Namepsace that must be created. |
| helper-operator.operators.cost-management-operator.operatorgroup.create | bool | false | Create an Operatorgroup object |
| helper-operator.operators.cost-management-operator.operatorgroup.notownnamespace | bool | false | Monitor own Namespace. For some Operators no `targetNamespaces` must be defined |
| helper-operator.operators.cost-management-operator.subscription.approval | string | Automatic | Update behavior of the Operator. Manual/Automatic |
| helper-operator.operators.cost-management-operator.subscription.channel | string | stable | Channel of the Subscription |
| helper-operator.operators.cost-management-operator.subscription.operatorName | string | "empty" | Name of the Operator The name for the cost-management operator is **costmanagement-metrics-operator** |
| helper-operator.operators.cost-management-operator.subscription.source | string | redhat-operators | Source of the Operator |
| helper-operator.operators.cost-management-operator.subscription.sourceNamespace | string | openshift-marketplace | Namespace of the source |
| helper-operator.operators.cost-management-operator.syncwave | string | 0 | Syncwave for the operator deployment |
| helper-status-checker.checks[0].namespace.name | string | `"costmanagement-metrics-operator"` |  |
| helper-status-checker.checks[0].operatorName | string | `"costmanagement-metrics-operator"` |  |
| helper-status-checker.checks[0].serviceAccount.name | string | `"sa-costmanagement-metrics"` |  |
| helper-status-checker.checks[0].syncwave | int | `3` |  |
| helper-status-checker.enabled | bool | `false` |  |

## Example values

```yaml
---
cost-management:
  costmgmt:
    enabled: false
    name: costmanagementmetricscfg
    airgapped: true
    max_reports_to_store: 60
    upload_cycle: 360

# Using sub-chart helper-operator
helper-operator:
  operators:
    cost-management-operator:
      enabled: false
      syncwave: '0'
      namespace:
        name: costmanagement-metrics-operator
        create: true
      subscription:
        channel: stable
        approval: Automatic
        operatorName: costmanagement-metrics-operator
        source: redhat-operators
        sourceNamespace: openshift-marketplace
      operatorgroup:
        create: false
        notownnamespace: false

# Using sub-chart helper-status-checker
helper-status-checker:
  enabled: false

  checks:

    - operatorName: costmanagement-metrics-operator
      namespace:
        name: costmanagement-metrics-operator
      syncwave: 3

      serviceAccount:
        name: "sa-costmanagement-metrics"
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
