# ⚓️ Upstream Keycloak Operator Helm Deploy

Keycloak Operator Helm Chart customises and deploys the [Operator](https://github.com/keycloak/keycloak-operator) written by Keycloak Community and [Keycloak](hhttps://www.keycloak.org/) instance (optionally).

This chart deploys the Keycloak Operator using a Deployment, instead of using the OLM (Subscription and Operator Group).

So, two things are installed with this chart:
* Keycloak Operator
* (Optional) A one replica [keycloak instance](templates/KeycloakInstance.yaml) managed by the operator. No other Keycloak resources such as realms or users are deployed.

One thing to note, the default credentials to access the Keycloak instance admin console are managed by the operator and stored in a secret in the same Namespace:
```bash
oc get secrets -l app=keycloak | grep credential
```

## Installing the chart

To install the chart:

```bash
$ helm template -f keycloak-operator/values.yaml keycloak-operator | oc apply -f-
```

The above command creates objects with default naming convention and configuration. 
The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Configuration
The following table lists the configurable parameters of the Keykloak Operator chart and their default values.
A simple instance of Keycloak is deployed among the Operator. You can check it [here](templates/KeycloakInstance.yaml).

For more keycloak instance examples you can check the [keycloak-operator repo examples](https://github.com/keycloak/keycloak-operator/tree/10.0.0/deploy/examples/keycloak). 

You can check also the [examples in the repo](https://github.com/keycloak/keycloak-operator/tree/10.0.0/deploy/examples) for other CRs managed by the Operator, such as `keycloak realms`, `keycloak users` or `keycloak clients`


| Parameter                                        | Description                                                  | Default                               |
| ------------------------------------------------ | -------------------------------------------------------------| ------------------------------------- |
| `enabled`                                        | Chart is enbaled or not.                                     | `true`                                |
| `name`                                           | Chart name.                                                  | `uj-keycloak`                         |
| `namespace`                                      | Namespace to depoly the Operator and the Keycloak instance.  | `labs-ci-cd`                          |
| `version`                                        | Keycloak Operator version. Matches Quay.io image version.    | `10.0.0`                              |
| `keycloak_instance`                              | Deploy a keycloak instance.                                  | `true`                                |