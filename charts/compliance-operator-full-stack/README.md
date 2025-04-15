

# compliance-operator-full-stack

  [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

  ![Version: 1.0.30](https://img.shields.io/badge/Version-1.0.30-informational?style=flat-square)

 

  ## Description

  Master chart to deploy and configure the Compliance Operator

This Helm Chart is installing and configuring the Compliance operator, using the following workflow:

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

Source code: https://redhat-cop.github.io/helm-charts/tree/main/charts/compliance-operator-full-stack

## Parameters

:bulb: **TIP**: See README files of sub Charts for additional possible settings: [helper-operator](https://github.com/tjungbauer/helm-charts/tree/main/charts/helper-operator) and [helper-status-checker](https://github.com/tjungbauer/helm-charts/tree/main/charts/helper-operator).

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| compliance.namespace | object | `{"name":"openshift-compliance"}` | Settings for namespace where compliance operator will be installed. |
| compliance.namespace.name | string | `"openshift-compliance"` | Namespace of the operator |
| compliance.scansettingbinding | object | `{"enabled":false,"profiles":[{"kind":"Profile","name":"ocp4-cis-node"},{"kind":"Profile","name":"ocp4-cis"}],"scansetting":"default","syncwave":"3","tailored":{"enabled":false,"modified_profiles":[{"description":"Modified ocp4-cis profile","disableRule":[{"name":"ocp4-scc-limit-container-allowed-capabilities","rationale":"Disabling CIS-OCP 5.2.8 that will always be triggered as long nutanix-csi does not provide SCC configuration"}],"extends":"ocp4-cis","name":"tailoredprofile-ocp4-cis","title":"Tailored Profile of ocp4-cis"}]}}` | Settings for the ScanSettings Here ScanSettingBinding and TailoredProfile can be configured |
| compliance.scansettingbinding.enabled | bool | false | Enable ScanSetting cnofiguration |
| compliance.scansettingbinding.profiles | list | `[{"kind":"Profile","name":"ocp4-cis-node"},{"kind":"Profile","name":"ocp4-cis"}]` | A list of Profiles that shall be used for scanning |
| compliance.scansettingbinding.profiles[0] | object | `{"kind":"Profile","name":"ocp4-cis-node"}` | The name of the Profile |
| compliance.scansettingbinding.profiles[0].kind | string | `"Profile"` | The kind of the profile. This can either be Profile or TailoredProfile |
| compliance.scansettingbinding.scansetting | string | `"default"` | Use the default ScanSettings that a provided by the Operator. |
| compliance.scansettingbinding.syncwave | string | `"3"` | Syncwave for the ScanSetting |
| compliance.scansettingbinding.tailored | object | `{"enabled":false,"modified_profiles":[{"description":"Modified ocp4-cis profile","disableRule":[{"name":"ocp4-scc-limit-container-allowed-capabilities","rationale":"Disabling CIS-OCP 5.2.8 that will always be triggered as long nutanix-csi does not provide SCC configuration"}],"extends":"ocp4-cis","name":"tailoredprofile-ocp4-cis","title":"Tailored Profile of ocp4-cis"}]}` | Example of a TailoredProfile With TailoredProfiles you can disable specific checks |
| compliance.scansettingbinding.tailored.enabled | bool | false | Enable TailoredProfile |
| compliance.scansettingbinding.tailored.modified_profiles[0] | object | `{"description":"Modified ocp4-cis profile","disableRule":[{"name":"ocp4-scc-limit-container-allowed-capabilities","rationale":"Disabling CIS-OCP 5.2.8 that will always be triggered as long nutanix-csi does not provide SCC configuration"}],"extends":"ocp4-cis","name":"tailoredprofile-ocp4-cis","title":"Tailored Profile of ocp4-cis"}` | Name of the TailoredProfile |
| compliance.scansettingbinding.tailored.modified_profiles[0].description | string | `"Modified ocp4-cis profile"` | Description of the Profile |
| compliance.scansettingbinding.tailored.modified_profiles[0].disableRule | list | `[{"name":"ocp4-scc-limit-container-allowed-capabilities","rationale":"Disabling CIS-OCP 5.2.8 that will always be triggered as long nutanix-csi does not provide SCC configuration"}]` | A list of rules that might be disabled. |
| compliance.scansettingbinding.tailored.modified_profiles[0].disableRule[0] | object | `{"name":"ocp4-scc-limit-container-allowed-capabilities","rationale":"Disabling CIS-OCP 5.2.8 that will always be triggered as long nutanix-csi does not provide SCC configuration"}` | Name of the rule that shall be disabled |
| compliance.scansettingbinding.tailored.modified_profiles[0].disableRule[0].rationale | string | `"Disabling CIS-OCP 5.2.8 that will always be triggered as long nutanix-csi does not provide SCC configuration"` | A Reason why this rule is excluded. |
| compliance.scansettingbinding.tailored.modified_profiles[0].extends | string | `"ocp4-cis"` | Which Profile is extended here. Here we are using ocp4-cis as basis. This Profile must exist. |
| compliance.scansettingbinding.tailored.modified_profiles[0].title | string | `"Tailored Profile of ocp4-cis"` | Title of the profile (visible in the reports) |
| helper-operator.operators.compliance-operator.enabled | bool | false | Enabled yes/no |
| helper-operator.operators.compliance-operator.namespace.create | bool | "" | Description of the namespace. |
| helper-operator.operators.compliance-operator.namespace.name | string | `"openshift-compliance"` | The Namespace the Operator should be installed in. The compliance operator should be deployed into **openshift-compliance** Namepsace that must be created. |
| helper-operator.operators.compliance-operator.operatorgroup.create | bool | false | Create an Operatorgroup object |
| helper-operator.operators.compliance-operator.operatorgroup.notownnamespace | bool | false | Monitor own Namespace. For some Operators no `targetNamespaces` must be defined |
| helper-operator.operators.compliance-operator.subscription.approval | string | Automatic | Update behavior of the Operator. Manual/Automatic |
| helper-operator.operators.compliance-operator.subscription.channel | string | stable | Channel of the Subscription |
| helper-operator.operators.compliance-operator.subscription.operatorName | string | "empty" | Name of the Operator The name for the compliance operator is **compliance-operator** |
| helper-operator.operators.compliance-operator.subscription.source | string | redhat-operators | Source of the Operator |
| helper-operator.operators.compliance-operator.subscription.sourceNamespace | string | openshift-marketplace | Namespace of the source |
| helper-operator.operators.compliance-operator.syncwave | string | 0 | Syncwave for the operator deployment |
| helper-status-checker.checks[0] | object | "" | Define the name of the operator that shall be verified. Use the value of the currentCSV (packagemanifest) but WITHOUT the version !! For the compliance operator the name should be "**compliance-operator**" |
| helper-status-checker.checks[0].namespace | object | "" | Define where the operator is installed For the compliance operator this should be "**openshift-compliance**" |
| helper-status-checker.checks[0].serviceAccount | object | `{"name":"sa-compliance"}` | Set the values of the ServiceAccount that will execute the status checker Job. |
| helper-status-checker.enabled | bool | false | Enable status checker |

## Example values

```yaml
---
# Install Operator Compliance Operator
# Deploys Operator --> Subscription and Operatorgroup
# Syncwave: 0
helper-operator:
  operators:
    compliance-operator:
      enabled: true
      syncwave: '0'
      namespace:
        name: openshift-compliance
        create: true
      subscription:
        channel: stable
        approval: Automatic
        operatorName: compliance-operator
        source: redhat-operators
        sourceNamespace: openshift-marketplace
      operatorgroup:
        create: true
        notownnamespace: true

helper-status-checker:
  enabled: true

  # use the value of the currentCSV (packagemanifest) but WITHOUT the version !!
  operatorName: compliance-operator

  # where operator is installed
  namespace:
    name: openshift-compliance

  serviceAccount:
    create: true
    name: "sa-compliance"

compliance:
  namespace:
    name: openshift-compliance
    syncwave: '0'
    descr: 'Red Hat Compliance'
  scansettingbinding:
    enabled: true
    syncwave: '3'

    # Example
    tailored:
      enabled: false
      modified_profiles:
      - name: tailoredprofile-ocp4-cis
        description: Modified ocp4-cis profile
        title: Tailored Profile of ocp4-cis
        extends: ocp4-cis
        disableRule:
        - name: ocp4-scc-limit-container-allowed-capabilities
          rationale: Disabling CIS-OCP 5.2.8 that will always be triggered as long nutanix-csi does not provide SCC configuration

    profiles:
      - name: ocp4-cis-node
        kind: Profile  # Could be Profile or TailedProfile
      - name: ocp4-cis
        kind: Profile
    scansetting: default

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
