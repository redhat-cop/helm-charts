# ⚓️ Red Hat Communities of Practice Helm Charts

[![Install Test](https://github.com/redhat-cop/helm-charts/actions/workflows/install-test.yaml/badge.svg)](https://github.com/redhat-cop/helm-charts/actions/workflows/install-test.yaml)
[![Lint Test](https://github.com/redhat-cop/helm-charts/actions/workflows/lint-test.yaml/badge.svg)](https://github.com/redhat-cop/helm-charts/actions/workflows/lint-test.yaml)
[![Release Charts](https://github.com/redhat-cop/helm-charts/actions/workflows/release.yaml/badge.svg)](https://github.com/redhat-cop/helm-charts/actions/workflows/release.yaml)
[![Scorecard supply-chain security](https://github.com/redhat-cop/helm-charts/actions/workflows/scorecard.yml/badge.svg)](https://github.com/redhat-cop/helm-charts/actions/workflows/scorecard.yml)

A collection of Helm Charts to that are not available in any upstream location or customised to the point it does not make sense to support up stream chart development.

For charts we know work on OpenShift but do not belong here, check out the list of Charts we've used for some ideas

This library is used to support [Open Innovation Labs Ubiquitous Journey Project](https://github.com/rht-labs/ubiquitous-journey)

Additional charts for managing an OpenShift cluster can be found in [redhat-cop/openshift-management](https://github.com/redhat-cop/openshift-management/tree/master/charts)

## 🧰 Add this Helm Repo to your local 🧰
```
helm repo add redhat-cop https://redhat-cop.github.io/helm-charts
```

## 🏃‍♀️💨 How do I run a chart?
Login to your cluster and into your destination project. To install any given Chart using the default values just run:

```bash
helm install $NAME redhat-cop/$CHART_NAME
eg:
helm install my-jenkins redhat-cop/jenkins
```
Where:
* $NAME - is the name you want to give the installed Helm App
* $CHART_NAME - name of the chart found in `charts` directory


## 🏃‍♂️💨Customisation to a chart prior to install
For each chart, navigate to the root of it for the readme and default values. To over ride them, you could create your own `my-values.yaml` and make your changes there before installing

```bash
helm install $NAME -f my-values.yaml redhat-cop/$CHART_NAME
eg:
helm install my-jenkins -f my-values.yaml redhat-cop/jenkins
```

## 🏃‍♂️💨 Chart linting

Before adding a chart to this repo, make sure there is no linting issues, otherwise the PR actions will fail. 
We use both the integrated [`helm lint`](https://helm.sh/docs/helm/helm_lint/) command and the [`chart testing`](https://github.com/helm/chart-testing/blob/master/doc/ct_lint.md) tool.

```bash
helm lint charts/jenkins
ct lint charts/jenkins
```

## 👩‍🏫 Chart README Files
For more info on each chart checkout these!
* [ansible-automation-platform](/charts/ansible-automation-platform)
* [argocd-operator](/charts/argocd-operator)
* [bootstrap-project](/charts/bootstrap-project)
* [dev-ex-dashboard](/charts/dev-ex-dashboard)
* [etherpad](/charts/etherpad)
* [gitops-operator](/charts/gitops-operator)
* [helper-console-links](/charts/helper-console-links)
* [helper-sealed-secrets ](/charts/helper-sealed-secrets)
* [jenkins](/charts/jenkins)
* [kopf](/charts/kopf)
* [network-policy](/charts/network-policy)
* [openshift-logforwarding-splunk](/charts/openshift-logforwarding-splunk)
* [operatorhub](/charts/operatorhub)
* [operators-installer](/charts/operators-installer)
* [owncloud](/charts/owncloud)
* [pact-broker](/charts/pact-broker)
* [ploigos](/charts/ploigos)
* [sonarqube](/charts/sonarqube)
* [sonatype-nexus](/charts/sonatype-nexus)
* [stackrox](/charts/stackrox)
* [static-site](/charts/static-site)
* [tekton-demo](/charts/tekton-demo)
* [operators-installer](/charts/operators-installer)
* [compliance-operator-full-stack](/charts/compliance-operator-full-stack)
* [cost-management](/charts/cost-management)
* [cyclonedx](/charts/cyclonedx)
* [file-integrity-operator](/charts/file-integrity-operator)
* [generic-cluster-config](/charts/generic-cluster-config)
* [helm-policy-generator](/charts/helm-policy-generator)
* [helper-argocd](/charts/helper-argocd)
* [helper-loki-bucket-secret](/charts/helper-loki-bucket-secret)
* [helper-lokistack](/charts/helper-lokistack)
* [helper-objectstore](/charts/helper-objectstore)
* [helper-operator](/charts/helper-operator)
* [helper-proj-onboarding](/charts/helper-proj-onboarding)
* [elper-status-checker](/charts/elper-status-checker)
* [minio-configurator](/charts/minio-configurator)
* [openshift-data-foundation](/charts/openshift-data-foundation)
* [openshift-gitops](/charts/openshift-gitops)
* [openshift-logging](/charts/openshift-logging)
* [rhacm-setup](/charts/rhacm-setup)
* [rhacs-setup](/charts/rhacs-setup)
* [setup-container-security-operator](/charts/setup-container-security-operator)
* [update-clusterversion](/charts/update-clusterversion)
* [tpl](/charts/tpl)

