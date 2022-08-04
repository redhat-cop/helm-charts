openshift-logforwarding-splunk
===============================

Deploys an instance of Fluentd with support for integrating with the [OpenShift Log Forwarding API](https://docs.openshift.com/container-platform/4.4/logging/config/cluster-logging-external.html) to forward logs to [Splunk](https://www.splunk.com/) via the HTTP Event Collector (HEC).

## Prerequisites

The following prerequisites must be satisfied prior to the installation

* OpenShift 4.3+
* OpenShift Cluster Logging Installed
* Splunk instance available

## Installing the Chart

While the chart provides a sensible set of default value, the value of the HEC token must be provided using the value `forwarding.splunk.token`. The chart can be installed with the release name `openshift-logforwarding-splunk` into the `openshift-logging` namespace as shown below:

```
$ helm install --namespace=openshift-logging openshift-logforwarding-splunk . --set forwarding.splunk.token=<token>
```

## Configuration

A full list of configurable values to customize the behavior of the chart can be found in the [values.yaml](values.yaml) file.

## Uninstalling the Chart

To remove the previously installed chart, execute the following command:

```
$ helm uninstall --namespace=openshift-logging openshift-logforwarding-splunk
```
