# OperatorHub

[OperatorHub](https://www.sonarqube.org/) is ....

## Introduction

This chart bootstraps ....


## Installing the chart

To install the chart:

```bash
$ helm repo add rht-labs-charts https://rht-labs.github.io/charts
$ helm install rht-labs-charts/operatorhub
```

## Uninstalling the chart

To uninstall/delete the deployment:

```bash
$ helm delete <name of chart>
```

## Configuration

The following table lists the configurable parameters of the OperatorHub chart and their default values.

| Parameter                             | Description                                                                  | Default                                        |
| ------------------------------------- | ---------------------------------------------------------------------------- | ---------------------------------------------- |
| `replicaCount`                        | Number of replicas deployed                                                  | `1`                                            |
| `deploymentStrategy`                  | Deployment strategy                                                          | `{}`                                           |
| `image.repository`                    | image repository                                                             | `sonarqube`                                    |
| `image.tag`                           | `sonarqube` image tag.                                                       | `8.2-community`                                |
| `image.pullPolicy`                    | Image pull policy                                                            | `IfNotPresent`                                 |
| `image.pullSecret`                    | imagePullSecret to use for private repository                                |                                                |
| `command`                             | command to run in the container                                              | `nil` (need to be set prior to 6.7.6, and 7.4) |
| `elasticsearch.configureNode`         | Modify k8s worker to conform to system requirements                          | `false`                                        |
| `elasticsearch.bootstrapChecks`       | Enables/disables Elasticsearch bootstrap checks                              | `false`                                        |
| `initContainers`                      | Enable or Disable the running of all initContainers                          | `false` (not needed on OpenShift)              |
| `ingress.enabled`                     | Flag for enabling ingress                                                    | false                                          |
| `ingress.labels`                      | Ingress additional labels                                                    | `{}`                                           |
| `ingress.hosts[0].name`               | Hostname to your SonarQube installation                                      | `sonar.organization.com`                       |
| `ingress.hosts[0].path`               | Path within the URL structure                                                | /                                              |
| `ingress.tls`                         | Ingress secrets for TLS certificates                                         | `[]`                                           |
| `livenessProbe.sonarWebContext`       | SonarQube web context for livenessProbe                                      | /                                              |
| `readinessProbe.sonarWebContext`      | SonarQube web context for readinessProbe                                     | /                                              |
| `service.type`                        | Kubernetes service type                                                      | `ClusterIP`                                    |
| `service.externalPort`                | Kubernetes service port                                                      | `9000`                                         |
| `service.internalPort`                | Kubernetes container port                                                    | `9000`                                         |
| `service.labels`                      | Kubernetes service labels                                                    | None                                           |
| `service.annotations`                 | Kubernetes service annotations                                               | None                                           |
| `service.loadBalancerSourceRanges`    | Kubernetes service LB Allowed inbound IP addresses                           | None                                           |
| `service.loadBalancerIP`              | Kubernetes service LB Optional fixed external IP                             | None                                           |
| `persistence.enabled`                 | Flag for enabling persistent storage                                         | false                                          |
| `persistence.annotations`             | Kubernetes pvc annotations                                                   | `{}`                                           |
| `persistence.existingClaim`           | Do not create a new PVC but use this one                                     | None                                           |
| `persistence.storageClass`            | Storage class to be used                                                     | ""                                             |
| `persistence.accessMode`              | Volumes access mode to be set                                                | `ReadWriteOnce`                                |
| `persistence.size`                    | Size of the volume                                                           | 10Gi                                           |
| `persistence.volumes`                 | Specify extra volumes. Refer to ".spec.volumes" specification                | []                                             |
| `persistence.mounts`                  | Specify extra mounts. Refer to ".spec.containers.volumeMounts" specification | []                                             |
| `serviceAccount.create`               | If set to true, create a serviceAccount                                      | false                                          |
| `serviceAccount.name`                 | Name of the serviceAccount to create/use                                     | `sonarqube-sonarqube`                          |
| `serviceAccount.annotations`          | Additional serviceAccount annotations                                        | `{}`                                           |
| `sonarProperties`                     | Custom `sonar.properties` file                                               | None                                           |
| `sonarSecretProperties`               | Additional `sonar.properties` file to load from a secret                     | None                                           |
| `caCerts.secret`                      | Name of the secret containing additional CA certificates                     | `nil`                                          |
| `jvmOpts`                             | Values to add to SONARQUBE_WEB_JVM_OPTS                                      | `""`                                           |
| `env`                                 | Environment variables to attach to the pods                                  | `nil`                                          |
| `sonarSecretKey`                      | Name of existing secret used for settings encryption                         | None                                           |
| `sonarProperties`                     | Custom `sonar.properties` file                                               | `{}`                                           |
| `postgresql.enabled`                  | Set to `false` to use external server                                        | `true`                                         |
| `postgresql.existingSecret`           | Secret containing the password of the external Postgresql server             | `null`                                         |
| `postgresql.postgresqlServer`         | Hostname of the external Postgresql server                                   | `null`                                         |
| `postgresql.postgresqlUsername`       | Postgresql database user                                                     | `sonarUser`                                    |
| `postgresql.postgresqlPassword`       | Postgresql database password                                                 | `sonarPass`                                    |
| `postgresql.postgresqlDatabase`       | Postgresql database name                                                     | `sonarDB`                                      |
| `postgresql.service.port`             | Postgresql port                                                              | `5432`                                         |
| `annotations`                         | Sonarqube Pod annotations                                                    | `{}`                                           |
| `resources`                           | Sonarqube Pod resource requests & limits                                     | `{}`                                           |
| `affinity`                            | Node / Pod affinities                                                        | `{}`                                           |
| `nodeSelector`                        | Node labels for pod assignment                                               | `{}`                                           |
| `hostAliases`                         | Aliases for IPs in /etc/hosts                                                | `[]`                                           |
| `tolerations`                         | List of node taints to tolerate                                              | `[]`                                           |
| `plugins.install`                     | List of plugins to install                                                   | `[]`                                           |
| `plugins.lib`                         | List of plugins to install to `lib/common`                                   | `[]`                                           |
| `plugins.resources`                   | Plugin Pod resource requests & limits                                        | `{}`                                           |
| `plugins.initContainerImage`          | Change init container image                                                  | `alpine:3.10.3`                                |
| `plugins.initSysctlContainerImage`    | Change init sysctl container image                                           | `busybox:1.31`                                 |
| `plugins.initVolumesContainerImage`   | Change init volumes container image                                          | `busybox:1.31`                                 |
| `plugins.initCertsContainerImage`     | Change init ca certs container image                                         | `adoptopenjdk/openjdk11:alpine`                |
| `plugins.initTestContainerImage`      | Change init test container image                                             | `dduportal/bats:0.4.0`                         |
| `plugins.deleteDefaultPlugins`        | Remove default plugins and use plugins.install list                          | `[]`                                           |
| `plugins.httpProxy`                   | For use behind a corporate proxy when downloading plugins                    | ""                                             |
| `plugins.httpsProxy`                  | For use behind a corporate proxy when downloading plugins                    | ""                                             |
| `podLabels`                           | Map of labels to add to the pods                                             | `{}`                                           |
| `sonarqubeFolder`                     | Directory name of Sonarqube                                                  | `/opt/sonarqube`                               |
| `enableTests`                         | Flag that allows tests to be excluded from generated yaml                    | true                                           |

For overriding variables see: [Customizing the chart](https://docs.helm.sh/using_helm/#customizing-the-chart-before-installing)

<!--stackedit_data:
eyJoaXN0b3J5IjpbMzQzMzM3Njg3XX0=
-->