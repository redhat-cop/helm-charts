# Sealed Secrets

This chart contains the resources to use [sealed-secrets](https://github.com/bitnami-labs/sealed-secrets).

## Prerequisites

* Kubernetes >= 1.9

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --namespace kube-system --name my-release stable/sealed-secrets
```

The command deploys a controller and [CRD](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/) for sealed secrets on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete [--purge] my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Using kubeseal

Install the kubeseal CLI by downloading the binary from [sealed-secrets/releases](https://github.com/bitnami-labs/sealed-secrets/releases).

Fetch the public key by passing the release name and namespace:

```bash
kubeseal --fetch-cert \
--controller-name=my-release \
--controller-namespace=my-release-namespace \
> pub-cert.pem
```

Read about kubeseal usage on [sealed-secrets docs](https://github.com/bitnami-labs/sealed-secrets#usage).

## Configuration

| Parameter                     | Description                                                                | Default                                     |
|------------------------------:|:---------------------------------------------------------------------------|:--------------------------------------------|
| **controller.create**         | `true` if Sealed Secrets controller resources should be created            | `true`                                      |
| **namespace**                 | The name of the Namespace to deploy the controller                         | `.Release.namespace`                        |
| **rbac.create**               | `true` if rbac resources should be created                                 | `true`                                      |
| **rbac.pspEnabled**           | `true` if psp resources should be created                                  | `false`                                     |
| **serviceAccount.create**     | Whether to create a service account or not                                 | `true`                                      |
| **serviceAccount.name**       | The name of the service account to create or use                           | `"sealed-secrets-controller"`               |
| **secretName**                | The name of the TLS secret containing the key used to encrypt secrets      | `"sealed-secrets-key"`                      |
| **image.tag**                 | The `Sealed Secrets` image tag                                             | `v0.12.1`                                   |
| **image.pullPolicy**          | The image pull policy for the deployment                                   | `IfNotPresent`                              |
| **image.repository**          | The repository to get the controller image from                            | `quay.io/bitnami/sealed-secrets-controller` |
| **resources**                 | CPU/Memory resource requests/limits                                        | `{}`                                        |
| **crd.create**                | `true` if crd resources should be created                                  | `true`                                      |
| **crd.keep**                  | `true` if the sealed secret CRD should be kept when the chart is deleted   | `true`                                      |
| **networkPolicy**             | Whether to create a network policy that allows access to the service       | `false`                                     |
| **securityContext.runAsUser** | Defines under which user the operator Pod and its containers/processes run | `1001`                                      |
| **securityContext.fsGroup**   | Defines fsGroup for the operator Pod and its containers/processes run      | `65534`                                     |
| **commandArgs**               | Set optional command line arguments passed to the controller process       | `[]`                                        |
| **ingress.enabled**           | Enables Ingress                                                            | `false`                                     |
| **ingress.annotations**       | Ingress annotations                                                        | `{}`                                        |
| **ingress.path**              | Ingress path                                                               | `/v1/cert.pem`                              |
| **ingress.hosts**             | Ingress accepted hostnames                                                 | `["chart-example.local"]`                   |
| **ingress.tls**               | Ingress TLS configuration                                                  | `[]`                                        |
| **podAnnotations**            | Annotations to annotate pods with.                                         | `{}`                                        |
| **podLabels**                 | Labels to be added to pods                                                 | `{}`                                        |
| **priorityClassName**         | Optional class to specify priority for pods                                | `""`                                        |


- In the case that **serviceAccount.create** is `false` and **rbac.create** is `true` it is expected for a service account with the name **serviceAccount.name** to exist _in the same namespace as this chart_ before installation.
- If **serviceAccount.create** is `true` there cannot be an existing service account with the name **serviceAccount.name**.
- If a secret with name **secretName** does not exist _in the same namespace as this chart_, then on install one will be created. If a secret already exists with this name the keys inside will be used.
- OpenShift: unset the runAsUser and fsGroup like this:
```
  securityContext:
    runAsUser:
    fsGroup:
```

## Backup current key pairs:

```bash
oc get secret -l sealedsecrets.bitnami.com/sealed-secrets-key=active -o yaml > sealed-secrets-key-pairs.yaml
```

## Bring your own keys

### Set your vars
```bash
export PRIVATEKEY="mytls.key"
export PUBLICKEY="mytls.crt"
export NAMESPACE="jtudelag-test-sealedsecrets-heml-chart"
export SECRETNAME="mycustomkeys"
```

### Generate a pair of new RSA key pairs:
```bash
openssl req -x509 -nodes -newkey rsa:4096 -keyout "$PRIVATEKEY" -out "$PUBLICKEY" -subj "/CN=sealed-secret/O=sealed-secret"
```

### Create a tls k8s secrets, using your recently created RSA key pair:
```bash
oc -n "$NAMESPACE" create secret tls "$SECRETNAME"  --cert="$PUBLICKEY" --key="$PRIVATEKEY" --dry-run -o yaml
oc -n "$NAMESPACE" label secret "$SECRETNAME" sealedsecrets.bitnami.com/sealed-secrets-key=active
```

### Delteing controller is needed to pick they new keys:
```bash
oc -n  "$NAMESPACE" delete pod -l app.kubernetes.io/name=sealed-secrets
```

### See the new "private keys" in the controller logs
```bash
oc -n "$NAMESPACE" logs $(oc -n  "$NAMESPACE" get pod -l app.kubernetes.io/name=sealed-secrets -o name | cut -d '/' -f2)

controller version: v0.12.1+dirty
2020/06/09 14:30:45 Starting sealed-secrets controller version: v0.12.1+dirty
2020/06/09 14:30:45 Searching for existing private keys
2020/06/09 14:30:45 ----- sealed-secrets-key5rxd9
2020/06/09 14:30:45 ----- mycustomkeys
2020/06/09 14:30:45 HTTP server serving on :8080
```

# Used your recently created public key to "seal" your secret, instead of the controller one:

Usually you have to seale your secrets using the controller provided key:
```bash
kubeseal --controller-name myrelease-sealed-secrets --controller-namespace jtudelag-test-sealedsecrets-heml-chart --scope cluster-wide < mysecret.yaml
```

But you can use your own key by using the `--cert` flag:
```bash
kubeseal --cert ./mytls.crt --scope cluster-wide < mysecret.yaml | oc applyf -f-
```

### We can see the secret has been unsealed succesfully:
```bash
oc -n "$NAMESPACE" logs $(oc -n  "$NAMESPACE" get pod -l app.kubernetes.io/name=sealed-secrets -o name | cut -d '/' -f2)
controller version: v0.12.1+dirty
2020/06/09 14:30:45 Starting sealed-secrets controller version: v0.12.1+dirty
2020/06/09 14:30:45 Searching for existing private keys
2020/06/09 14:30:45 ----- sealed-secrets-key5rxd9
2020/06/09 14:30:45 ----- mycustomkeys
2020/06/09 14:30:45 HTTP server serving on :8080
2020/06/09 14:37:55 Updating jtudelag-test-sealedsecrets-heml-chart/mysecret
2020/06/09 14:37:55 Event(v1.ObjectReference{Kind:"SealedSecret", Namespace:"jtudelag-test-sealedsecrets-heml-chart", Name:"mysecret", UID:"f3a6c537-d254-4c06-b08f-ab9548f28f5b", APIVersion:"bitnami.com/v1alpha1", ResourceVersion:"20469957", FieldPath:""}): type: 'Normal' reason: 'Unsealed' SealedSecret unsealed successfully
```

**NOTE:** 
`mytls.key` is your private key, which is used by the controller to unseal your secret. 
Dont share it with anyone, and save it in a safe place!!