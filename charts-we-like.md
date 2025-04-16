## 🧰 OpenShift Ready Charts 🧰
Below is a collection of charts we've used in the past that run on OpenShift with examples and the values to get up and going:

#### 🕵️‍♀️ Sealed Secrets
[Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets/tree/main/helm/sealed-secrets)
allows you to encrypt your K8s Secret into a SealedSecret, which is safe to store - even to a public repository:

```yaml
nameOverride: sealed-secrets
fullnameOverride: sealed-secrets
# namespace must exist
namespace: labs-ci-cd
# Dont touch the security context values, deployment will fail in OpenShift otherwise.
podSecurityContext:
  fsGroup:
containerSecurityContext:
  runAsUser:
```

#### 🗣 Mattermost
[Mattermost](https://github.com/mattermost/mattermost-helm/tree/master/charts/mattermost-team-edition)
is an OpenSource Chat Application:

```yaml
route:
  enabled: true
mysql:
  mysqlRootPassword: "mysqlpass"
  mysqlUser: "mattermost"
  mysqlPassword: "matterpass"
```

#### 🧪 Zalenium
[Zalenium](https://github.com/zalando/zalenium/tree/master/charts/zalenium)
is a Selenium Grid deployment with on demand provisioning of the browsers for running your tests:

```yaml
hub:
  serviceType: ClusterIP
  openshift:
    deploymentConfig:
      enabled: true
    route:
      enabled: true
  persistence:
    enabled: false
  serviceAccount:
    create: false
  desiredContainers: 0
  podAnnotations:
    app: zalenium
```

#### 🌮 Wekan
[Wekan](https://github.com/wekan/wekan/tree/master/helm/wekan) is an OpenSource Kanban tool:

```yaml
service:
  type: ClusterIP
autoscaling:
  enabled: false
mongodb-replicaset:
  replicas: 1
  securityContext:
    runAsUser: ""
    fsGroup: ""
ingress:
  enabled: false
route:
  enabled: true
```

#### 🦟 Hoverfly
[Hoverfly](https://github.com/helm/charts/tree/master/incubator/hoverfly)
is a lightweight, open source API simulation tool. Using Hoverfly, you can create realistic simulations of the APIs your application depends on:

```yaml
replicaCount: "1"
openshift:
  route:
    admin:
      enabled: true
      hostname: ""
    proxy:
      enabled: true
      hostname: ""
```

#### 🗝 Vault
[Vault](https://github.com/hashicorp/vault-helm.git)
helps you to store and control access to your tokens, passwords, certificates, API keys and other secrets.

```yaml
global:
  tlsDisable: false
  openshift: true
injector:
  enabled: false
  route:
    enabled: true
    host: '""'
server:
  service:
    annotations:
      service.beta.openshift.io/serving-cert-secret-name: vault-tls
  extraVolumes:
    - type: secret
      name: vault-tls
  standalone:
    config: |
      ui = true
      listener "tcp" {
        address = "[::]:8200"
        cluster_address = "[::]:8201"
        tls_cert_file = "/vault/userconfig/vault-tls/tls.crt"
        tls_key_file  = "/vault/userconfig/vault-tls/tls.key"
      }
      storage "file" {
        path = "/vault/data"
      }
```

### 🚉 EAP
[EAP](https://github.com/jbossas/eap-charts.git)
is Red Hat's [Jakarta EE offering](https://www.redhat.com/en/technologies/jboss-middleware/application-platform)

```yaml
build:
  uri: https://github.com/jboss-developer/jboss-eap-quickstarts.git
  ref: EAP_7.4.0.Beta
  pullSecret: replace-with-your-secret
  s2i:
    jdk: "11"
    galleonLayers: 'jaxrs-server'
  env:
  - name: ARTIFACT_DIR
    value: helloworld-rs/target
  - name: MAVEN_ARGS_APPEND
    value: -am -pl helloworld-rs
  - name: MAVEN_OPTS
    value: '-XX:MetaspaceSize=96m -XX:MaxMetaspaceSize=256m'
deploy:
  replicas: 3
```
