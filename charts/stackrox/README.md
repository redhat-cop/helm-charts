# stackrox chart

Installs the ACS/Stackrox Operator, configures a Central instance and a SecuredCluster. Uses a Job for initialization work. Set `--set verbose=true` to see verbose job logs.

Production:
```bash
helm repo add redhat-cop https://redhat-cop.github.io/helm-charts
helm install stackrox redhat-cop/stackrox
```

Debug/Development:
```bash
helm upgrade --install stackrox . --namespace tl500 --debug
```

You can watch the logs of the init job:
```bash
stern -n stackrox configure-stackrox-
```

StackRox WebUI credentials (user is "admin")
```bash
# get web url
echo https://$(oc -n stackrox get route central --template='{{ .spec.host }}')
# get credentials
echo $(oc -n stackrox get secret central-htpasswd -o go-template='{{index .data "password" | base64decode}}')
```

Stores the Admin API Token created whilst creating the SecuredCluster in a secret for later use
```bash
ROX_API_TOKEN=$(oc -n stackrox get secret rox-api-token-tl500 -o go-template='{{index .data "token" | base64decode}}')
```
