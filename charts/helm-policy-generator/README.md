

# helm-policy-generator

  [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

  ![Version: 1.0.14](https://img.shields.io/badge/Version-1.0.14-informational?style=flat-square)

 

  ## Description

  This Chart shall help to generate policies for Advanced Cluster Management

This very specialised Helm Chart enabled you to create Policy definitions for Advanced Cluster Security.
It can use PolicySets (if defined) and will render the one or multiple Policy objects.
Currently, *ConfigurationPolicy* and *CertificationPolicy* are supported.

Since the actual definition of ConfigurationPolicies can be quite complex, the idea was to configure the policy as usual with the values-file,
but store the actual yaml object the policy is touching in a sub-folder.

For example, in the folder console-banner, you will find the *console-banner.yaml*
This yaml defines the actual settings the ACM-Policy will try to set, including possible placeholders.

For example:

```yaml
apiVersion: console.openshift.io/v1
kind: ConsoleNotification
metadata:
  name: consolebanner
spec:
  backgroundColor: "#CCCCCC"
  color: "#000000"
  link:
    href: >-
      https://console.redhat.com/openshift/details/{{fromClusterClaim "id.openshift.io" }}
    text: RedHat Console
  location: BannerTop
  text: >-
    Name: {{ fromClusterClaim "name" name }}, Version: {{fromClusterClaim "version.openshift.io" }}
```

This yaml will be integrated into the policy and will configure a banner for the OpenShift console.

Other examples can be found in the folder *console-links* and *examples*. The `examples` folder also contains a values-cluster-health-checks.yaml so you can compare how to configure cluster health checks.

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
* <https://github.com/tjungbauer/helm-charts>
* <https://charts.stderr.at/>
* <https://github.com/tjungbauer/openshift-clusterconfig-gitops>

Source code: https://redhat-cop.github.io/helm-charts/tree/main/charts/helm-policy-generator

## Parameters

*TIP*: Verify the values.yaml to see possible additional settings.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| create_policy_namespace | bool | false | Create Namespace for the policy Yes/No |
| namespace | string | `"policy-hub"` |  |
| policies[0] | object | `{"categories":["CM Configuration Management"],"controls":["CM Console Customizations"],"dependencies":[{"apiVersion":"policy.open-cluster-management.io/v1","compliance":"Compliant","kind":"Policy","name":"","namespace":""}],"description":"","disabled":"false","enabled":true,"ignorePending":false,"namespace":"policy-hub","placement":{"clusterSets":["hub"],"lableSelectors":[{"key":"name","operator":"In","values":["local-cluster"]}]},"policy_templates":[{"allowedSANPattern":"","complianceType":"musthave","disallowedSANPattern":"","evaluationInterval":{"compliant":"45m","noncompliant":"45s"},"extraDependencies":[{"apiVersion":"policy.open-cluster-management.io/v1","compliance":"Compliant","kind":"Policy","name":"","namespace":""}],"kind":"ConfigurationPolicy","maximumCADuration":"100h","maximumDuration":"100h","minimumCADuration":"400h","minimumDuration":"100h","name":"console-banner","name_use_template_filename":"true","namespaceSelector":{"exclude":[],"include":[],"matchExpressions":[{"key":"name","operator":"In","values":["local-cluster"]}],"matchLabels":{"component":"redis","env":"test"}},"path":"console-banner","pruneObjectBehavior":"DeleteIfCreated","remediationAction":"enforce","severity":"low"}],"policyname":"console-banner","remediationAction":"inform","standards":["Baseline 2023v1"]}` | The name for identifying the policy resource. |
| policies[0].categories | list | empty | A security control category represent specific requirements for one or more standards. For example, a System and Information Integrity category might indicate that your policy contains a data transfer protocol to protect personal information, as required by the HIPAA and PCI standards. This is used only when policyDefaults.catagories is not set. |
| policies[0].controls | list | empty | The name of the security control that is being checked. For example, Access Control or System and Information Integrity. This is used only when policyDefaults.catagories is not set. |
| policies[0].dependencies | list | `[{"apiVersion":"policy.open-cluster-management.io/v1","compliance":"Compliant","kind":"Policy","name":"","namespace":""}]` | Dependencies are used to create a list of dependency objects detailed with extra considerations for compliance. |
| policies[0].description | string | empty | Local description of the policy. Simply adds an annotation. This is only set when policyDefaults.desciption is NOT set. |
| policies[0].disabled | string | true | The disabled parameter provides the ability to enable and disable your policies in the context of ACM.  Set the value to true or false explicitly set the value to false to activate the policy |
| policies[0].enabled | bool | false | Enable this policy in this Chart or not. |
| policies[0].ignorePending | bool | empty | Used to mark a policy template as compliant until the dependency criteria is verified. Values:   - true   - false |
| policies[0].namespace | string | `"policy-hub"` | Namespace of the policy. This namespace must exist! |
| policies[0].placement | object | empty | Places a policy to a cluster with selected labels and or clusterSet This is used when the PolicySet does NOT define a placement |
| policies[0].placement.clusterSets | list | empty | A clusterSet the policy to bind to. The clusterSet must exist. Optional |
| policies[0].placement.lableSelectors | list | empty | Required cluster selectors Selects a cluster based on its labels. For example: name euqals to "local-cluster" multiple selectors can be defined, which must all be true |
| policies[0].policy_templates[0].allowedSANPattern | string | `""` | Only if CertificatePolicy! A regular expression that must match every SAN entry that you have defined in your certificates. This parameter checks DNS names against patterns.  Optional |
| policies[0].policy_templates[0].complianceType | string | musthave | Used to define the desired state of the Kubernetes object on the managed clusters. You must use one of the following verbs as the parameter value: mustonlyhave: Indicates that an object must exist with the exact fields and values as               defined in the objectDefinition. musthave: Indicates an object must exist with the same fields as specified in the objectDefinition.           Any existing fields on the object that are not specified in the object-template           are ignored. In general, array values are appended. The exception for the array to be           patched is when the item contains a name key with a value that matches an existing item. Use a           fully defined objectDefinition using the mustonlyhave compliance type, if you want to           replace the array. mustnothave: Indicates that an object with the same fields as specified in the objectDefinition              cannot exist. |
| policies[0].policy_templates[0].disallowedSANPattern | string | `""` | Only if CertificatePolicy! A regular expression that must not match any SAN entries you have defined in your certificates. This parameter checks DNS names against patterns. Note: To detect wild-card certificate, use the following SAN pattern:    disallowedSANPattern: "[\\*]"  Optional |
| policies[0].policy_templates[0].evaluationInterval | object | `{"compliant":"45m","noncompliant":"45s"}` | Used to define how often the policy is evaluated when it is in the compliant state. The values must be in the format of a duration which is a sequence of numbers with time unit suffixes. For example, 12h30m5s represents 12 hours, 30 minutes, and 5 seconds. It can also be set to never so that the policy is not reevaluated on the compliant cluster, unless the policy spec is updated. By default, the minimum time between evaluations for configuration policies is approximately 10 seconds. (This can be longer if the configuration policy controller is saturated on the managed cluster.) Optional |
| policies[0].policy_templates[0].extraDependencies | list | `[{"apiVersion":"policy.open-cluster-management.io/v1","compliance":"Compliant","kind":"Policy","name":"","namespace":""}]` | For policy templates, this is used to create a list of dependency objects detailed with extra considerations for compliance. |
| policies[0].policy_templates[0].extraDependencies[0] | object | `{"apiVersion":"policy.open-cluster-management.io/v1","compliance":"Compliant","kind":"Policy","name":"","namespace":""}` | The name of the object being depended on. |
| policies[0].policy_templates[0].extraDependencies[0].apiVersion | string | `"policy.open-cluster-management.io/v1"` | The API version of the object. The default value is policy.opencluster-management.io/v1 |
| policies[0].policy_templates[0].extraDependencies[0].compliance | string | `"Compliant"` | The compliance state the object needs to be in. The default value is Compliant. |
| policies[0].policy_templates[0].extraDependencies[0].kind | string | `"Policy"` | The kind of the object. By default, the kind is set to Policy, but can also be other kinds that have compliance state, such as ConfigurationPolicy. |
| policies[0].policy_templates[0].extraDependencies[0].namespace | string | `""` | The namespace of the object being depended on. The default is the namespace of policies set for the Policy Generator. |
| policies[0].policy_templates[0].kind | string | ConfigurationPolicy | Optional: only required when CertificatePolicy shall be defined Currently two are defined: ConfigurationPolicy and CertificationPolicy |
| policies[0].policy_templates[0].maximumCADuration | string | `"100h"` | Only if CertificatePolicy! Set a value to identify signing certificates that have been created with a duration that exceeds your defined limit.  Optional |
| policies[0].policy_templates[0].maximumDuration | string | `"100h"` | Only if CertificatePolicy! Set a value to identify certificates that have been created with a duration that exceeds your desired limit.  Optional |
| policies[0].policy_templates[0].minimumCADuration | string | `"400h"` | Only if CertificatePolicy! Set a value to identify signing certificates that might expire soon with a different value from other certificates. If the parameter value is not specified, the CA certificate expiration is the value used for the minimumDuration.  Optional |
| policies[0].policy_templates[0].minimumDuration | string | 100h | Only if CertificatePolicy! When a value is not specified, the default value is 100h. This parameter specifies the smallest duration (in hours) before a certificate is considered noncompliant.  Required |
| policies[0].policy_templates[0].name_use_template_filename | string | `"true"` | In case multiple policy_templates are used, you can either use the "randomizer" do set unique names, or use the name of the file where the policy_template is defined. For example: file/myfile.yaml would name the policy_template as "myfile" Optional @efault -- empty |
| policies[0].policy_templates[0].namespaceSelector | object | `{"exclude":[],"include":[],"matchExpressions":[{"key":"name","operator":"In","values":["local-cluster"]}],"matchLabels":{"component":"redis","env":"test"}}` | Determines the list of namespaces to check on the cluster for the given manifest. If a namespace is specified in the manifest, the selector is not necessary. This defaults to no selectors. |
| policies[0].policy_templates[0].path | string | `"console-banner"` | Path the Kubernetes objects in yaml format. (They must be fully defined) Here the policy object in yaml format is found. |
| policies[0].policy_templates[0].pruneObjectBehavior | string | None | Determines whether to clean up resources related to the policy when the policy is removed from a managed cluster.  Values:    - DeleteIfCreated: Cleans up any resources created by the policy.    - DeleteAll: Cleans up all resources managed by the policy.    - None: This is the default value and maintains the same behavior            from previous releases, where no related resources are deleted. |
| policies[0].policy_templates[0].remediationAction | string | inform | Specifies the action to take when the policy is non-compliant. Use the following parameter values:   - inform   - InformOnly   - enforce  Important: the policy-template.spec.remediationAction is overridden by the preceding parameter value for spec.remediationAction (if defined)  |
| policies[0].policy_templates[0].severity | string | `"low"` | Specifies the severity when the policy is non-compliant. Use the following parameter values: low, medium, high, or critical.  @efault -- low |
| policies[0].remediationAction | string | `"inform"` | Specifies the remediation of your policy. The possible parameter values are enforce and inform. If specified, the spec.remediationAction value overrides any remediationAction parameter defined in the child policies in the policy-templates section. For example, if the spec.remediationAction value is set to enforce, then the remediationAction in the policy-templates section is set to enforce during runtime. Important: Some policy kinds might not support the enforce feature.  Optional Values:   - inform   - enforce |
| policies[0].standards | list | empty | The name or names of security standards the policy is related to. For example, National Institute of Standards and Technology (NIST) and Payment Card Industry (PCI). This is used only when policyDefaults.catagories is not set. |
| policyDefaults | object | `{"categories":["CM Configuration Management"],"controls":["CM Console Customizations"],"description":"Console Customizations","globalRemediationAction":"inform","standards":["Baseline 2023v1"]}` | Default annotation settings. These will overwrite the individual settings in the Policy and are used by all policies that are defined here. |
| policyDefaults.categories | list | empty | A security control category represent specific requirements for one or more standards. For example, a System and Information Integrity category might indicate that your policy contains a data transfer protocol to protect personal information, as required by the HIPAA and PCI standards.  Optional |
| policyDefaults.controls | list | empty | A security control category represent specific requirements for one or more standards. For example, a System and Information Integrity category might indicate that your policy contains a data transfer protocol to protect personal information, as required by the HIPAA and PCI standards.  Optional |
| policyDefaults.description | string | empty | Description of the policy. Simply adds an annotation.  Optional |
| policyDefaults.globalRemediationAction | string | `"inform"` | Specifies the remediation of your policy. Must either be set here or inside the policy. Overrides other remediationAction settings!!  Optional The parameter values are:   - inform   - enforce |
| policyDefaults.standards | list | empty | The name or names of security standards the policy is related to. For example, National Institute of Standards and Technology (NIST) and Payment Card Industry (PCI).  Optional |
| policySet.enabled | bool | false | Enable of disable policySets. If disabled, the PlaceMentBinding will use the name of the policy |
| policySet.sets[0] | object | `{"description":"Contains console customizations","name":"console-customizations","namespace":"policy-hub","placement":{"clusterSets":["hub"],"lableSelectors":[{"key":"name","operator":"In","values":["local-cluster"]}]},"policies":["console-banner"]}` | The name for identifying the policySet resource. |
| policySet.sets[0].description | string | `"Contains console customizations"` | The descrption for identifying the policySet resource. |
| policySet.sets[0].namespace | string | `"policy-hub"` | The namespace of policySet resource. |
| policySet.sets[0].placement | object | `{"clusterSets":["hub"],"lableSelectors":[{"key":"name","operator":"In","values":["local-cluster"]}]}` | Places a policySET to a cluster with selected labels and or clusterSet |
| policySet.sets[0].placement.clusterSets | list | N/A | a clusterSet the policy to bind to. The clusterSet must exist. Optional |
| policySet.sets[0].placement.lableSelectors | list | `[{"key":"name","operator":"In","values":["local-cluster"]}]` | multiple selectors can be defined, which must all be true |
| policySet.sets[0].policies | list | empty | The list of policies that you want to group together in the policy set. If defined, it will take the list. If Not defined it will automatically take the names of the policies defined below. |

## Example values

```yaml
---
namespace: &namespace policy-hub
create_policy_namespace: true

policyDefaults:
    categories:
      - CM Configuration Management
    controls:
      - CM Console Customizations
    standards:
      - Baseline 2023v1
    description: "Console Customizations"

    globalRemediationAction: inform

policySet:
  enabled: true

  # Define PolicySets
  sets:
    - name: console-customizations
      description: "Contains console customizations"
      namespace: *namespace

      policies:
        - console-banner
      placement:
        lableSelectors:
          - key: name
            operator: In
            values:
              - local-cluster

policies:
  - policyname: console-banner
    enabled: true
    namespace: *namespace
    disabled: 'false'
    remediationAction: inform

    policy_templates:
      - name: console-banner
        name_use_template_filename: "true"
        remediationAction: enforce
        complianceType: musthave
        severity: low
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
