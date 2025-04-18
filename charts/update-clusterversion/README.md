

# update-clusterversion

  [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

  ![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square)



  ## Description

  A Helm chart to update OpenShift ClusterVersion

This Chart can be used to start a cluster update using a GitOps approach.
All you need are the required channel, the version and (optionally) the image-sha.

All this information can be found by `oc get clusterversion/version -o yaml`.

Simply select the channel, version etc and update your values file.
Once Argo CD syncs the changes the update process will start.

## Dependencies

This chart has the following dependencies:

| Repository | Name | Version |
|------------|------|---------|

It is best used with a full GitOps approach such as Argo CD does. For example, https://github.com/tjungbauer/openshift-clusterconfig-gitops

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| tjungbauer | <tjungbau@redhat.com> | <https://blog.stderr.at/> |

## Sources
Source:

Source code: https://github.com/redhat-cop/helm-charts

## Parameters

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| channel | string | `"your-channel"` | The channel that shall be used for that cluster. The available channels can be found with oc get clusterversion -o yaml Verify the availableUpdates to find the required channel. |
| desiredVersion | string | `"your-target-version"` | The desired version that the cluster shall be updated to. The available versions can be found with oc get clusterversion -o yaml Verify the availableUpdates to find the required version. |
| image | string | `""` | OPTIONAL: The desired image SHA that the cluster shall be updated to. The available SHA can be found with oc get clusterversion -o yaml Verify the availableUpdates to find the required SHA. This option is optional and typically only used for restricted clusters. |

## Example values

Update the cluster to version 4.15.15 using the channel stable-4.15

```yaml
channel: stable-4.15
desiredVersion: 4.15.15
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
