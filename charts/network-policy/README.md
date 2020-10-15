# 🌐📝 Network Policy

Network policy chart for creating rules on Network traffic in a `Namespace`. This chart's defaults contains an example for multitenant ingress for a namespace by denying all traffic, then allowing specific pod to pod communication and ingress traffic in from the OpenShift routers' namespace. An example `policy` is also included to allow prometheus scrape metrics from the project.

## Installing the chart

To install the chart:

```bash
$ helm template my-policy -f network-policy/values.yaml network-policy | oc apply -n my-project -f-
```

The above command creates objects with default configuration.

To run the chart and remove some of the configuration, for example the `multitenant_policies`:
```bash
$  helm template my-policy -f network-policy/values.yaml network-policy --set multitenant_policies= | oc apply -n my-project -f-
```


## Configuration
The following table lists the configurable parameters of the Network Policy chart and their default values.

| Parameter                                        | Description                                                  | Default                               |
| ------------------------------------------------ | -------------------------------------------------------------| ------------------------------------- |
| `enabled`                                | Toggle to enable or disable this chart                           | `true`                               |
| `multitenant_policies`                                  | An array of standard rules to isolate a namespace traffic from other pod comms                            | see values file.                                 |
| `policies`                                 | Rules for allowing or disallowing pod comms in an NS                            | see values file                                |
| `policies.name`            | name for the network policy             | eg `my-cool-rule`  |
| `policies.spec`            | Spec for the network rules - to match OpenShift network plicy rules see [here](https://docs.openshift.com/container-platform/4.5/networking/network_policy/about-network-policy.html) for deets                  | see values file...             |
