

# helper-proj-onboarding

  [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

  ![Version: 1.0.39](https://img.shields.io/badge/Version-1.0.39-informational?style=flat-square)

 

  ## Description

  This Chart shall deploy namespaces and their depending resources, like NetworkPolicies or Quotas etc.

This Helm chart shall help to deploy all resources that are required for a custom workload. This might be a simple Namespace or ResourceQuotas or NetworkPolicies.
The whole process is also described at [Project onboarding using GitOps and Helm](https://www.redhat.com/en/blog/project-onboarding-using-gitops-and-helm) ... I am not copying the whole article here :)

### Use case
The article describes the following use case:

- I have two applications, my-main-app and my-second-app, that should be onboarded onto the cluster.
- my-main-app is using two Namespaces, my-main-app-project-1 and my-main-app-project-2. Maybe Mona uses this for frontend and backend parts of the application.
- Mona is the admin for both applications.
- Peter can only manage my-main-app.
- Mona and Peter request new projects (multiple) for the cluster, which will be prepared by the cluster-admin who will create a new folder and generate a values-file (Helm) for that project and the target cluster.
- The cluster-admin synchronizes the project onboarding application in GitOps, which will create all required objects (Namespace, ResourceQuota, Network Policies, etc.).
- Mona and Peter can then use an application-scoped GitOps instance (a second instance) to deploy their application accordingly using the allowed namespace, repositories, etc. (limited by GitOps RBAC rules).

(You can find all settings and discussions in the article.)

### Resources
This chart has a huge values file and I tried to document all possible settings. To ease the creation of new Tenants it is possible to define so-called T-shirt sizes in a global values file and then
simply refer to that size in your Tenant configuration. Still, you might overwrite certain settings. For example: The size "S" defined a quota of 2 CPUs, still a specific Tenant required 4 CPUs. This can
be overwritten in the tenant-specific values file.

The following resources are currently managed:

- Namespace (including lables)
- ResourceQuotas (limit CPU, Memory etc.)
- LimitRanges
- Create Local Project Admin Group (and binding)
- Default Set of Network Policies (to allow openshift Monitoring, DNS, Ingress etc.)
- Custom Network Policies
- Argo CD RBAC using AppProject resource.

Each Tenant might have one or more Namespaces. Under these Namespaces, all other settings are defined. See the possible variables and examples below.

### values

Two values files are required here:

- **values-global.yaml** Defines global values, currently the Namespace of the application-scoped GitOps instance, T-shirt sizes, a list of environments, etc.
- **values.yaml** Defines the tenant-specifc settings. Here T-shirt sizes (Quotas and LimitRanges) might be overwritten.

Both files exist as examples in this repository.

## Dependencies

This chart has the following dependencies:

| Repository | Name | Version |
|------------|------|---------|
| https://redhat-cop.github.io/helm-charts | tpl | ~1.0.0 |

None

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| tjungbauer | <tjungbau@redhat.com> | <https://blog.stderr.at/> |

## Sources
Source:

Source code: https://redhat-cop.github.io/helm-charts/tree/main/charts/helper-proj-onboarding

## Parameters Tenant individual values file

*TIP*: Verify the values.yaml to see possible additional settings.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| allowed_envs | list | none | Allowed environments that this tenant can use. This list is mandatory to explicitly set the destination clusters. The name here must be equal to the configured environments in the Global-Values **THIS IS FROM CLUSTER POV.** Important: If there is a separate Argo CD instance per cluster, the developers still need access to the management cluster (typically in-cluster), since they need to be able to create Argo CD Applications<br /> **NOTE**: This list will be ignored, if overwrite_allowed_envs is set in the AppProject definition. |
| allowed_oidc_groups | list | dummy-group | Groups that are allowed in RBAC configuration of the AppProject resource of Argo CD. This group can either be created using this Helm Chart (it will be named as <namespace>-admin) or must be known (for example synced via LDAP Group Sync) **NOTE**: if either allowed_oidc_groups nor overwrite_oidc_groups are defined, then a dummy value will be set **NOTE**: This list will be ignored, if overwrite_oidc_groups is set in the AppProject definition. |
| allowed_source_namespace | list | `["my-allows-source-namespace"]` | Administrators can define a list of namespaces where Application or ApplicationSet resources may be created, updated and reconciled in. As of Argo CD 2.10 this is still a BETA feature. <br /> **NOTE**: This list will be ignored, if overwrite_source_namespaces is set in the AppProject definition. |
| allowed_source_repos | list | * | Allowed repositorie for this tenant. This setting might be later overwritten by namespaces.[].argocd_rbac_setup.{}.overwrite_sourceRepos. The allowed source repositories can be defined either (sorted by lowest priority, to highest priority) <ul></li>   <li>allow any repository</li>   <li>global.allowed_source_repos</li>   <li>allowed_source_repos</li>   <li>namespaces.[].argocd_rbac_setup.{}.overwrite_sourceRepos</li> </ul> Note: If nothing is set, then ANY source repository will be allowed. |
| namespaces | list | '' | List of namespaces this tenant shall manage. A tenant or project may consist of multiple namespace |
| namespaces[0] | object | '' | Name of the first Namespace |
| namespaces[0].additional_settings | object | '' | Additional labels for Podsecurity and Monitoring for the Namespace |
| namespaces[0].additional_settings.podsecurity_audit | string | N/A | Pod Security Standards https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted Possible values: Privileged, Baseline, Restricted Privileged: Unrestricted policy, providing the widest possible level of permissions. This policy allows for known privilege escalations. Baseline: Minimally restrictive policy which prevents known privilege escalations. Allows the default (minimally specified) Pod configuration. Restricted: Heavily restricted policy, following current Pod hardening best practices. Policy violations will trigger the addition of an audit annotation to the event recorded in the audit log, but are otherwise allowed. |
| namespaces[0].additional_settings.podsecurity_enforce | string | N/A | Policy violations will cause the pod to be rejected. |
| namespaces[0].additional_settings.podsecurity_warn | string | N/A | Policy violations will trigger a user-facing warning, but are otherwise allowed. |
| namespaces[0].argocd_rbac_setup | object | '' | Creation of Argo CD Project |
| namespaces[0].argocd_rbac_setup.argocd_project_1.name | string | '' | Name of the AppProject. |
| namespaces[0].argocd_rbac_setup.argocd_project_1.overwrite_allowed_envs | list | empty | **OVERWRITE** Destination clusters (Optional). This list will replace the list defined at 'allowed_envs' and defines the allowed target clusters. The clusters here must exist in Argo CD and must be defined on the global-values file. |
| namespaces[0].argocd_rbac_setup.argocd_project_1.overwrite_sourceRepos | list | '*' | **OVERWRITE** List of allowed repositories. If the tenant tries to use a different repo, Argo CD will deny it. * can be used to allow all. Typically not required, since global list can be defined and allowed_source_repos list can be defined too. |
| namespaces[0].argocd_rbac_setup.argocd_project_1.overwrite_source_namespaces | list | empty | **OVERWRITE** sourceNamespaces (Optional). This will replace the list defined at 'source_namespaces' |
| namespaces[0].argocd_rbac_setup.argocd_project_1.rbac[0] | object | empty | Name of the RBAC rule |
| namespaces[0].argocd_rbac_setup.argocd_project_1.rbac[0].description | string | '' | Description of the RBAC rule |
| namespaces[0].argocd_rbac_setup.argocd_project_1.rbac[0].fullaccess | bool | false | **HINT**: You can use _fullaccess: true_ to simply provide full access to the aplication, without defining all actions manually in a list This will automatically set "allow" permissions to all actions (create, get, update, delete, sync and override) for all objects. If this is set to true, all definition at policies[] will be ignored. |
| namespaces[0].argocd_rbac_setup.argocd_project_1.rbac[0].overwrite_oidc_groups | list | empty | **OVERWRITE** List of OCP groups that is allowed to manage objects in this project. This will replace settings defined in allowed_oidc_groups. |
| namespaces[0].argocd_rbac_setup.argocd_project_1.rbac[0].policies | list | [] | For better granularity, you can define the policies in such a list: |
| namespaces[0].argocd_rbac_setup.argocd_project_1.rbac[0].policies[0] | object | '' | Action: possible values are: <br /> <ul> <li>get</li> <li>create</li> <li>update</li> <li>delete</li> <li>sync</li> <li>override</li> </ul> |
| namespaces[0].argocd_rbac_setup.argocd_project_1.rbac[0].policies[0].object | string | '*' | Object: which kind of objects can be managed. |
| namespaces[0].argocd_rbac_setup.argocd_project_1.rbac[0].policies[0].permission | string | deny | Permission: Possible values are: <br /> <ul> <li>allow</li> <li>deny</li> </ul> |
| namespaces[0].default_policies | object | '' | A set of **default** network policies will be created everytime, unless you choose to disable them here You can remove this whole block to have the policies created or you can select specific policies which shall be disabled/enabled. The default policies are: <ul> <li>   allow_from_ingress: Allow Ingress traffic from the OpenShift Router</li> <li>   allow_from_monitoring: Allow OpenShift Monitoring to access and fetch metrics</li> <li>   deny_all_ingress: Deny inner namespace communication (pod to pod of the same Namespace)</li> <li>   allow_kube_apiserver: Allow Kube API Server</li> <li>   deny_all_egress: Forbid ANY Egress traffic</li> <li>   allow_from_same_namespace: allow inner namespace communication</li> <li>   allow_to_dns: Allow openshift DNS</li> <ul> <br /> <br /> **WARNING**: Per default the project role admin/edit (the project or namespace owner) can modify the Network Policies. If you do not want this, you need to create a custom role and assign this to the users.<br /> |
| namespaces[0].default_policies.allow_from_ingress | bool | false | Allow traffic from the IngressController (OpenShift Router) into the namespace. Must be enabled explicitly. |
| namespaces[0].default_policies.allow_from_monitoring | bool | true | Allow traffic from OpenShift Monitoring. This should typically be allowed. |
| namespaces[0].default_policies.allow_from_same_namespace | bool | true | Allow traffic inside the own namespace between the Pods. This is usually allowed to make things easier. |
| namespaces[0].default_policies.allow_kube_apiserver | bool | true | Allow traffic from OpenShift API server. This should typically be allowed. |
| namespaces[0].default_policies.allow_to_dns | bool | true | Allow traffic to OpenShift DNS services. This should be better allowed |
| namespaces[0].default_policies.deny_all_egress | bool | false | Per default deny all outgoing traffic. Default would be false, to allow egress traffic without restriction. |
| namespaces[0].default_policies.deny_all_ingress | bool | false | Deny any ingress connection to this namespace. This is very restrictive and if **allow_from_same_namespace** is set to false it means that also namespace inner connections are not possible unless they are explicitely permitted. |
| namespaces[0].egressIPs | object | '' | EgressIPs for this Namespace Be sure that nodes are labells with: k8s.ovn.org/egress-assignable: "" **NOTE**: Curently only Namespace EgressIPs are supported (not pod) |
| namespaces[0].egressIPs.enabled | bool | false | Enable or disable egressIPs. |
| namespaces[0].egressIPs.ips | list | `["10.100.60.130"]` | List of IP addresses that you want to assign the namespace |
| namespaces[0].enabled | bool | false | Is this Namespace configuration enabled or not? |
| namespaces[0].labels | object | empty | List of additional custom Labels that should be added to the Namespace resource, stored as a key/value pair |
| namespaces[0].labels.my_additional_label | string | `"my_label"` | Example of an additional label |
| namespaces[0].limitRanges | object | '' | Limit Ranges, are optional and restrict resource consumption in a project They can be disabled completely by settings **enabled** to false |
| namespaces[0].limitRanges.container | object | '' | To create a container in the project, the CPU and memory requests in the Pod spec must comply with the values set |
| namespaces[0].limitRanges.container.default.cpu | int | N/A | The default amount of CPU that a container can use if not specified in the Pod spec. |
| namespaces[0].limitRanges.container.default.memory | string | N/A | The default amount of memory that a container can use if not specified in the Pod spec. |
| namespaces[0].limitRanges.container.defaultRequest.cpu | int | N/A | The default amount of CPU that a container can request if not specified in the Pod spec. |
| namespaces[0].limitRanges.container.defaultRequest.memory | string | N/A | The default amount of memory that a container can request if not specified in the Pod spec. |
| namespaces[0].limitRanges.container.max.cpu | int | N/A | The maximum amount of CPU that a single container in a pod can request. |
| namespaces[0].limitRanges.container.max.memory | string | N/A | The maximum amount of memory that a single container in a pod can request. |
| namespaces[0].limitRanges.container.min.cpu | string | N/A | The minimum amount of CPU that a single container in a pod can request. |
| namespaces[0].limitRanges.container.min.memory | string | N/A | The minimum amount of CPU that a single container in a pod can request. |
| namespaces[0].limitRanges.enabled | bool | false | Enable LimitRanges or not. You can either disable it or remove the whole block |
| namespaces[0].limitRanges.pod | object | '' | To create a Pod in the project, the CPU and memory requests in the Pod spec must comply with the values set |
| namespaces[0].limitRanges.pod.max.cpu | string | N/A | The maximum amount of CPU that a pod can request across all containers. |
| namespaces[0].limitRanges.pod.max.memory | string | N/A | The maximum amount of memory that a pod can request across all containers. |
| namespaces[0].limitRanges.pod.min.cpu | string | N/A | The minimum amount of CPU that a pod can request across all containers. |
| namespaces[0].limitRanges.pod.min.memory | string | N/A | The minimum amount of memory that a pod can request across all containers. |
| namespaces[0].limitRanges.pvc.max.storage | string | N/A | The maximum amount of storage that can be requested in a persistent volume claim. |
| namespaces[0].limitRanges.pvc.min.storage | string | N/A | The minimum amount of storage that can be requested in a persistent volume claim. |
| namespaces[0].local_admin_group | object | '' | Create a local Group with Admin users for this project and the required rolebinding If other systems, like LDAP Group sync is used, you will probaably not need this and can either disable it or remove the whole block. |
| namespaces[0].local_admin_group.clusterrole | string | admin | Set the cluster role for the group. |
| namespaces[0].local_admin_group.enabled | bool | false | Is creation of local admin group enabled of not. |
| namespaces[0].local_admin_group.group_name | string | "namespace-name-admins" | Name of the group the shall be created. |
| namespaces[0].local_admin_group.users | list | [] | List of users |
| namespaces[0].networkpolicies | list | '' | Additional custom Network Policies<br /> More or less the definition of Network Policies is always the same<br /> <ol> <li>Define a PodsSelect (or use all pods see example 2)</li> <li>Define Ingress rules with selectors and ports or IP addresses</li> <li>Optionally define egress Rules</li> </ol> <br /> The following are a few examples. |
| namespaces[0].networkpolicies[0] | object | [] | Name of NetworkPolicy. It is recommended to create a human readable name. This example will allow for pods with the labels: app & app2:<br /> Ingress:<br /> &nbsp;&nbsp;FROM: &nbsp;&nbsp;&nbsp;&nbsp;Pods with labels app=myapplication, version=1.0<br /> &nbsp;&nbsp;&nbsp;&nbsp;Namespace with label: testnamespace=true<br /> &nbsp;&nbsp;&nbsp;&nbsp;Port: 443<br /> Egress:<br /> &nbsp;&nbsp;TO:<br /> &nbsp;&nbsp;&nbsp;&nbsp;Pods with labels: app=myapplication, version=1.0<br /> &nbsp;&nbsp;&nbsp;&nbsp;Ports: 443<br /> |
| namespaces[0].networkpolicies[0].active | bool | false | Activate Networkpolicy |
| namespaces[0].networkpolicies[0].egressRules | list | `[{"ports":[{"port":2,"protocol":"UDP"}],"selectors":[]},{"ports":[{"port":443,"protocol":"TCP"}],"selectors":[{"podSelector":{"matchLabels":{"app":"myapplication","version":"1.0"}}}]},{"ports":[{"port":443,"protocol":"TCP"}],"selectors":[{"ipBlock":{"cidr":"10.0.0.1/24"}},{"ipBlock":{"cidr":"171.16.0.0/16"}}]}]` | Outgoing Rules, based on Port and Selectors<br /> Allow outgoing ports (here UDP port 2) from any pod (empty selector)<br /> Allow outgoing port 443 FROM your local pods with the appropriate labels<br /> Allow outgoing to specific CIDR blocks |
| namespaces[0].networkpolicies[0].ingressRules | list | `[{"ports":[{"port":443,"protocol":"TCP"}],"selectors":[{"podSelector":{"matchLabels":{"app":"myapplication","version":"1.0"}}},{"namespaceSelector":{"matchLabels":{"testnamespace":"true"}}},{"ipBlock":{"cidr":"10.1.1.1/24","except":["10.1.1.50/32"]}}]}]` | Incoming Rules, based on Port and Selectors (Pod and Namespace) Ingress FROM definition. Ingress from podselector, based on matchLabels. These labels must be set on the source Pod that opens the connection. Could be empty {} as well. In this example app & version must be set. Ingress from namespace selector. These labels (here testnamespace) must be set on the source Namespace. Allowingress from specific CIDR blocks (10.1.1.1), except 10.1.1.50 |
| namespaces[0].networkpolicies[0].podSelector | object | `{"matchLabels":{"app":"myapplication","app2":"myapplication2"}}` | Pod must have the labels app & app2 |
| namespaces[0].project_size | string | empty | Set the T-Shirt size that is defined in the global-values file. There some predefined configurations (i.e. Quota) cen be prepared, so you do not need to configure them here for each separate tenant. This will also set the label project_size to the Namespace resource. **NOTE**: the T-Shirt sizes must be defined in the globals variables as tshirt_sizes.name |
| namespaces[0].resourceQuotas | object | '' | Configure ResourceQuotas limits of Pods, CPU, Memory, storage, secrets... etc. etc. <br /> Here are a lot of examples, typically, you do not need all of these. cpu/memory is a good start for most use cases.<br /> Byte values will be replace: gi -> Gi, mi -> Mi<br /> If a value is omitted, that means that no limit is set for the object. |
| namespaces[0].resourceQuotas.configmaps | int | N/A | Maximum number of ConfigMaps that can be configured |
| namespaces[0].resourceQuotas.cpu | int | N/A | The sum of CPU requests across all pods in a non-terminal state cannot exceed this value. cpu and requests.cpu are the same value and can be used interchangeably. |
| namespaces[0].resourceQuotas.enabled | bool | false | Enable Quotas or not. This is mandatory. |
| namespaces[0].resourceQuotas.limits.cpu | int | N/A | The sum of CPU limits across all pods in a non-terminal state cannot exceed this value. |
| namespaces[0].resourceQuotas.limits.memory | string | N/A | The sum of memory limits across all pods in a non-terminal state cannot exceed this value. |
| namespaces[0].resourceQuotas.memory | string | N/A | The sum of memory requests across all pods in a non-terminal state cannot exceed this value. memory and requests.memory are the same value and can be used interchangeably. |
| namespaces[0].resourceQuotas.persistentvolumeclaims | int | N/A | Maximum number of PersistentVolumeClaims that can be configured |
| namespaces[0].resourceQuotas.pods | int | N/A | Limit the maximum number of Pods. |
| namespaces[0].resourceQuotas.replicationcontrollers | int | N/A | Maximum number of ReplicationControllers that can be configured |
| namespaces[0].resourceQuotas.requests.cpu | int | N/A | The sum of CPU requests across all pods in a non-terminal state cannot exceed this value. cpu and requests.cpu are the same value and can be used interchangeably. |
| namespaces[0].resourceQuotas.requests.memory | string | N/A | The sum of memory requests across all pods in a non-terminal state cannot exceed this value. memory and requests.memory are the same value and can be used interchangeably. |
| namespaces[0].resourceQuotas.requests.storage | string | N/A | The sum of storage requests across all persistent volume claims in any state cannot exceed this value. |
| namespaces[0].resourceQuotas.resourcequotas | int | N/A | Maximum number of ResourceQuotas that can be configured |
| namespaces[0].resourceQuotas.secrets | int | N/A | Maximum number of Secrets that can be configured |
| namespaces[0].resourceQuotas.services | int | N/A | Maximum number of Services that can be configured |
| namespaces[0].resourceQuotas.storageclasses | object | '' | A list of your storage classes that you would like to limit as well, can be configured here too. The storageClass (in this example "bronze") must exist. |
| namespaces[0].resourceQuotas.storageclasses."bronze.storageclass.storage.k8s.io/persistentvolumeclaims" | string | N/A | and a maximum number of 10 PVCs can be created |
| namespaces[0].resourceQuotas.storageclasses."bronze.storageclass.storage.k8s.io/requests.storage" | string | N/A | For example: Storageclass "bronze" has a request limit of 10 Gi |

## Parameters GLOBAL values file

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global | object | `{"allowed_source_repos":["https://myrepo","https://the-second-repo"],"application_gitops_namespace":"gitops-application","envs":[{"name":"in-cluster","url":"https://kubernetes.default.svc"}],"tshirt_sizes":[{"name":"XL","quota":{"limits":{"cpu":4,"memory":"4Gi"},"pods":100,"requests":{"cpu":1,"memory":"2Gi"}}},{"name":"L","quota":{"limits":{"cpu":2,"memory":"2Gi"},"requests":{"cpu":1,"memory":"1Gi"}}},{"limitRanges":{"container":{"default":{"cpu":1,"memory":"4Gi"},"defaultRequest":{"cpu":1,"memory":"2Gi"}}},"name":"S","quota":{"limits":{"cpu":1,"memory":"1Gi"},"requests":{"cpu":"500m","memory":"1Gi"}}}]}` | Global settings |
| global.allowed_source_repos | list | `["https://myrepo","https://the-second-repo"]` | Repositories projects are allowed to use. These are configured on a global level and used if not specified in a _T-shirt_ project.  Can be overwritten for projects in their specific values-file |
| global.application_gitops_namespace | string | `"gitops-application"` | Namespace of application scoped GitOps instance, that is responsible to deploy workload onto the clusters |
| global.envs | list | `[{"name":"in-cluster","url":"https://kubernetes.default.svc"}]` | cluster environments. A list of clusters that are known in Argo CD Name and URL must be equal to what is defined in Argo CD |
| global.tshirt_sizes | list | `[{"name":"XL","quota":{"limits":{"cpu":4,"memory":"4Gi"},"pods":100,"requests":{"cpu":1,"memory":"2Gi"}}},{"name":"L","quota":{"limits":{"cpu":2,"memory":"2Gi"},"requests":{"cpu":1,"memory":"1Gi"}}},{"limitRanges":{"container":{"default":{"cpu":1,"memory":"4Gi"},"defaultRequest":{"cpu":1,"memory":"2Gi"}}},"name":"S","quota":{"limits":{"cpu":1,"memory":"1Gi"},"requests":{"cpu":"500m","memory":"1Gi"}}}]` | T-shirt sizes for projects, that shall help to pre-defined Quotas or Limitranges. This way, they must not be defined for each and every tenant. It is still possible to overwrite all or a specific single setting in the individual tenant-values-file. For example, when a project is using size "S" but still requires additional CPUs. <br /><br /> The examples here are sizes for XL, L and S.<br /> Different Quotas and/or LimitRange settings can be pre-defined here.<br /> In the individual tenant-values-file the T-shirt size is referenced as project_size.<br /> Any settings that are defined in the individual tenant-values-file will overwrite the T-shirt size. |

## Examples

Verify the article [Project onboarding using GitOps and Helm](https://www.redhat.com/en/blog/project-onboarding-using-gitops-and-helm) for exact documentation of how the charts and tenant onboarding are used.
Also verify my Github repository, which I usually use to deploy Tenants: [OpenShift Clusterconfig GitOps](https://github.com/tjungbauer/openshift-clusterconfig-gitops) (folder (/tenants))

### GLOBAL values-file

The global file defines some global parameters and T-shirt sizes for tenant onboarding.
Possible environments that are known by Argo CD are defined (envs) and allowed_source_repos that are valid for all tenants, unless they are overwritten later can be set here.

In the example below three T-shirt sizes are defined: XL, L and S
They define different Quotas and LimitRanges. These settings can be overwritten in the individual tenant values file if required. For example, when a specific tenant wants to use size S,
but still requires 2 CPUs.

```yaml
---
global:
  application_gitops_namespace: gitops-application

  envs:
    - name: in-cluster
      url: https://kubernetes.default.svc

  allowed_source_repos:
    - "https://myrepo"
    - "https://the-second-repo"

  tshirt_sizes:
      # T-shirt size XL
    - name: XL
      quota:
        pods: 100
        limits:
          cpu: 4
          memory: 4Gi
        requests:
          cpu: 1
          memory: 2Gi

      # T-shirt size L
    - name: L
      quota:
        limits:
          cpu: 2
          memory: 2Gi
        requests:
          cpu: 1
          memory: 1Gi

      # T-shirt size S
    - name: S
      quota:
        limits:
          cpu: 1
          memory: 1Gi
        requests:
          cpu: 500m
          memory: 1Gi
      limitRanges:
        container:
          default:
            cpu: 1
            memory: 4Gi
          defaultRequest:
            cpu: 1
            memory: 2Gi
```

### Examples from tenant individual values-file

Inside the tenant values file many settings can be defined to create the tenant. A tenant can have one or multiple namespace that can be configured individually.

#### General Settings

Before the actual Namespaces are configured, some general settings might be set.

```yaml
allowed_envs:  # (1)
  - in-cluster

allowed_source_repos:  # (2)
  - https://my-git-repo.com/super-repo

allowed_source_namespace:  # (3)
  - my-allows-source-namespace

allowed_oidc_groups:  # (4)
  - admin-group-1
  - admin-group-2
```
<ol>
<li>Allowed environments. They must exist in Argo CD and can be overwritten later in the RBAC (AppProject) configuration if required.</li>
<li>Allowed source repositories from where data can be collected. This list of repositories can be overwritten later in the RBA (AppProject) configuration.</li>
<li>Allow source namespaces (This is currently a Beta feature - April 2024). This defines on which Namespaces Argo CD Application and ApplicationSets resources can be created (in additon to the GitOps namespace). This list can be overwritten later in the RBAC (AppProject) configuration.</li>
<li>Groups that are allowed in RBAC configuration of the AppProject resource of Argo CD. This list can be overwritten later.</li>
</ol>

#### Namespaces - T-shirt and labels

A list of namespaces can be defined, that are created for a tenant.
The name of the Namespace is defined here, as well as an optional T-shirt size and labels.

Verify the list of parameters above or the values file for in-code documentation.

```yaml
namespaces:
  - name: &name my-main-app-project-1
    enabled: true  # (1)

    project_size: "S"  # (2)

    additional_settings:  # (3)
      enable_cluster_monitoring: true

    labels:  # (4)
      my_additional_label: my_label
      another_label: another_label
```
<ol>
<li>Enable the Namespace (default false)</li>
<li>Optional T-shirt size, that must be defined in the GLOBAL values file</li>
<li>Additional settings, for example, enable monitoring</li>
<li>Any labels you want to add to the Namespace</li>
</ol>

#### Namespace - Project Admin Group

A Namespace requires a team that can manage the project to work with workload. This could be omitted when groups are automatically generated by LDAP synchronization for example.
A group can be given a name (otherwise the name of the namespace with the postfix "admin" will be used) and a list of users. In addition, a role can be defined. This is typical "admin" (default),
but in case a custom role has been created, this can be used as well.

```yaml
namespaces:
  - name: &name my-main-app-project-1
    [...]

    local_admin_group:
      enabled: true
      group_name: my_group_name
      clusterrole: admin
      users:
        - mona
        - peter
```

#### Define one or more EgressIPs for the namespace

Sometimes it is required that the outgoing connections from a namespace have a specific source IP address. For this egressIPs can be configured.
To make this work it is required that one or more nodes have the label **k8s.ovn.org/egress-assignable: ""** configured. On these nodes the egressIPs will be configured.

The IP address must be an IP from an appropriate range.

```yaml
    egressIPs:
      enabled: true

      ips:
        - 10.100.60.130
```

#### Namespace - ResourceQuota

The definition of a ResourceQuota is straightforward. A full example can be found in the values file in this chart.
The following small example defines limits with the maximum amount of Secrets and ConfigMaps as well as limits and requests of CPU/memory.
However, many more settings are possible.

```yaml
namespaces:
  - name: &name my-main-app-project-1
    [...]

    resourceQuotas:
      enabled: false

      secrets: 100
      configmaps: 100

      limits:
        cpu: 4
        memory: 4gi  # lower case will be automatically replaced
      requests:
        cpu: 1
        memory: 2Gi
```

#### Namespace - Default NetworkPolicies

For security reasons, it makes sense to define Network Policies for any workload namespace. While you can create any custom NetworkPolicy there are some, which are reused for almost any
tenant namespace.

I have created several pre-defined policies that are enabled by default or might be enabled (or even disabled) if required.

The following default NetworkPolicies are available:

1. Allow from OpenShift ingress (default: disabled)
2. Allow from OpenShift monitoring (default: enabled)
3. Allow from OpenShift API Server (default: enabled)
4. Allow from OpenShift DNS (default: enabled)
5. Deny All Egress connections from a Namespace (default: disabled)
6. Deny all Ingress connections into and inside a Namespace (default: disabled)
7. Allow connection inside the same Namespace ( default: enabled)

If a rule is not defined unter **default_policy** then the default value will be used.

```yaml
namespaces:
  - name: &name my-main-app-project-1
    [...]

    default_policies:
      allow_from_ingress: false
      allow_from_monitoring: true
      allow_kube_apiserver: true
      allow_to_dns: true
      deny_all_egress: false
      deny_all_ingress: false
      allow_from_same_namespace: true
```

#### Namespace - Custom NetworkPolicies

The default policies are usually not enough for individual workloads. Therefore, additional (custom) policies can and should be defined, to meet the application requirements.

The following are some examples, to provide an overview:

##### Allow outgoing port 5432 for all pods in your namespace

```yaml
namespaces:
  - name: &name my-main-app-project-1
    [...]
    networkpolicies:
      - name: allow-outgoing-5432
        active: true
        podSelector: {}
        egressRules:
        - ports:
          - port: 5432
            protocol: TCP
```

This will render the following NetworkPolicy

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: "allow-outgoing-5432"
  namespace: "my-main-app-project-1"
  labels:
    helm.sh/chart: helper-proj-onboarding-1.0.34
    app.kubernetes.io/name: helper-proj-onboarding
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/managed-by: Helm
spec:
  podSelector: {}
  egress:
    - ports:
        - port: 5432
          protocol: TCP
  policyTypes:
    - Egress
```

##### Allow outgoing port 9091 and specifc pods in a specific Namespace

Allow any pod in your namespace (podSelector: {}) to connect to pod with the labels **app.kubernetes.io/component: query-layer** AND **app.kubernetes.io/instance: thanos-querier** (selectors.[0].podSelector) that
are scheduled in a namespace with the label **kubernetes.io/metadata.name: openshift-monitoring** (selectors.[0].namespaceSelector)

```yaml
namespaces:
  - name: &name my-main-app-project-1
    [...]
    networkpolicies:
      - name: allow-egress-openshift-monitoring
        active: true
        podSelector: {}
        egressRules:
        - ports:
          - port: 9091
            protocol: TCP
          selectors:
          - podSelector:
              matchLabels:
                app.kubernetes.io/component: query-layer
                app.kubernetes.io/instance: thanos-querier
            namespaceSelector:
              matchLabels:
                kubernetes.io/metadata.name: openshift-monitoring
```

##### Allow several INCOMING ports to your namespace

In this example, some incoming ports are allowed into your Namespace. This means that your application (backend) is listening on these ports and simply allows connections to them.
Only one port (15691) has defined additional selectors.

```yaml
namespaces:
  - name: &name my-main-app-project-1
    [...]

    networkpolicies:
      - name: allow-to-incoming-ports
        active: true
        podSelector:
          matchLabels:
            app.kubernetes.io/name: backend
        ingressRules:
        - ports:
            - protocol: TCP
              port: 15671
        - ports:
            - protocol: TCP
              port: 8883
        - selectors:
            - podSelector:
                matchLabels:
                  app.kubernetes.io/instance: user-workload
            - namespaceSelector:
                matchLabels:
                  kubernetes.io/metadata.name: openshift-user-workload-monitoring
          ports:
            - protocol: TCP
              port: 15691
```

The result will look like:

```yaml
# Source: helper-proj-onboarding/templates/networkpolicy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: "allow-to-incoming-ports"
  namespace: "my-main-app-project-1"
  labels:
    helm.sh/chart: helper-proj-onboarding-1.0.34
    app.kubernetes.io/name: helper-proj-onboarding
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/managed-by: Helm
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: backend
  ingress:
    - ports:
        - port: 15671
          protocol: TCP
    - ports:
        - port: 8883
          protocol: TCP
    - from:
      - podSelector:
          matchLabels:
            app.kubernetes.io/instance: user-workload
      - namespaceSelector:
          matchLabels:
            kubernetes.io/metadata.name: openshift-user-workload-monitoring
      ports:
        - port: 15691
          protocol: TCP
  policyTypes:
    - Ingress
```

#### Allow outgoing connections to a specific IP Block

Allow outgoing connection to any HTTPS service in the IP Block 10.0.0.1/24 and allow egress connection to a Postgres database at 10.0.0.50

```yaml
namespaces:
  - name: &name my-main-app-project-1
    [...]
    networkpolicies:

      - name: allow-egress-to-https-and-postgres
        active: true
        podSelector: {}
        egressRules:
          - ports:
              - port: 443
                protocol: TCP
            selectors:
              - ipBlock:
                  cidr: 10.0.0.1/24
          - ports: 
              - port: 5432
                protocol: TCP
            selectors: 
              - ipBlock: 
                  cidr: 10.0.0.50/32
```

### Argo CD (OpenShift-GitOps) AppProject configuration

The RBAC configuration for Argo CD is defined in a resource called AppProject. In this Helm chart, the idea was to create an AppProject per namespace. Some might not like that idea and would like to combine
the RBAC configuration ... I am working on that.

However, it is already possible to even create multiple AppProject resources for the same tenant. By overwriting settings, you can create different configurations.

The following is an example. A single AppProject will be created. It **OVERWRITES** the settings that have been defined at the beginning of the values file to define its own
allowed environments, source namespaces or source repositories. It also provides full access to the namespace to manage your workload.

Verify the example values file in this chart and what specific settings might be used.

```yaml
namespaces:
  - name: &name my-main-app-project-1
    [...]

    argocd_rbac_setup:
      argocd_project_1:  # (1)
        enabled: false
        name: *name  # (2)

        overwrite_allowed_envs:  # (3)
          - in-cluster
        overwrite_source_namespaces: # (4)
          - overwritten-source-namespace
        overwrite_sourceRepos: # (5)
         - 'https://git-repo-com/overwrites-other-lists'

        rbac: # (6)
          - name: write
            # **HINT**: You can use _fullaccess: true_ to simply provide full access to the aplication, without defining all actions manually in a list
            # This will automatically set "allow" permissions to all actions (create, get, update, delete, sync and override) for all objects.
            # If this is set to true, all definition at policies[] will be ignored.
            fullaccess: true  # (7)
```
<ol>
<li>Key of the RBAC configuration. Multiple keys with their own configurations can be used</li>
<li>Name of the AppProject resource</li>
<li>OVERWRITE environments that are defined at other places</li>
<li>OVERWRITE source_namespaces that are defined at other places</li>
<li>OVERWRITE source repositories that are defined at other places</li>
<li>Define RBAC configuration</li>
<li>With this setting full access is given. As an alternative individual policies can be defined by using policies[]. Verify the example values file for an example</li>
</ol>

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
