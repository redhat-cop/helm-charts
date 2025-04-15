

# file-integrity-operator

  [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

  ![Version: 1.0.11](https://img.shields.io/badge/Version-1.0.11-informational?style=flat-square)

 

  ## Description

  Setup the FileIntegrity Operator (based on AIDE)

This Helm Chart is installing and configuring the File Integrity Operator, which uses AIDE to check if any files have been changed
on the operating system.

## Dependencies

This chart has the following dependencies:

| Repository | Name | Version |
|------------|------|---------|
| https://redhat-cop.github.io/helm-charts | tpl | ~1.0.0 |

It is best used with a full GitOps approach such as Argo CD does. For example, https://github.com/tjungbauer/openshift-clusterconfig-gitops (for example in the folder clusters/management-cluster/setup-file-integrity-operator)

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| tjungbauer | <tjungbau@redhat.com> | <https://blog.stderr.at/> |

## Sources
Source:

Source code: https://redhat-cop.github.io/helm-charts/tree/main/charts/file-integrity-operator

## Parameters

Verify the subcharts for additional settings:

* [helper-operator](https://github.com/tjungbauer/helm-charts/tree/main/charts/helper-operator)
* [helper-status-checker](https://github.com/tjungbauer/helm-charts/tree/main/charts/helper-operator)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aide.controlplane.config | object | `{"customconfig":{"enabled":true,"key":"controlplane-aide.conf","name":"controlplane-aide-conf","namespace":"openshift-file-integrity"},"gracePeriod":900,"maxBackups":5}` | FileIntegrity configuration |
| aide.controlplane.config.customconfig | object | `{"enabled":true,"key":"controlplane-aide.conf","name":"controlplane-aide-conf","namespace":"openshift-file-integrity"}` | Enable a custom configuration. This is usefull for control planes. If not defined a configuration will be created. |
| aide.controlplane.config.customconfig.enabled | bool | false | Enable custom configuration |
| aide.controlplane.config.customconfig.key | string | `"controlplane-aide.conf"` | The key that contains the actual AIDE configuration in a configmap specified by Name and Namespace. Defaults to aide.conf |
| aide.controlplane.config.customconfig.namespace | string | `"openshift-file-integrity"` | Namespace of a configMap that contains custom AIDE configuration. A default configuration would be created if omitted. |
| aide.controlplane.config.gracePeriod | int | 900 | Time between individual aide scans |
| aide.controlplane.config.maxBackups | int | 5 | The maximum number of AIDE database and log backups (leftover from the re-init process) to keep on a node. Older backups beyond this number are automatically pruned by the daemon. |
| aide.controlplane.enabled | bool | false | Enable worker node fileintegrity check |
| aide.controlplane.name | string | `"controlplane-fileintegrity"` | Name of this object |
| aide.controlplane.namespace | string | `"openshift-file-integrity"` | Namespace, typically openshift-file-integrity |
| aide.controlplane.selector | object | `{"key":"node-role.kubernetes.io/master","value":""}` | nodeSelector as key/value |
| aide.controlplane.syncwave | int | `10` | Syncwave when this object is created |
| aide.controlplane.tolerations | list | empty | If you want this component to only run on specific nodes, you can configure tolerations of tainted nodes. |
| aide.worker.config | object | `{"customconfig":{"enabled":false},"gracePeriod":900,"maxBackups":5}` | FileIntegrity configuration |
| aide.worker.config.customconfig | object | `{"enabled":false}` | Enable a custom configuration. This is usefull for control planes. If not defined a configuration will be created. |
| aide.worker.config.customconfig.enabled | bool | false | Enable custom configuration |
| aide.worker.config.gracePeriod | int | 900 | Time between individual aide scans |
| aide.worker.config.maxBackups | int | 5 | The maximum number of AIDE database and log backups (leftover from the re-init process) to keep on a node. Older backups beyond this number are automatically pruned by the daemon. |
| aide.worker.enabled | bool | false | Enable worker node fileintegrity check |
| aide.worker.name | string | `"worker-fileintegrity"` | Name of this object |
| aide.worker.namespace | string | `"openshift-file-integrity"` | Namespace, typically openshift-file-integrity |
| aide.worker.nodeSelector.key | string | `"node-role.kubernetes.io/worker"` |  |
| aide.worker.nodeSelector.value | string | `""` |  |
| aide.worker.selector | object | `{"key":"node-role.kubernetes.io/worker","value":""}` | nodeSelector as key/value |
| aide.worker.syncwave | int | `5` | Syncwave when this object is created |
| aide.worker.tolerations | list | empty | If you want this component to only run on specific nodes, you can configure tolerations of tainted nodes. |

## Example values

```yaml
---
# Deploy operator using helper-operator sub chart
helper-operator:
  operators:
    quay-operator:
      enabled: false
      syncwave: '0'
      namespace:
        name: openshift-file-integrity
        create: true
      subscription:
        channel: stable
        approval: Automatic
        operatorName: file-integrity-operator
        source: redhat-operators
        sourceNamespace: openshift-marketplace
      operatorgroup:
        create: true
        notownnamespace: true

# Verify if operator has been deployed using helper-status-checker sub-chart
helper-status-checker:
  enabled: false

  checks:

    - operatorName: file-integrity-operator
      namespace:
        name: openshift-file-integrity
      syncwave: 3

      serviceAccount:
        name: "sa-file-integrity-checker"

aide:
  worker:
    enabled: true
    syncwave: 5
    name: worker-fileintegrity
    namespace: openshift-file-integrity
    selector:
      key: node-role.kubernetes.io/worker
      value: ""

    config:
      gracePeriod: 900
      maxBackups: 5

  controlplane:
    enabled: false
    syncwave: 10
    name: controlplane-fileintegrity
    namespace: openshift-file-integrity
    selector:
      key: node-role.kubernetes.io/master
      value: ""

    config:
      gracePeriod: 900
      maxBackups: 5

      customconfig:
        enabled: true
        name: controlplane-aide-conf
        namespace: openshift-file-integrity
        key: "controlplane-aide.conf"

    tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/master
        operator: Exists
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
