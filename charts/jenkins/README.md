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
| `source secret.name`                             | Name of the secret object                                                   | `git-auth`                                           |
| `source secret.username`                         | Username of the git account                                                 | `idm-sa`                                             |
| `source secret.password`                         | Password of the git account                                                 | `thisisdefinitelymypassword`                         |
| `deployment.openshiftauth`                       | Enable Openshift OAuth for Jenkins master                                   | `true`                                               |
| `deployment.imagestream.name`                    | Imagestream name for Jenkins master                                         | `jenkins`                                            |
| `deployment.imagestream.tag`                     | Imagestream tag for Jenkins master                                          | `latest`                                             |
| `deployment.limits.memory_request`               | Starting request of memory that Jenkins master use                          |`2Gi`                                                 |
| `deployment.limits.memory_limit`                 | Maximum amount of memory Jenkins master use                                 | `6Gi`                                                |
| `deployment.limits.cpu_request`                  | Starting request of cpu that Jenkins master use                             | `500m`                                               |
| `deployment.limits.cpu_limit`                    | Maximum amount of memory Jenkins master use                                 | `1`                                                  |
| `deployment.env_vars`                            | Environment variables for Jenkins master                                    | `''`                                                 |
| `persistence.accessModes`                        | Access mode for Jenkins PV                                                  | `ReadWriteOnce`                                      |
| `persistence.volumeSize`                         | Volume size for Jenkins PV                                                  | `20Gi`                                               |
| `services.jenkins.port_name`                     | Port name of service for Jenkins master                                     | `web`                                                |
| `services.jenkins.port`                          | Port of Jenkins master service                                              | `80`                                                 |
| `services.jenkins.target_port`                   | Target port of Jenkins master service                                       | `8080`                                               |
| `services.jenkins.selector`                      | Selector for Jenkins master service to match with Jenkins master deployment | `jenkins`                                            |
| `services.jenkins.annotations`                   | Jenkins service annotation                                                  | `service.alpha.openshift.io/dependencies`            |
| `services.jenkins-jnlp.port_name`                | Port name of service for Jenkins JNLP                                       | `agent`                                              |
| `services.jenkins-jnlp.port`                     | Port of Jenkins master service                                              | `50000`                                              |
| `services.jenkins-jnlp.target_port`              | Target port of Jenkins JNLP service                                         | `50000`                                              |
| `services.jenkins-jnlp.selector`                 | Selector for Jenkins JNLP service to match with Jenkins master deployment   | `jenkins`                                            |
| `imagestreams.jenkins.external.builder_registry` | Builder image registry for Jenkins custom build                             | `quay.io`                                            |
| `imagestreams.jenkins.external.builder_repo`     | Builder image repo for Jenkins custom build                                 | `openshift`                                          |
| `imagestreams.jenkins.external.builder_image`    | Builder image for Jenkins custom build                                      | `origin-jenkins`                                     |
| `imagestreams.jenkins.external.builder_imagetag` | Builder image tag for Jenkins custom build                                  | `latest`                                             |
| `buildconfigs.jenkins.build_trigger_secret`      | Webhook Secret for Jenkins master build                                     | `shhhhh-this-is-my-super-duper-secret123-shhhhh`     |
| `buildconfigs.jenkins.strategy_type`             | Build strategy type for Jenkins master                                      | `Source`                                             |
| `buildconfigs.jenkins.pull_secret`               | Pull secret for Jenkins master source code repo                             | `''`                                                 |
| `buildconfigs.jenkins.source_repo`               | Git repo URL for custom Jenkins                                             | `https://github.com/rht-labs/s2i-config-jenkins.git` |
| `buildconfigs.jenkins.source_repo_ref`           | Git Reference of custom Jenkins repo                                        | `v1.6`                                               |
| `buildconfigs.jenkins.source_context_dir`        | The directory in the source repository where Jenkins master docker build is | `/`                                                  |
| `buildconfigs.jenkins.builder_image_name`        | Builder image name for custom build                                         | `jenkins`                                            |
| `buildconfigs.jenkins.builder_image_tag`         | Builder image tag for custom build                                          | `2`                                                  |

### Environment Variables
There are additional environment variables you can set to customize your Jenkins based on your needs. You can update these values on your [values](https://github.com/rht-labs/helm-charts/blob/master/charts/jenkins/values.yaml#L23) file.
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
Following agents are created by default when you install the chart. They are designed to run in OpenShift as described [here](https://docs.openshift.com/container-platform/4.1/openshift_images/using_images/images-other-jenkins.html#images-other-jenkins-config-kubernetes_images-other-jenkins). You can find more details at [containers-quickstarts](https://github.com/redhat-cop/containers-quickstarts") repository.

- jenkins-slave-mvn
- jenkins-slave-argocd
- jenkins-slave-helm
- jenkins-slave-ansible
- jenkins-slave-arachni
- jenkins-slave-golang
- jenkins-slave-gradle
- jenkins-slave-image-mgmt
- jenkins-slave-mongodb
- jenkins-slave-npm
- jenkins-slave-python
- jenkins-slave-ruby
- jenkins-slave-zap

You can remove the ones you do not need by deleting the related imagestream and buildconfig blocks from [values](https://github.com/rht-labs/helm-charts/blob/master/charts/jenkins/values.yaml#L80) file.

### Persistence
If you want to set your Jenkins as ephemeral, you should either remove the persistence [block](https://github.com/rht-labs/helm-charts/blob/master/charts/jenkins/values.yaml#L55) from your values file or set persistent value as below during the installation:

```bash
$ helm template --set persistence='' -f jenkins/values.yaml jenkins | oc apply -f-
```
