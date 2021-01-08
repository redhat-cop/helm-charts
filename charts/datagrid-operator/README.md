# ⚓️ Datagrid Operator Helm Deploy

Datagrid Helm Chart customises and deploys the [datagrid](https://www.redhat.com/en/technologies/jboss-middleware/data-grid) project using the [Operator](https://access.redhat.com/documentation/en-us/red_hat_data_grid/7.3/html/running_the_data_grid_operator/index) written by Red Hat.

## Installing the chart

To install the chart:

```bash
$ helm template -f datagrid-operator/values.yaml datagrid-operator | oc apply -f-
```

The above command creates objects with default naming convention and configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Retrieving Credentials

Get credentials from authentication secrets to access Data Grid clusters. Retrieve credentials from authentication secrets, as in the following example:


    $ oc get secret datagrid-cluster-generated-secret

    $ oc get secret datagrid-cluster-generated-secret \
        -o jsonpath="{.data.identities\.yaml}" | base64 --decode

```credentials:
- username: developer
  password: dIRs5cAAsHIeeRIL
- username: operator
  password: uMBo9CmEdEduYk24
```

[More about credentials and authentication here](https://access.redhat.com/documentation/en-us/red_hat_data_grid/8.1/html/running_data_grid_on_openshift/authentication).

## Configuration
The following table lists the configurable parameters of the datagrid chart and their default values. For more detailed overview of what's configurable, checkout the [datagrid Operator Docs](https://datagrid-operator.readthedocs.io/en/latest/reference/datagrid/)

| Parameter                                        | Description                                                  | Default                               |
| ------------------------------------------------ | -------------------------------------------------------------| ------------------------------------- |
| `namespace`                                      | Project name to deploy DevEx tools                           | `labs-ci-cd`                          |
| `name`                                           | Project name for datagrid server                               | `labs-datagrid`                         |
| `instancelabel`                                  | Unique identifier for datagrid default label                   | `rht-labs.com/ubiquitous-journey`     |
