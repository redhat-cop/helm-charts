

# helper-operator

  [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

  ![Version: 1.0.26](https://img.shields.io/badge/Version-1.0.26-informational?style=flat-square)



  ## Description

  A helper Chart to reduce code repetition. This Chart should be called as a dependency by other charts in order to install Operators.

This chart can be used to install Operators in OpenShift.
It is best used with a GitOps approach such as Argo CD does. For example: https://github.com/tjungbauer/openshift-clusterconfig-gitops

This chart will create the objects: Namespace, Subscription, OperatorGroup and a Job, that will enable additional console plugins, if enabled.

*NOTE*: It is usually used as Subchart for other Charts and it works best with the second subchart [helper-status-checker](https://github.com/tjungbauer/helm-charts/tree/main/charts/helper-status-checker)

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| tjungbauer | <tjungbau@redhat.com> | <https://blog.stderr.at/> |

## Sources
Source:

Source code: https://github.com/redhat-cop/helm-charts

## Parameters

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| console_plugins | object | "" | Configure console plugins for OpenShift. |
| console_plugins.enabled | bool | false | Enable console plugin configuration. |
| console_plugins.job_namespace | string | openshift-gitops | Optional: Namespace where kubernetes job shall be executed. |
| console_plugins.job_service_account | string | enable-console-plugin-sa | Optional: Name of the service account that will execute the Job. |
| console_plugins.job_service_account_crb | string | enable-console-plugin-crb | Optional: Name of the ClusterRoleBinding. |
| console_plugins.job_service_account_role | string | enable-console-plugin-role | Optional: Name of the role that will be assigned to the service account. |
| console_plugins.plugins | list | empty | List of console plugins to configure. Each list item will be added to the OpenShift UI. |
| console_plugins.syncwave | int | 5 | Optional: Syncwave for console plugin configuration. |
| operators | object | "" | Define operators that you want to deploy. A key/value setup is used here. Each new operator is a new key (in this example "my-operator") |
| operators.my-operator.enabled | bool | false | Enabled yes/no |
| operators.my-operator.namespace.create | bool | false | Create the Namespace yes/no. |
| operators.my-operator.namespace.descr | string | "" | Description of the namespace. |
| operators.my-operator.namespace.displayname | string | "" | Displayname of the namespace. |
| operators.my-operator.namespace.name | string | `"openshift-operators-redhat"` | The Namespace the Operator should be installed in. |
| operators.my-operator.operatorgroup.create | bool | false | Create an Operatorgroup object |
| operators.my-operator.operatorgroup.notownnamespace | bool | false | Monitor own Namespace. For some Operators no `targetNamespaces` must be defined |
| operators.my-operator.subscription | object | "" | Definition of the Operator Subscription |
| operators.my-operator.subscription.approval | string | Automatic | Update behavior of the Operator. Manual/Automatic |
| operators.my-operator.subscription.channel | string | stable | Channel of the Subscription |
| operators.my-operator.subscription.config | object | "" | Optional additional configuration for the Operator subscription. |
| operators.my-operator.subscription.config.env | list | "" | Additional environment parameter, as a list: name/value |
| operators.my-operator.subscription.config.nodeSelector | object | "" | Optionally define a nodeSelector. |
| operators.my-operator.subscription.config.resources | object | "" | Optionally set resources (limits/requests) for the Operator. |
| operators.my-operator.subscription.config.tolerations | list | "" | Optionally set Tolerations for the Subscription. |
| operators.my-operator.subscription.operatorName | string | "empty" | Name of the Operator |
| operators.my-operator.subscription.source | string | redhat-operators | Source of the Operator |
| operators.my-operator.subscription.sourceNamespace | string | openshift-marketplace | Namespace of the source |
| operators.my-operator.syncwave | int | 0 | Syncwave for the operator deployment |

## Example

Installing the Operator "Loki"

TIP: Fetch the values for the subscription specification with `oc get packagemanifest advanced-cluster-management -o yaml`

```yaml
---
console_plugins:
  enabled: false
  syncwave: 5
  plugins:
    - plugin_name

  job_namespace: kube-system

operators:
  loki-operator:
    enabled: false
    namespace:
      name: openshift-operators-redhat
      create: true
    subscription:
      channel: stable
      approval: Automatic
      operatorName: loki-operator
      source: redhat-operators
      sourceNamespace: openshift-marketplace
      config:
        env:
          - name: FIRST_ENV_PARAMENTER
            value: ThisIsRequierd
          - name: SECOND_ENV_PARAMETER
            value: 'true'
        resources:
          limits:
            cpu: 100m
            memory: 1Gi
          requests:
            cpu: 400m
            memory: 300Mi
        tolerations:
          - effect: NoSchedule
            key: node-role.kubernetes.io/infra
            value: reserved
          - effect: NoExecute
            key: node-role.kubernetes.io/infra
            value: reserved
        nodeSelector:
          key: node-role.kubernetes.io/infra
          value: ""
    operatorgroup:
      create: true
      notownnamespace: true
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
