

# cert-manager

  [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

  ![Version: 1.0.5](https://img.shields.io/badge/Version-1.0.5-informational?style=flat-square)

 

  ## Description

  Install and configure the Cert-Manager

This Helm Chart installs and configures the Cert-Manager Operator. It can patch the ClusterManager resource in order to override arguments (for example the list of recursive nameservers)
 and to configure ClusterIssuer or Issuers. Moreover, it is possible to order a certificate by creating a Certificate resource.

Currently, the built-in in-tree issuers are supported: https://cert-manager.io/docs/configuration/selfsigned/

. selfSigned
. ACME
. CA
. Venafi
. Vault

## Dependencies

This chart has the following dependencies:

| Repository | Name | Version |
|------------|------|---------|
| https://redhat-cop.github.io/helm-charts | tpl | ~1.0.0 |

It is best used with a full GitOps approach such as Argo CD does. For example, https://github.com/tjungbauer/openshift-clusterconfig-gitops (see folder cluster/management-cluster/cert-manager)

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| tjungbauer | <tjungbau@redhat.com> | <https://blog.stderr.at/> |

## Sources
Source:
* <https://github.com/tjungbauer/helm-charts>
* <https://charts.stderr.at/>
* <https://github.com/tjungbauer/openshift-clusterconfig-gitops>

Source code: https://github.com/redhat-cop/helm-charts/tree/main/charts/cert-manager

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| certManager.enable_patch | bool | false | Enable pathing of the certManager resource, for the ACME provider. This is required, when the recusrive nameserver shall be changed. For example, when private and public define-domains in AWS Route 53 are used, then the DNS server must be set. Verify the documentation at: https://docs.openshift.com/container-platform/4.15/security/cert_manager_operator/cert-manager-operator-issuer-acme.html The resource itself it created automatically and is therefor patched. |
| certManager.overrideArgs | list | `["--dns01-recursive-nameservers-only","--dns01-recursive-nameservers=ns-362.awsdns-45.com:53,ns-930.awsdns-52.net:53"]` | List of arguments that should be overwritten. |
| certificates.certificate[0] | object | `{"dnsNames":["example.com","www.example.com"],"duration":"2160h0m0s","emailAddresses":["john.doe@cert-manager.io"],"enabled":false,"ipAddresses":["192.168.0.5"],"isCA":false,"issuerRef":{"group":"cert-manager.io","kind":"Issuer","name":"ca-issuer"},"name":"example-cert","namespace":"example","privateKey":{"algorithm":"RSA","encoding":"PKCS1","rotationPolicy":"Always","size":2048},"renewBefore":"360h0m0s","secretName":"example-cert-tls","secretTemplate":{"annotations":{"my-secret-annotation-1":"foo","my-secret-annotation-2":"bar"},"labels":{"my-secret-label":"foo"}},"subject":{"countries":["Country"],"localities":["Cities"],"organizationalUnits":["OrganizationalUnit"],"organizations":["Organization"],"postalCodes":["PostalCode"],"provinces":["State"],"serialNumber":"SerialNumber","streetAddresses":["StreetAddress"]},"syncwave":"0","uris":["spiffe://cluster.local/ns/sandbox/sa/example"],"usages":["server auth","client auth"]}` | Name of the certificate resource. This is not the dnsName of commonName. |
| certificates.certificate[0].dnsNames | list | `["example.com","www.example.com"]` | Requested DNS subject alternative names. |
| certificates.certificate[0].duration | string | 2160h0m0s (90d) | The duration of the certificated (X.509 certificate's duration) Some issuers might be configured to only issue certificates with a set durationt<br /> Minimum value for spec.duration is 1 hour<br /> It is required that spec.duration > spec.renewBefore Value must be in units accepted by Go time.ParseDuration https://golang.org/pkg/time/#ParseDuration |
| certificates.certificate[0].emailAddresses | list | `["john.doe@cert-manager.io"]` | Requested email subject alternative names. |
| certificates.certificate[0].enabled | bool | false | Enable ordering of this certificate |
| certificates.certificate[0].ipAddresses | list | `["192.168.0.5"]` | Requested IP address subject alternative names. |
| certificates.certificate[0].isCA | bool | `false` | Requested basic constraints isCA value. If true, this will automatically add the `cert sign` usage to the list of requested `usages`. |
| certificates.certificate[0].issuerRef.group | string | UNSET (cert-manager.io) | Optional parameter that is only required when external issuers are used. |
| certificates.certificate[0].issuerRef.kind | string | Issuer | The reference can either be ClusterIssuers or Issuer |
| certificates.certificate[0].issuerRef.name | string | `"ca-issuer"` | Name of the Issuer that shall be used. |
| certificates.certificate[0].namespace | string | `"example"` | Namespace for this certificate |
| certificates.certificate[0].privateKey.algorithm | string | RSA | Algorithm of the private key. Possible values (with default sizes if size is not provided): <br />RSA (2048), ECDSA (256) or Ed25519 (ignored)<br /><br /> |
| certificates.certificate[0].privateKey.encoding | string | PKSC1 | The private key cryptography standards (PKCS) encoding for this certificate's private key to be encoded in. Allowed values are PKCS1 an dPKCS8. |
| certificates.certificate[0].privateKey.rotationPolicy | string | Always | RotationPolicy controls how private keys should be regenerated when a re-issuance is being processed. Possible values are 'Never' (the private key will only be generated if it does not already exist) or 'Always' (the private key will aleays be generated whenever a re-issuance occurs. |
| certificates.certificate[0].privateKey.size | int | `2048` | Size is the key bit size of the corresponding private key for this certificate.<br /> If `algorithm` is set to `RSA`, valid values are `2048`, `4096` or `8192`, and will default to `2048` if not specified.<br /> If `algorithm` is set to `ECDSA`, valid values are `256`, `384` or `521`, and will default to `256` if not specified.<br /> If `algorithm` is set to `Ed25519`, Size is ignored. No other values are allowed. |
| certificates.certificate[0].renewBefore | string | 1/3 of duration if not set | How long before the currently issued certificate's expiry cert-manager should renew the certificate. For example, if a certificate is valid for 60 minutes, and `renewBefore=10m`, cert-manager will begin to attempt to renew the certificate 50 minutes after it was issued If unset, this defaults to 1/3 of the issued certificate's lifetime.<br /> Minimum accepted value is 5 minutes.<br /> Value must be in units accepted by Go time.ParseDuration https://golang.org/pkg/time/#ParseDuration |
| certificates.certificate[0].secretName | string | `"example-cert-tls"` | Name of the Secret resource that will be created and managed by the Certificate. It will be populated with a private key and certificate, signed by the denoted issuer. |
| certificates.certificate[0].secretTemplate | object | N/A | secretTemplate is optional. If set, these annotations and labels will be copied to the Secret created by this Certificate. |
| certificates.certificate[0].subject | object | N/A | Requested set of X509 certificate subject attributes. More info: https://datatracker.ietf.org/doc/html/rfc5280#section-4.1.2.6 Might be replaced in the future by literalSubject |
| certificates.certificate[0].subject.countries | list | N/A | Countries to be used on the Certificate. |
| certificates.certificate[0].subject.localities | list | N/A | Cities to be used on the Certificate. |
| certificates.certificate[0].subject.organizationalUnits | list | N/A | Organizational Units to be used on the Certificate. |
| certificates.certificate[0].subject.organizations | list | N/A | Organizations to be used on the Certificate. |
| certificates.certificate[0].subject.postalCodes | list | N/A | Postal Codes to be used on the Certificate. |
| certificates.certificate[0].subject.provinces | list | N/A | States/Provinces to be used on the Certificate. |
| certificates.certificate[0].subject.serialNumber | string | N/A | Serial number to be used on the Certificate. |
| certificates.certificate[0].subject.streetAddresses | list | N/A | Street addresses to be used on the Certificate. |
| certificates.certificate[0].syncwave | string | 1 | Syncwave when the certificate shall be ordered. |
| certificates.certificate[0].uris | list | `["spiffe://cluster.local/ns/sandbox/sa/example"]` | Requested URI subject alternative names. |
| certificates.certificate[0].usages | list | `["server auth","client auth"]` | Set usages for the certificate full list https://cert-manager.io/docs/reference/api-docs/#cert-manager.io/v1.KeyUsage default if not set, cert manager will set: digital signature, key encipherment, and server auth |
| certificates.enabled | bool | false | Enable ordering of certificates |
| issuer[0].acme | object | `{"email":"your@email.com","solvers":[{"dns01":{"route53":{"accessKeyIDSecretRef":{"key":"access-key-id","name":"prod-route53-credentials-secret"},"region":"your-region","secretAccessKeySecretRef":{"key":"secret-access-key","name":"prod-route53-credentials-secret"}}},"selector":{"dnsZones":["define-domains"]}}]}` | Create ACME issuer. ACME CA servers rely on a challenge to verify that a client owns the domain names that the certificate is being requested for. |
| issuer[0].acme.email | string | `"your@email.com"` | Email address, Let's Encrypt will use this to contact you about expiring certificates, and issues related to your account. |
| issuer[0].acme.solvers | list | `[{"dns01":{"route53":{"accessKeyIDSecretRef":{"key":"access-key-id","name":"prod-route53-credentials-secret"},"region":"your-region","secretAccessKeySecretRef":{"key":"secret-access-key","name":"prod-route53-credentials-secret"}}},"selector":{"dnsZones":["define-domains"]}}]` | add a challenge solver. This coulr be DNS01 or HTTP01 The yaml specification will be used as is Verify the official documentation for detailed information: https://cert-manager.io/docs/configuration/acme/ |
| issuer[0].enabled | bool | false | Enable this issuer. |
| issuer[0].name | string | `"acme"` |  |
| issuer[0].syncwave | int | `20` | Syncewave to create this issuer |
| issuer[0].type | string | `"ClusterIssuer"` | Type can be either ClusterIssuer or Issuer |
| issuer[1].enabled | bool | false | Enable this issuer. |
| issuer[1].name | string | `"selfsigned"` |  |
| issuer[1].selfSigned | bool | `true` | Create a selfSigned issuer. The SelfSigned issuer doesn't represent a certificate authority as such, but instead denotes that certificates will "sign themselves" using a given private key. Detailed information can be found at: https://cert-manager.io/docs/configuration/selfsigned/ |
| issuer[1].type | string | `"ClusterIssuer"` | Type can be either ClusterIssuer or Issuer |
| issuer[2].ca | object | `{"secretName":"ca-key-pair"}` | Create CA issuer, CA issuers are generally either for trying cert-manager out or else for advanced users with a good idea of how to run a PKI. Detailed information can be found at: https://cert-manager.io/docs/configuration/ca/ |
| issuer[2].enabled | bool | false | Enable this issuer. |
| issuer[2].name | string | `"ca"` |  |
| issuer[2].type | string | `"ClusterIssuer"` | Type can be either ClusterIssuer or Issuer |
| issuer[3].enabled | bool | false | Enable this issuer. |
| issuer[3].name | string | `"vault"` |  |
| issuer[3].type | string | `"ClusterIssuer"` | Type can be either ClusterIssuer or Issuer |
| issuer[3].vault | object | `{"auth":{"tokenSecretRef":{"key":"token","name":"cert-manager-vault-token"}},"caBundle":"<base64 encoded caBundle PEM file>","path":"pki_int/sign/example-dot-com","server":"https://vault.local"}` | Enable Vault issuer. The Vault Issuer represents the certificate authority Vault. Detailed information can be found at: https://cert-manager.io/docs/configuration/vault/ |
| issuer[4].enabled | bool | false | Enable this issuer. |
| issuer[4].name | string | `"venafi"` |  |
| issuer[4].type | string | `"ClusterIssuer"` | Type can be either ClusterIssuer or Issuer |
| issuer[4].venafi | object | `{"cloud":{"apiTokenSecretRef":{"key":"apikey","name":"vaas-secret"}},"zone":"My Application\\My CIT"}` | The Venafi Issuer types allows you to obtain certificates from Venafi as a Service (VaaS) and Venafi Trust Protection Platform (TPP) instances. Detailed information can be found at: https://cert-manager.io/docs/configuration/venafi/ |

## Example values - for the cert manager

```yaml
---
clusterManager:
  enable_patch: true

  overrideArgs:
    - '--dns01-recursive-nameservers-only'
    - --dns01-recursive-nameservers=ns-362.awsdns-45.com:53,ns-930.awsdns-52.net:53

issuer:
  - name: letsencrypt-prod
    type: ClusterIssuer
    enabled: true
    syncwave: 20

    acme:
      email: <-your-email-address>

      solvers:
        - dns01:
            route53:
              accessKeyIDSecretRef:
                key: access-key-id
                name: prod-route53-credentials-secret
              region: us-west-1
              secretAccessKeySecretRef:
                key: secret-access-key
                name: prod-route53-credentials-secret
          selector:
            dnsZones:
              - <list of domain zones>
```

## Example values - to order a certificate

```yaml
---
certificates:
  enabled: true

  # List of certificates
  certificate:
    - name: router-certificate
      enabled: true
      namespace: openshift-ingress
      syncwave: "0"
      secretName: router-certificate

      dnsNames:
        - apps.ocp.aws.ispworld.at
        - '*.apps.ocp.aws.ispworld.at'

      # Reference to the issuer that shall be used.
      issuerRef:
        name: letsencrypt-prod
        kind: ClusterIssuer
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
