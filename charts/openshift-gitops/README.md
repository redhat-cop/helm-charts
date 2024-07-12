

# openshift-gitops

  [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

  ![Version: 1.0.45](https://img.shields.io/badge/Version-1.0.45-informational?style=flat-square)

 

  ## Description

  Installs and patches the Red Hat Openshift Gitops Operator

Install and configure an Argo CD instance...

With this Helm chart, OpenShift Gitops can be deployed and configured. By default, the operator will deploy the first
instance automatically, which be used and patched, but also additional instances can be deployed by this Chart.

## Dependencies

This chart has the following dependencies:

| Repository | Name | Version |
|------------|------|---------|
| https://redhat-cop.github.io/helm-charts | helper-operator | ~1.0.18 |
| https://redhat-cop.github.io/helm-charts | helper-status-checker | ~4.0.0 |
| https://redhat-cop.github.io/helm-charts | tpl | ~1.0.0 |

It is best used with a full GitOps approach such as Argo CD does. For example, https://github.com/tjungbauer/openshift-clusterconfig-gitops

However, for the first instance, a simple shell script is used: https://github.com/tjungbauer/openshift-clusterconfig-gitops/blob/main/init_GitOps.sh
This first instance typically deploys the Operator itself as well. Thus the dependency on helper-operator subchart.
Any further instance does not need to deploy the Operator and can simply configure the new Argo CD instance.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| tjungbauer | <tjungbau@redhat.com> | <https://blog.stderr.at/> |

## Sources
Source:

Source code: https://redhat-cop.github.io/helm-charts/tree/main/charts/openshift-gitops

## Parameters

Verify the sub-charts for additional settings:

* [helper-operator](https://github.com/tjungbauer/helm-charts/tree/main/charts/helper-operator)
* [helper-status-checker](https://github.com/tjungbauer/helm-charts/tree/main/charts/helper-operator)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| gitopsinstances.gitops_application | object | `{"appset":{"cpu_limits":"2","cpu_requests":"250m","memory_limits":"1Gi","memory_requests":"512Mi"},"argo_serviceaccount":"openshift-gitops-app-controller","clusterAdmin":"disabled","controller":{"cpu_limits":"2","cpu_requests":"250m","memory_limits":"2Gi","memory_requests":"1Gi"},"custom_resourceHealthChecks":"- check: |\n    hs = {}\n    hs.status = \"Progressing\"\n    hs.message = \"Progressing ClusterLogging\"\n    if obj.status ~= nil and obj.status.conditions ~= nil then\n        for i, condition in ipairs(obj.status.conditions) do\n          if condition.type == \"Ready\" then\n              hs.status = \"Healthy\"\n              hs.message = \"ClusterLogging is ready\"\n          end\n        end\n        return hs\n    end\n    return hs\n  group: logging.openshift.io\n  kind: ClusterLogging","default_resourceHealthChecks":true,"enabled":false,"generic_config":{"applicationInstanceLabelKey":"argocd.argoproj.io/application-instance","disableAdmin":true,"kustomizeBuildOptions":"--enable-helm","resourceTrackingMethod":"annotation"},"ha":{"cpu_limits":"500m","cpu_requests":"250m","enabled":false,"memory_limits":"256Mi","memory_requests":"128Mi"},"namespace":"gitops-application","rbac":{"defaultRole":"role:none","policy":"# Access Control\ng, system:cluster-admins, role:admin\ng, cluster-admin, role:admin\np, role:none, applications, get, */*, deny\np, role:none, certificates, get, *, deny\np, role:none, clusters, get, *, deny\np, role:none, repositories, get, *, deny\np, role:none, projects, get, *, deny\np, role:none, accounts, get, *, deny\np, role:none, gpgkeys, get, *, deny","scopes":"[groups]"},"redis":{"cpu_limits":"500m","cpu_requests":"250m","memory_limits":"256Mi","memory_requests":"128Mi"},"repo":{"cpu_limits":"1","cpu_requests":"250m","memory_limits":"1Gi","memory_requests":"256Mi"},"resourceExclusions":"# resources to be excluded\n- apiGroups:\n  - tekton.dev\n  clusters:\n  - '*'\n  kinds:\n  - TaskRun\n  - PipelineRun","server":{"cpu_limits":"500m","cpu_requests":"125m","host":"gitops.apps.prod.ocp.cluster","logLevel":"info","memory_limits":"256Mi","memory_requests":"128Mi","replicas":1,"route":{"enabled":true,"tls":{"caCertificate":"-----BEGIN CERTIFICATE-----\ncaCertificate\n-----END CERTIFICATE-----","certificate":"-----BEGIN CERTIFICATE-----\nCertificate\n-----END CERTIFICATE-----","destinationCACertificate":"-----BEGIN CERTIFICATE-----\ndestination CS Certificate\n-----END CERTIFICATE-----","enabled":true,"insecureEdgeTerminationPolicy":"Redirect","key":"-----BEGIN PRIVATE KEY -----\nkey\n-----END PRIVATE KEY -----","termination":"edge"}}},"sourceNamespaces":{"enabled":true,"observedNamesapces":["app1","app2"]},"sso":{"dex":{"cpu_limits":"500m","cpu_requests":"250m","memory_limits":"256Mi","memory_requests":"128Mi","openShiftOAuth":true},"provider":"dex"},"syncwave":10,"tolerations":[{"effect":"NoSchedule","key":"infra","operator":"Equal","value":"reserved"},{"effect":"NoSchedule","key":"infra","operator":"Equal","value":"reserved"}]}` | Instance "gitops_application" that is created. |
| gitopsinstances.gitops_application.appset.cpu_limits | string | 2 | CPU Limits for the ApplicationSet controller. |
| gitopsinstances.gitops_application.appset.cpu_requests | string | 250m | CPU Requests for the ApplicationSet controller. |
| gitopsinstances.gitops_application.appset.memory_limits | string | 1Gi | Memory Limits for the ApplicationSet controller. |
| gitopsinstances.gitops_application.appset.memory_requests | string | 512Mi | Memory Requests for the ApplicationSet controller. |
| gitopsinstances.gitops_application.argo_serviceaccount | string | openshift-gitops-app-controller | Name of the service account the main argo CD instance is running. |
| gitopsinstances.gitops_application.clusterAdmin | string | disabled | Enable cluster-admin Rolebinding. Usually only required for the main Argo CD instance. |
| gitopsinstances.gitops_application.controller | object | `{"cpu_limits":"2","cpu_requests":"250m","memory_limits":"2Gi","memory_requests":"1Gi"}` | Settings for the Controller (Applications) This can set limits and requests |
| gitopsinstances.gitops_application.controller.cpu_limits | string | 2 | CPU Limits for the controller. |
| gitopsinstances.gitops_application.controller.cpu_requests | string | 250m | CPU Requests for the controller. |
| gitopsinstances.gitops_application.controller.memory_limits | string | 2Gi | Memory Limits for the controller. |
| gitopsinstances.gitops_application.controller.memory_requests | string | 1Gi | Memory Requests for the controller. |
| gitopsinstances.gitops_application.custom_resourceHealthChecks | string | empty | Default custom health checks. This must be LUA format so Argo can read it. |
| gitopsinstances.gitops_application.default_resourceHealthChecks | bool | false | Enable default health checks. This will create some default health checks I usually add. * ClusterLogging, * Application (Argo CD), * Lokistack, * Subcription, * Central (ACS), InstallPlan |
| gitopsinstances.gitops_application.enabled | bool | false | Create the instance or not. |
| gitopsinstances.gitops_application.generic_config.disableAdmin | bool | `true` | Disable the first administrator user. This can be done if SSO with, for example, OpenShift is configured. |
| gitopsinstances.gitops_application.ha.cpu_limits | string | 500m | CPU Limits for the HA. |
| gitopsinstances.gitops_application.ha.cpu_requests | string | 250m | CPU Requests for the HA. |
| gitopsinstances.gitops_application.ha.enabled | bool | false | Enable HA for Argo CD |
| gitopsinstances.gitops_application.ha.memory_limits | string | 256Mi | Memory Limits for the HA. |
| gitopsinstances.gitops_application.ha.memory_requests | string | 128Mi | Memory Requests for the HA. |
| gitopsinstances.gitops_application.namespace | string | `"gitops-application"` | Namespace for this application |
| gitopsinstances.gitops_application.rbac | object | `{"defaultRole":"role:none","policy":"# Access Control\ng, system:cluster-admins, role:admin\ng, cluster-admin, role:admin\np, role:none, applications, get, */*, deny\np, role:none, certificates, get, *, deny\np, role:none, clusters, get, *, deny\np, role:none, repositories, get, *, deny\np, role:none, projects, get, *, deny\np, role:none, accounts, get, *, deny\np, role:none, gpgkeys, get, *, deny","scopes":"[groups]"}` | RBAC settings for the Argo CD instance This will set the default role to "none" and denies access to any resource. |
| gitopsinstances.gitops_application.rbac.defaultRole | string | `"role:none"` | Default role to use |
| gitopsinstances.gitops_application.rbac.policy | string | `"# Access Control\ng, system:cluster-admins, role:admin\ng, cluster-admin, role:admin\np, role:none, applications, get, */*, deny\np, role:none, certificates, get, *, deny\np, role:none, clusters, get, *, deny\np, role:none, repositories, get, *, deny\np, role:none, projects, get, *, deny\np, role:none, accounts, get, *, deny\np, role:none, gpgkeys, get, *, deny"` | Default policy. Here everything will be denied, unless you are member of the group "cluster-admin" |
| gitopsinstances.gitops_application.redis.cpu_limits | string | 500m | CPU Limits for the Redis controller. |
| gitopsinstances.gitops_application.redis.cpu_requests | string | 250m | CPU Requests for the Redis controller. |
| gitopsinstances.gitops_application.redis.memory_limits | string | 256Mi | Memory Limits for the Redis controller. |
| gitopsinstances.gitops_application.redis.memory_requests | string | 128Mi | Memory Requests for the Redis controller. |
| gitopsinstances.gitops_application.repo.cpu_limits | string | 1 | CPU Limits for the Repo controller. |
| gitopsinstances.gitops_application.repo.cpu_requests | string | 250m | CPU Requests for the Repo controller. |
| gitopsinstances.gitops_application.repo.memory_limits | string | 1Gi | Memory Limits for the Repo controller. |
| gitopsinstances.gitops_application.repo.memory_requests | string | 256Mi | Memory Requests for the Repo controller. |
| gitopsinstances.gitops_application.resourceExclusions | string | empty | Define resources that should be excluded For example Tekton TaskRuns and PipelineRuns should not be observed by Argo CD. |
| gitopsinstances.gitops_application.server | object | `{"cpu_limits":"500m","cpu_requests":"125m","host":"gitops.apps.prod.ocp.cluster","logLevel":"info","memory_limits":"256Mi","memory_requests":"128Mi","replicas":1,"route":{"enabled":true,"tls":{"caCertificate":"-----BEGIN CERTIFICATE-----\ncaCertificate\n-----END CERTIFICATE-----","certificate":"-----BEGIN CERTIFICATE-----\nCertificate\n-----END CERTIFICATE-----","destinationCACertificate":"-----BEGIN CERTIFICATE-----\ndestination CS Certificate\n-----END CERTIFICATE-----","enabled":true,"insecureEdgeTerminationPolicy":"Redirect","key":"-----BEGIN PRIVATE KEY -----\nkey\n-----END PRIVATE KEY -----","termination":"edge"}}}` | Argo CD Server configuration options. |
| gitopsinstances.gitops_application.server.cpu_limits | string | 500m | Set CPU Limits for server. |
| gitopsinstances.gitops_application.server.cpu_requests | string | 125m | Set CPU Requests for server. |
| gitopsinstances.gitops_application.server.host | string | `"gitops.apps.prod.ocp.cluster"` | Hostname for the GitOps URL. |
| gitopsinstances.gitops_application.server.logLevel | string | `"info"` | LogLevel refers to the log level to be used by the ArgoCD Server component. Valid options are debug, info, error, and warn. Can be omitted. |
| gitopsinstances.gitops_application.server.memory_limits | string | 256Mi | Set Memory Limits for server. |
| gitopsinstances.gitops_application.server.memory_requests | string | 128Mi | Set Memory Requests for server. |
| gitopsinstances.gitops_application.server.replicas | int | `1` | Replicas for Argo CD server. Can be omitted. |
| gitopsinstances.gitops_application.server.route | object | `{"enabled":true,"tls":{"caCertificate":"-----BEGIN CERTIFICATE-----\ncaCertificate\n-----END CERTIFICATE-----","certificate":"-----BEGIN CERTIFICATE-----\nCertificate\n-----END CERTIFICATE-----","destinationCACertificate":"-----BEGIN CERTIFICATE-----\ndestination CS Certificate\n-----END CERTIFICATE-----","enabled":true,"insecureEdgeTerminationPolicy":"Redirect","key":"-----BEGIN PRIVATE KEY -----\nkey\n-----END PRIVATE KEY -----","termination":"edge"}}` | Route defines the desired state for an OpenShift Route for the Argo CD Server component. |
| gitopsinstances.gitops_application.server.route.enabled | bool | true | Enable route or not. |
| gitopsinstances.gitops_application.server.route.tls | object | `{"caCertificate":"-----BEGIN CERTIFICATE-----\ncaCertificate\n-----END CERTIFICATE-----","certificate":"-----BEGIN CERTIFICATE-----\nCertificate\n-----END CERTIFICATE-----","destinationCACertificate":"-----BEGIN CERTIFICATE-----\ndestination CS Certificate\n-----END CERTIFICATE-----","enabled":true,"insecureEdgeTerminationPolicy":"Redirect","key":"-----BEGIN PRIVATE KEY -----\nkey\n-----END PRIVATE KEY -----","termination":"edge"}` | TLS provides the ability to configure certificates and termination for the Route. |
| gitopsinstances.gitops_application.server.route.tls.caCertificate | string | `"-----BEGIN CERTIFICATE-----\ncaCertificate\n-----END CERTIFICATE-----"` | caCertificate provides the cert authority certificate contents |
| gitopsinstances.gitops_application.server.route.tls.certificate | string | `"-----BEGIN CERTIFICATE-----\nCertificate\n-----END CERTIFICATE-----"` | Content of the certificate |
| gitopsinstances.gitops_application.server.route.tls.destinationCACertificate | string | `"-----BEGIN CERTIFICATE-----\ndestination CS Certificate\n-----END CERTIFICATE-----"` | destinationCACertificate provides the contents of the ca certificate of the final destination. When using reencrypt termination this file should be provided in order to have routers use it for health checks on the secure connection. If this field is not specified, the router may provide its own destination CA and perform hostname validation using the short service name (service.namespace.svc), which allows infrastructure generated certificates to automatically verify. |
| gitopsinstances.gitops_application.server.route.tls.enabled | bool | false | Enable TLS settings. |
| gitopsinstances.gitops_application.server.route.tls.insecureEdgeTerminationPolicy | string | Redirect | insecureEdgeTerminationPolicy indicates the desired behavior for insecure connections to a route. While each router may make its own decisions on which ports to expose, this is normally port 80. * Allow - traffic is sent to the server on the insecure port * Disable - no traffic is allowed on the insecure port. * Redirect - clients are redirected to the secure port. |
| gitopsinstances.gitops_application.server.route.tls.key | string | `"-----BEGIN PRIVATE KEY -----\nkey\n-----END PRIVATE KEY -----"` | Content of the key of the certificate |
| gitopsinstances.gitops_application.server.route.tls.termination | string | edfe | Select the termination type. |
| gitopsinstances.gitops_application.sourceNamespaces | object | `{"enabled":true,"observedNamesapces":["app1","app2"]}` | Define Namespace where Application AND ApplicationSets can be stored. As of March 2024 this is a BETA feature. The list of namespaces will be configured for Applications and ApplicationSets |
| gitopsinstances.gitops_application.sourceNamespaces.enabled | bool | false | Enable sourceNamespaces. |
| gitopsinstances.gitops_application.sourceNamespaces.observedNamesapces | list | `["app1","app2"]` | A list Namespaces where Argo CD will look for Applications and ApplicationSets |
| gitopsinstances.gitops_application.sso.dex.cpu_limits | string | 500m | CPU Limits for the ApplicationSet controller. |
| gitopsinstances.gitops_application.sso.dex.cpu_requests | string | 250m | CPU Requests for the ApplicationSet controller. |
| gitopsinstances.gitops_application.sso.dex.memory_limits | string | 256Mi | Memory Limits for the ApplicationSet controller. |
| gitopsinstances.gitops_application.sso.dex.memory_requests | string | 128Mi | Memory Requests for the ApplicationSet controller. |
| gitopsinstances.gitops_application.sso.dex.openShiftOAuth | bool | true | Enable OpenShift Authentication |
| gitopsinstances.gitops_application.sso.provider | string | `"dex"` | Set the provider for SSO. Can be "dex" or "keycloak". Currently this Helm chart supports "dex" only. |
| gitopsinstances.gitops_application.syncwave | int | 10 | Syncwave for the Argo CD Object |
| gitopsinstances.gitops_application.tolerations | list | `[{"effect":"NoSchedule","key":"infra","operator":"Equal","value":"reserved"},{"effect":"NoSchedule","key":"infra","operator":"Equal","value":"reserved"}]` | Nodeplacement ... Define tolerators for Argo CD Pods. |
| hostname | string | `"gitops.apps.prod.ocp.cluster"` |  |

## Example

```yaml
---
hostname: &hostname gitops.apps.prod.ocp.cluster

openshift-gitops:
  gitopsinstances:
    gitops_application:
      enabled: true
      namespace: gitops-application

      server:
        host: *hostname
        route:
          enabled: true

      sourceNamespaces:
        enabled: true
        observedNamesapces:
          - app1
          - app2

      generic_config:
        disableAdmin: true
        resourceTrackingMethod: annotation

      ha:
        enabled: false

      tolerations:
        - effect: NoSchedule
          key: infra
          operator: Equal
          value: reserved
        - effect: NoSchedule
          key: infra
          operator: Equal
          value: reserved

      rbac:
        defaultRole: 'role:none'
        policy: |-
            # Access Control
            g, system:cluster-admins, role:admin
            g, cluster-admin, role:admin
            p, role:none, applications, get, */*, deny
            p, role:none, certificates, get, *, deny
            p, role:none, clusters, get, *, deny
            p, role:none, repositories, get, *, deny
            p, role:none, projects, get, *, deny
            p, role:none, accounts, get, *, deny
            p, role:none, gpgkeys, get, *, deny
        scopes: '[groups]'

      # This will create some default health checks I usually add.
      # * ClusterLogging, * Application (Argo CD), * Lokistack, * Subcription, * Central (ACS), InstallPlan
      # @default -- false
      default_resourceHealthChecks: true

      custom_resourceHealthChecks: |-
          - check: |
              hs = {}
              hs.status = "Progressing"
              hs.message = "Progressing ClusterLogging"
              if obj.status ~= nil and obj.status.conditions ~= nil then
                  for i, condition in ipairs(obj.status.conditions) do
                    if condition.type == "Ready" then
                        hs.status = "Healthy"
                        hs.message = "ClusterLogging is ready"
                    end
                  end
                  return hs
              end
              return hs
            group: logging.openshift.io
            kind: ClusterLogging     
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
