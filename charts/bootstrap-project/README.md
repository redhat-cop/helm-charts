# Bootstrap

Bootstrap chart helps you to create Openshift projects, service accounts and rolebindings.

## Installing the chart

To install the chart:

```bash
$ helm template -f bootstrap-project/values.yaml bootstrap-project | oc apply -f-
```

The above command creates objects with default naming convention and configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Configuration
The following table lists the configurable parameters of the Bootstrap chart and their default values.

| Parameter                                        | Description                                                  | Default                               |
| ------------------------------------------------ | -------------------------------------------------------------| ------------------------------------- |
| `prefix`                                         | Prefix to add namespaces                                     | `labs`                                |
| `ci_cd_namespace`                                | Project name to deploy DevEx tools                           | `ci-cd`                               |
| `dev_namespace`                                  | Project name for dev environment                             | `dev`                                 |
| `test_namespace`                                 | Project name for test environment                            | `test`                                |
| `namespaces.labs-ci-cd.bindings.name`            | IDM group name to assign role in ci-cd namespace             | `[labs-devs, labs-admins, dummy-sa]`  |
| `namespaces.labs-ci-cd.bindings.kind`            | Kind to bind to the role in ci-cd namespace                  | `[Group, ServiceAccount]`             |
| `namespaces.labs-ci-cd.bindings.role`            | The role to bind to the group in ci-cd namespace             | `[edit, admin]`                       |
| `namespaces.labs-dev.bindings.name`              | IDM group name to assign role in dev namespace               | `[labs-devs, labs-admins, dummy-sa]`  |
| `namespaces.labs-dev.bindings.kind`              | Kind to bind to the role in dev namespace                    | `[Group, ServiceAccount]`             |
| `namespaces.labs-dev.bindings.role`              | The role to bind to the group in dev namespace               | `[edit, admin]`                       |
| `namespaces.labs-test.bindings.name`             | IDM group name to assign role in test namespace              | `[labs-devs, labs-admins, dummy-sa]`  |
| `namespaces.labs-test.bindings.kind`             | Kind to bind to the role in test namespace                   | `[Group, ServiceAccount]`             |
| `namespaces.labs-test.bindings.role`             | The role to bind to the group in test namespace              | `[edit, admin]`                       |
| `serviceaccounts.name`                           | The name of the service account that will be created         | `dummy-sa`                            |
| `serviceaccounts.namespace`                      | The namespace that the service account will be created in    | `dummy-sa`                            |

These values currently create `labs-ci-cd` , `labs-dev` and `labs-test` namespaces for you to deploy your CICD toolings and applications. If you'd like to change the namespace values, you can override the prefix as below:

```bash
$ helm template --set prefix=my -f bootstrap-project/values.yaml bootstrap-project | oc apply -f-
```

Then you'll have `my-ci-cd` , `my-dev` and `my-test` namespaces ready to use!
