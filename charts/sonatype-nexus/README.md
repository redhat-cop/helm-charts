# sonatype-nexus

Chart was forked from the official sonatype nexus operator (which actually calls this chart). It uses a UBI based image set in [values.yaml](values.yaml)

```yaml
  imageName: registry.connect.redhat.com/sonatype/nexus-repository-manager:<version>
```

https://github.com/sonatype/operator-nxrm3/blob/master/helm-charts/sonatype-nexus/Chart.yaml

## Features

- nexus default admin password used
- services and route setup for openshift
- anonymous access on by default, initial configuration turned off
- post setup k8s job to configure repositories [setup-nexus-job.yaml](templates/setup-nexus-job.yaml) suitable for labs-ci-cd in UJ (raw, helm, npm etc)

## Installing the chart

To install the chart:

```bash
oc new-project nexus-test
helm template my -f sonatype-nexus/values.yaml sonatype-nexus/ | oc apply -f-
```

Check success of setup job:
```bash
$ stern nexus-setup-p4ddg

+ nexus-setup-26nqt › nc
nexus-setup-26nqt nc waiting for nexus pod ready...
nexus-setup-26nqt nc pod/nexus-sonatype-nexus-7b8b68955c-48jbx condition met
nexus-setup-26nqt nc creating helm-charts helm hosted repo
nexus-setup-26nqt nc creating labs-npm npm proxy
nexus-setup-26nqt nc creating labs-static raw hosted repo
nexus-setup-26nqt nc restarting nexus...
nexus-setup-26nqt nc pod "nexus-sonatype-nexus-7b8b68955c-48jbx" deleted
nexus-setup-26nqt nc pod/nexus-sonatype-nexus-7b8b68955c-6sr4x condition met
nexus-setup-26nqt nc Done!
```

Delete the `nexus-setup` job resources (only needed to run once)
```
oc delete job,sa -lapp=nexus-setup
oc delete rolebinding edit-0
```

## Configuration
The following table lists the most common configurable parameters for the Nexus application, along with their default values. For a full listing of values which may want to be configured see the [values.yaml](values.yaml) file.

| Parameter                                        | Description                                                  | Default                               |
| ------------------------------------------------ | -------------------------------------------------------------| ------------------------------------- |
| `helmRepository`                                 | Name of the hosted Helm repository                           | `helm-charts`                         |
| `npmRepository`                                  | Name of the NPM proxy repository                             | `labs-npm`                            |
| `rawRepository`                                  | Name of the hosted raw repository                            | `labs-static`                         |
| `persistence.storageSize`                        | Size of the generated PVC for Nexus                          | `8Gi`                                 |
| `includeRHRepositories`                          | Include RedHat maven repositories in maven-public            | `true`                                |
