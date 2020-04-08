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

## 👩‍🏫 Chart README Files
For more info on each chart checkout these!
* [jenkins](tree/master/charts/jenkins)
* [sonarqube](tree/master/charts/sonarqube)
* [bootstrap-project](tree/master/charts/bootstrap-project)
* [operatorhub](tree/master/charts/operatorhub)
* [pact-broker](tree/master/charts/pact-broker)
