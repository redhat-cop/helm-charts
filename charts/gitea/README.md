# Gitea: Git with a cup of tea

[Gitea](https://gitea.io/) is a simple Git repository manager with issue tracking.  Gitea is a community managed lightweight code hosting solution written in Go. It is published under the MIT license.

## Introduction

This chart helps you to create Gitea server on OpenShift without requiring elevated privileges.

## Installing Gitea

To install Gitea in a given namespace:

```bash
helm upgrade --install --repo=https://redhat-cop.github.io/helm-charts gitea gitea --set db.password=S00perSekretP@ssw0rd --set hostname=gitea.apps.mycluster.example.com
```

**YOU MUST SPECIFY THE DB PASSWORD AND THE PUBLIC-FACING HOSTNAME**

## Uninstalling The Chart

```bash
helm delete gitea
```

## Configuration

| Parameter               | Description                               | Default Value    | Required?
|-------------------------|-------------------------------------------|------------------|----------
| hostname                | The public-facing FQDN for the web app    | NONE             | Yes
| internal_token          | A 106 char token key                      | Randomly Generated | No
| secret_key              | Secret Key                                | Randomly Generated | No
| db.password             | The password to configure in the PostgreSQL DB | NONE        | Yes
| db.name                 | The name of the DB resources to be created| gitea-db         | No
| db.user                 | DB Username                               | gitea            | No
| db.memory_limit         | The memory limit for the DB               | 512Mi            | No
| db.imagestream_name     | The name of the imagestream container     | postgresql       | No
| db.imagestream_namespace| The name of the imagestream namespace     | openshift        | No
| db.imagestream_tag      | The imagestream version tag               | latest           | No
