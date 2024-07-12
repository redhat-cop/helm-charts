

# helper-lokistack

  [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

  ![Version: 1.0.9](https://img.shields.io/badge/Version-1.0.9-informational?style=flat-square)

 

  ## Description

  The only purpose of this helper chart is to provide a template for the LokiStack Custom Resource, so it must not be re-defined for multiple services.

This Helm Chart is configuring the LokiStack object. This is for example required for OpenShift Logging and Network Observability.

## Dependencies

This chart has the following dependencies:

| Repository | Name | Version |
|------------|------|---------|
| https://redhat-cop.github.io/helm-charts | tpl | ~1.0.0 |

It is best used with a full GitOps approach such as Argo CD does. For example, https://github.com/tjungbauer/openshift-clusterconfig-gitops

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| tjungbauer | <tjungbau@redhat.com> | <https://blog.stderr.at/> |

## Sources
Source:

Source code: https://redhat-cop.github.io/helm-charts/tree/main/charts/helper-lokistack

## Parameters

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| admin_groups | list | none | AdminGroups defines a list of groups, whose members are considered to have admin-privileges by the Loki Operator. Setting this to an empty array disables admin groups. By default the following groups are considered admin-groups: - system:cluster-admins - cluster-admin - dedicated-admin |
| enabled | bool | false | Enable or disable LokiStack configuration |
| limits.global.retention_days | int | 7 | This is for log streams only, not the retention of the object store. Data retention must be configured on the bucket. |
| limits.global.streams | list | N/A | Sets retention policy for all log streams. Note: This field does not impact the retention period for stored logs in object storage. Be sure to keep the correct syntax to the selector |
| limits.tenants | object | N/A | Sets retention policy by tenant. Valid tenant types are application, audit, and infrastructure. |
| limits.tenants.application | object | N/A | Type Application |
| limits.tenants.application.retention | object | none | Set retention time for application logs |
| limits.tenants.application.retention.streams | list | N/A | Set specific streams for the applications logs |
| limits.tenants.application.retention.streams[0] | object | `{"days":4,"selector":"'{kubernetes_namespace_name=~\"test.+\"}'"}` | Retention time for the selector namespace =~test. Be sure to keep the correct syntax to the selector |
| limits.tenants.audit | object | N/A | Type Audit |
| limits.tenants.audit.retention | object | none | Set retention time for audit logs |
| limits.tenants.audit.retention.streams | list | N/A | Set specific streams for the audit logs |
| limits.tenants.audit.retention.streams[0] | object | `{"days":1,"selector":"'{kubernetes_namespace_name=~\"openshift-cluster.+\"}'"}` | Retention time for the selector namespace starting with openshift-cluster. Be sure to keep the correct syntax to the selector |
| limits.tenants.infrastructure | object | N/A | Type Infrastructure |
| limits.tenants.infrastructure.retention | object | none | Set retention time for infrastructure logs |
| limits.tenants.infrastructure.retention.streams | list | N/A | Set specific streams for the infrastructure logs |
| limits.tenants.infrastructure.retention.streams[0] | object | `{"days":1,"selector":"'{kubernetes_namespace_name=~\"openshift-cluster.+\"}'"}` | Retention time for the selector namespace starting with openshift-cluster. Be sure to keep the correct syntax to the selector |
| mode | string | static | Mode defines the mode in which lokistack-gateway component will be configured. Can be either: static (default), dynamic, openshift-logging, openshift-network |
| name | string | `"logging-loki"` | Name of the LokiStack object |
| namespace | string | `"openshift-logging"` | Namespace of the LokiStack object |
| podPlacements | object | `{}` | Control pod placement for LokiStack components. You can define a list of tolerations for the following components: compactor, distributer, gateway, indexGateway, ingester, querier, queryFrontend, ruler |
| storage.schemas[0] | object | v12 | Version for writing and reading logs. Can be v11 or v12 |
| storage.schemas[0].effectiveDate | string | 2022-06-01 | EffectiveDate is the date in UTC that the schema will be applied on. To ensure readibility of logs, this date should be before the current date in UTC. |
| storage.secret.name | string | `"logging-loki-s3"` | Name of a secret in the namespace configured for object storage secrets. |
| storage.secret.type | string | s3 | Type of object storage that should be used |
| storage.size | string | 1x.extra-small | Size defines one of the supported Loki deployment scale out sizes. Can be either:   - 1x.demo   - 1x.extra-small (Default)   - 1x.small   - 1x.medium |
| storageclassname | string | gp3-csi | Storage class name defines the storage class for ingester/querier PVCs. |
| syncwave | int | 3 | Syncwave for the LokiStack object. |

## Example values

```yaml
---
enabled: true

name: logging-loki
namespace: openshift-logging
syncwave: 3

# This is for log streams only, not the retention of the object store
global_retention_days: 4

# storage settings
storage:

  # Size defines one of the support Loki deployment scale out sizes.
  # Can be either:
  #   - 1x.extra-small (Default)
  #   - 1x.small
  #   - 1x.medium
  # size: 1x.extra-small

  # Secret for object storage authentication. Name of a secret in the same namespace as the LokiStack custom resource.
  secret:

    # Name of a secret in the namespace configured for object storage secrets.
    name: logging-loki-s3

    # Type of object storage that should be used
    # Can bei either:
    #  - swift
    #  - azure
    #  - s3 (default)
    #  - alibabacloud
    #  - gcs
    # type: s3

  # Schemas for reading and writing logs.
  # schemas:
  #  # Version for writing and reading logs.
  #  # Can be v11 or v12
  #  #
  #  # Default: v12
  #  - version: v12
  #    # EffectiveDate is the date in UTC that the schema will be applied on. To ensure readibility of logs, this date should be before the current date in UTC.
  #    # Default: 2022-06-01
  #    effectiveDate: "2022-06-01"

# Storage class name defines the storage class for ingester/querier PVCs.
storageclassname: thin-csi

# Mode defines the mode in which lokistack-gateway component will be configured.
# Can be either:
#   - static (default)
#   - dynamic
#   - openshift-logging
#   - openshift-network
mode: openshift-logging

# Control pod placement for LokiStack components
podPlacements:
  compactor:
    tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
      - effect: NoExecute
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
  distributor:
    tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
      - effect: NoExecute
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
  gateway:
    tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
      - effect: NoExecute
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
  indexGateway:
    tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
      - effect: NoExecute
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
  ingester:
    tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
      - effect: NoExecute
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
  querier:
    tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
      - effect: NoExecute
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
  queryFrontend:
    tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
      - effect: NoExecute
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
  ruler:
    tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
      - effect: NoExecute
        key: node-role.kubernetes.io/infra
        operator: Equal
        value: reserved
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
