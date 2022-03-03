# Jenkins

[Jenkins](https://jenkins.io/) is an open source automation server which enables developers around the world to reliably build, test, and deploy their software.

## Introduction
This chart helps you to create a Jenkins master and agents on Openshift cluster. It also allows you to customize them based on your needs.

## Installing Jenkins

To install Jenkins on your current namespace:

```bash
$ helm template -f jenkins/values.yaml jenkins | oc apply -f-
```
The above command deploys Jenkins on a cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.


## Configuration
The following table lists the configurable parameters of the Jenkins chart and their default values.

### Jenkins Master

| Parameter                                        | Description                                                                 | Default                                              |
| ------------------------------------------------ | --------------------------------------------------------------------------- | ---------------------------------------------------- |
| `appName`                                        | Name of the application                                                     | `jenkins`                                            |
| `route`                                          | Enable openshift route                                                     | `true`                                               |
| `source_secret.name`                             | Name of the secret object                                                   | `git-auth`                                           |
| `source_secret.username`                         | Username of the git account                                                 | `idm-sa`                                             |
| `source_secret.password`                         | Password of the git account                                                 | `thisisdefinitelymypassword`                         |
| `sealed_secret.name`                             | Name of the secret object                                                   | `nexus-password`                                           |
| `sealed_secret.username`                         | Encrypted username data                                                   | `AgBd8kR+KbG+FiOpYP4SlR80npiNiZI...`                                             |
| `sealed_secret.password`                         | Encrypted password data                                                   | `AgBd8kR+KbG+FiOpYP4SlR80npiNiZI...`                         |
| `deployment.openshiftauth`                       | Enable Openshift OAuth for Jenkins master                                   | `true`                                               |
| `deployment.imagestream.name`                    | Imagestream name for Jenkins master                                         | `jenkins`                                            |
| `deployment.imagestream.tag`                     | Imagestream tag for Jenkins master                                          | `latest`                                             |
| `deployment.limits.memory_request`               | Starting request of memory that Jenkins master use                          |`2Gi`                                                 |
| `deployment.limits.memory_limit`                 | Maximum amount of memory Jenkins master use                                 | `6Gi`                                                |
| `deployment.limits.cpu_request`                  | Starting request of cpu that Jenkins master use                             | `500m`                                               |
| `deployment.limits.cpu_limit`                    | Maximum amount of memory Jenkins master use                                 | `1`                                                  |
| `deployment.env_vars`                            | Environment variables for Jenkins master                                    | `''`                                                 |
| `persistence.accessModes`                        | Access mode for Jenkins PV                                                  | `''`                                      |
| `persistence.volumeSize`                         | Volume size for Jenkins PV                                                  | `''`                                               |
| `services.jenkins.port_name`                     | Port name of service for Jenkins master                                     | `web`                                                |
| `services.jenkins.port`                          | Port of Jenkins master service                                              | `80`                                                 |
| `services.jenkins.target_port`                   | Target port of Jenkins master service                                       | `8080`                                               |
| `services.jenkins.selector`                      | Selector for Jenkins master service to match with Jenkins master deployment | `jenkins`                                            |
| `services.jenkins.annotations`                   | Jenkins service annotation                                                  | `service.alpha.openshift.io/dependencies`            |
| `services.jenkins-jnlp.port_name`                | Port name of service for Jenkins JNLP                                       | `agent`                                              |
| `services.jenkins-jnlp.port`                     | Port of Jenkins master service                                              | `50000`                                              |
| `services.jenkins-jnlp.target_port`              | Target port of Jenkins JNLP service                                         | `50000`                                              |
| `services.jenkins-jnlp.selector`                 | Selector for Jenkins JNLP service to match with Jenkins master deployment   | `jenkins`                                            |
|`buildconfigs.name`| Build and ImageStream name | `''`
|`buildconfigs.name.strategy_type`| Build strategy type for Jenkins | `Docker`
|`buildconfigs.name.source_repo`| Git repo URL for custom | `https://github.com/redhat-cop/containers-quickstarts`
|`buildconfigs.name.source_repo_ref`| Git Reference of custom Jenkins | `master`
|`buildconfigs.name.source_context_dir`| The directory in the source repository where Jenkins master docker build is | `/` 
|`buildconfigs.name.builder_image_kind`| Builder image kind | `ImageStreamTag`
|`buildconfigs.name.builder_image_name`| Builder image name for custom build | `''`
|`buildconfigs.name.builder_image_tag`| Builder image tag for custom build | `''`
|`role` | The value of role value for Jenkins Agent ImageStream. It is used for Jenkins sync plugin to discover agents automatically | `jenkins-slave` |
|`configAsCode.configMap` | The name of the ConfigMap to create and associate with the Jenkins DeploymentConfig in order to be used for Configuration-as-Code | `null` |
|`configAsCode.body` | The body content of the configuration-as-code which will be stored in the ConfigMap, mounted in the Jenkins pod, and read in as Configuration by the Configuration-as-Code plugin | `null` |
### Environment Variables
There are additional environment variables you can set to customize your Jenkins based on your needs. You can update these values on your [values](https://github.com/redhat-cop/helm-charts/blob/master/charts/jenkins/values.yaml#L23) file.
| Variable                                         | Description                                                                 | Default                                              |
| ------------------------------------------------ | --------------------------------------------------------------------------- | ---------------------------------------------------- |
| `JVM_ARCH`                                       | Java VM architecture                                                        | `x86_64`                                             |
| `DISABLE_ADMINISTRATIVE_MONITORS`                | Disable memory intensive administrative monitors                            | `false`                                              |
| `ENABLE_FATAL_ERROR_LOG_FILE`                    | Enable fatal error log file                                                 | `false`                                              |
| `JENKINS_OPTS`                                   | Jenkins arguments                                                           | `--sessionTimeout=0`                                 |
| `SLACK_BASE_URL`                                 | Slack base url                                                              | `''`                                                 |
| `SLACK_ROOM`                                     | Default Slack channel                                                       | `''`                                                 |
| `SLACK_TOKEN_CREDENTIAL_ID`                      | Slack token credential ID                                                   | `''`                                                 |
| `SLACK_TEAM`                                     | Default Slack team                                                          | `''`                                                 |
| `SHARED_LIB_REPO`                                | Jenkins Shared library repository name                                      | `''`                                                 |
| `SHARED_LIB_NAME`                                | Jenkins Shared library name                                                 | `''`                                                 |
| `SHARED_LIB_REF`                                 | Jenkins Shared library reference                                            | `''`                                                 |
| `SHARED_LIB_SECRET`                              | Jenkins Shared library secret                                               | `''`                                                 |
| `GITLAB_HOST`                                    | Http address of the GitLab project                                          | `''`                                                 |
| `GITLAB_TOKEN`                                   | GitLab API token to access repos and projects                               | `''`                                                 |
| `GITLAB_GROUP_NAME`                              | GitLab group name where projects are stored                                 | `rht-labs`                                           |


### Jenkins Agents
Following agents are created by default when you install the chart. They are designed to run in OpenShift as described [here](https://docs.openshift.com/container-platform/latest/openshift_images/using_images/images-other-jenkins.html#images-other-jenkins-config-kubernetes_images-other-jenkins). You can find more details at [containers-quickstarts](https://github.com/redhat-cop/containers-quickstarts") repository.

- jenkins-agent-ansible
- jenkins-agent-arachni
- jenkins-agent-argocd
- jenkins-agent-conftest
- jenkins-agent-erlang
- jenkins-agent-golang
- jenkins-agent-graalvm
- jenkins-agent-gradle
- jenkins-agent-helm
- jenkins-agent-image-mgmt
- jenkins-agent-mongodb
- jenkins-agent-mvn
- jenkins-agent-npm
- jenkins-agent-python
- jenkins-agent-ruby
- jenkins-agent-rust

You can remove the ones you do not need by deleting the related imagestream and buildconfig blocks from [values](https://github.com/redhat-cop/helm-charts/blob/master/charts/jenkins/values.yaml#L80) file.

### Persistence
If you want to set your Jenkins as ephemeral, you should either remove the persistence [block](https://github.com/redhat-cop/helm-charts/blob/master/charts/jenkins/values.yaml#L55) from your values file or set persistent value as below during the installation:

```bash
$ helm template --set persistence='' -f jenkins/values.yaml jenkins | oc apply -f-
```
