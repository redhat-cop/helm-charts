

# openshift-logging

  [![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/openshift-bootstraps)](https://artifacthub.io/packages/search?repo=openshift-bootstraps)
  [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
  [![Lint and Test Charts](https://github.com/tjungbauer/helm-charts/actions/workflows/lint_and_test_charts.yml/badge.svg)](https://github.com/tjungbauer/helm-charts/actions/workflows/lint_and_test_charts.yml)
  [![Release Charts](https://github.com/tjungbauer/helm-charts/actions/workflows/release.yml/badge.svg)](https://github.com/tjungbauer/helm-charts/actions/workflows/release.yml)

  ![Version: 2.0.5](https://img.shields.io/badge/Version-2.0.5-informational?style=flat-square)

 

  ## Description

  Deploy and configure OpenShift Logging based on LokiStack

This Helm Chart is installing and configuring OpenShift Logging

**NOTE**: OpenShift Logging using EFK stack (Elasticsearch, Kibana and Fluentd) is considered as deprecated and has been removed from this Chart. Instead, LokiStack with Vector
should be used.

**NOTE**: ClusterLogForwarder is currently not configured with this Chart. This can be set using in the GitOps Chart/Kustomize that is using this chart as a dependency.

## Dependencies

This chart has the following dependencies:

| Repository | Name | Version |
|------------|------|---------|
| https://charts.stderr.at/ | tpl | ~1.0.0 |

It is best used with a full GitOps approach such as Argo CD does. For example, https://github.com/tjungbauer/openshift-clusterconfig-gitops (for example in the folder clusters/management-cluster/setup-openshift-logging)

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| tjungbauer | <tjungbau@redhat.com> | <https://blog.stderr.at/> |

## Sources
Source:
* <https://github.com/tjungbauer/helm-charts>
* <https://charts.stderr.at/>
* <https://github.com/tjungbauer/openshift-clusterconfig-gitops>

Source code: https://github.com/tjungbauer/helm-charts/tree/main/charts/openshift-logging

## Parameters

Verify the subcharts for additional settings:

* [helper-operator](https://github.com/tjungbauer/helm-charts/tree/main/charts/helper-operator)
* [helper-status-checker](https://github.com/tjungbauer/helm-charts/tree/main/charts/helper-operator)
* [helper-lokistack](https://github.com/tjungbauer/helm-charts/tree/main/charts/helper-lokistack)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| loggingConfig.enabled | bool | false | Enable openshift logging configuration |
| loggingConfig.logStore.collection.resources | object | N/A | The resource requirements for the collector. Set this only when you know what you are doing |
| loggingConfig.logStore.collection.resources.limits | object | N/A | LIMITS for CPU, memory and storage |
| loggingConfig.logStore.collection.resources.requests | object | N/A | REQUESTS for CPU, memory and storage |
| loggingConfig.logStore.collection.tolerations | list | N/A | Define the tolerations the collector Pods will accept |
| loggingConfig.logStore.collection.type | string | vector | The type of Log Collection to configure Vector in case of Loki. |
| loggingConfig.logStore.lokistack | string | logging-loki | Name of the LokiStack resource. |
| loggingConfig.logStore.type | string | `"lokistack"` | The Type of Log Storage to configure. The operator currently supports either using ElasticSearch managed by elasticsearch-operator or Loki managed by loki-operator (LokiStack) as a default log store. However, Elasticsearch is deprecated and should not be used here ... it would result in an error |
| loggingConfig.logStore.visualization.ocpConsole.logsLimit | int | none | LogsLimit is the max number of entries returned for a query. |
| loggingConfig.logStore.visualization.ocpConsole.timeout | string | none | Timeout is the max duration before a query timeout |
| loggingConfig.logStore.visualization.tolerations | list | N/A | Define the tolerations the visualisation Pod will accept |
| loggingConfig.logStore.visualization.type | string | ocp-console | The type of Visualization to configure Could be either Kibana (deprecated) or ocp-console |
| loggingConfig.managementState | string | Managed | Indicator if the resource is 'Managed' or 'Unmanaged' by the operator |
| loggingConfig.syncwave | string | 4 | Syncwave for the ClusterLogging resource |

## Example values

```yaml
---
loggingConfig:
  enabled: true

  logStore:
    type: lokistack
    lokistack: logging-loki

    visualization:
      type: ocp-console   

    collection:
      type: vector
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release tjungbauer/<chart-name>>
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
