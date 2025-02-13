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

## [pre-commit](.pre-commit-config.yaml)

Pre-commit is enabled which will lint and cleanup any files automatically.
Token and secret checking via [Red Hat Security tooling](https://source.redhat.com/departments/it/it-information-security/leaktk/leaktk_components/rh_pre_commit) is enabled
but requires being connected to the Red Hat VPN on the setup.

The pre-commit hooks can be run manually via:

```bash
pre-commit run --all
```
