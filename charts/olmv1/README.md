# olmv1

## Introduction

This chart will install operators or cluster extensions in a declarative, GitOps friendly way using OLM v1.

Please refer to the official OpenShift documentation for more information about how OLM v1 works: https://docs.redhat.com/en/documentation/openshift_container_platform/4.19/html-single/extensions/index#extensions-overview

## Values

Here are the values used by this chart

| Value                     | Type    | Required  | Description                                                                                                 |
| -----------------------   | ------- | ----------| ----------------------------------------------------------------------------------------------------------- |
| name                      | string  | yes       | Name for the `ClusterExtension`                                                                               |
| namespace                 | string  | yes       | Namespace to create resources in                                                                            |
| upgradeConstraintPolicy   | string  | No        | Populates `clusterextension.spec.source.catalog.upgradeConstraintPolicy`                                    |
| version                   | string  | no        | Populates `clusterextension.spec.source.catalog.version`                                                    |
| channels                  | list    | no        | Populates `clusterextension.spec.source.catalog.channels`                                                   |
| catalogSelector           | map     | no        | Populates `clusterextension.spec.source.catalog.selector`                                                   |
| upgradeConstraintPolicy   | string  | no        | Populates `clusterextension.spec.source.catalog.upgradeConstraintPolicy`                                    |
| packageName               | string  | no        | Populates `clusterextension.spec.source.catalog.packageName`                                                |   
| clusterRole               | string  | yes *     | Specify a cluster role to assign to the ServiceAccount used to install the operator                         |  
| rbac                      | map     | yes *     | Specify cluster and/or namespace rbac rules to assign to the ServiceAccount used to install the operator    |  

\* One of `clusterRole` or `rbac` is required.

## Examples

### Install cert-manager using selective RBAC rules

```
- name: openshift-cert-manager-operator
  namespace: openshift-cert-manager-operator
  upgradeConstraintPolicy: CatalogProvided
  packageName: openshift-cert-manager-operator
  version: 1.16.1
  channels:
  - stable-v1.16
  rbac: 
    cluster:
    - apiGroups: ["apiextensions.k8s.io"]
      resources: ["customresourcedefinitions"]
      verbs: ["get", "list", "watch"]
    - apiGroups: ["rbac.authorization.k8s.io"]
      resources: ["clusterrolebindings"]
      verbs: ["get", "list", "watch"]
    - apiGroups: ["olm.operatorframework.io"]
      resources: ["clusterextensions/finalizers"]
      verbs: ["get", "update", "patch"]
    namespace:
    - apiGroups: [""]
      resources: ["pods"]
      verbs: ["get", "watch", "list"]
    - apiGroups: [""]
      resources: ["serviceaccounts"]
      verbs: ["get", "list", "watch", "create"]
    - apiGroups: [""]
      resources: ["services"]
      verbs: ["get", "list", "watch"]
    - apiGroups: ["apps"]
      resources: ["deployments"]
      verbs: ["get", "list", "watch"]
```

### Install cert-manager using the cluster-admin role

```
- name: openshift-cert-manager-operator
  namespace: openshift-cert-manager-operator
  upgradeConstraintPolicy: CatalogProvided
  packageName: openshift-cert-manager-operator
  version: 1.16.1
  channels:
  - stable-v1.16
  clusterRole: cluster-admin
```