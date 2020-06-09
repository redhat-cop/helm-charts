# ⚓️ Open Innovation Labs Helm Charts

![Release Charts](https://github.com/rht-labs/charts/workflows/Release%20Charts/badge.svg)

A collection of Helm Charts to support [Labs Developer Experience](https://github.com/rht-labs/ubiquitous-journey)

## 🧰 Add this Helm Repo to your local 🧰
```
helm repo add rht-labs https://rht-labs.github.io/helm-charts
```

## 🏃‍♀️💨 How do I run a chart?
Login to your cluster and into your destination project. To install any given Chart using the default values just run:
```bash
helm install $NAME rht-labs/$CHART_NAME
eg:
helm install my-jenkins rht-labs/jenkins
```
Where:
* $NAME - is the name you want to give the installed Helm App
* $CHART_NAME - name of the chart found in `charts` directory


## 🏃‍♂️💨Customisation to a chart prior to install
For each chart, navigate to the root of it for the readme and default values. To over ride them, you could create your own `my-values.yaml` and make your changes there before installing
```bash
helm install $NAME -f my-values.yaml rht-labs/$CHART_NAME
eg:
helm install my-jenkins -f my-values.yaml rht-labs/jenkins
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
* [jenkins](/charts/jenkins)
* [sonarqube](/charts/sonarqube)
* [bootstrap-project](/charts/bootstrap-project)
* [operatorhub](/charts/operatorhub)
* [pact-broker](/charts/pact-broker)
* [sealed-secrets](/charts/sealed-secrets)
