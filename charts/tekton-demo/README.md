# tekton-demo

<!-- The goal of this tool -->
<!-- 1. Install tkn cli -->


Images being used:
    
    - ubi8/nodejs-10
    - openshift/origin-cli

1. Create namespaces

    oc create namespace do101-cicd
    oc create namespace do101-development
    oc create namespace do101-production

2. Change values.yaml to reflect your own repository. Please a repo lowercase name

1. Create github secret

    oc create secret generic github-webhook-secret --from-literal=token=XXXXXXX -n do101-cicd

1. Create github private public key secret

    oc create secret generic github-deploy-secret \
        --from-file=ssh-privatekey=$HOME/.ssh/id_rsa \
        --namespace do101-cicd

1. Install the package

    helm template -f charts/tekton-demo/values.yaml charts/tekton-demo | oc apply -f-


2. Check pod `create-do101-github-webhook-pod-kmc4p` and make sure the webhook was created correctly
2. Define policies

```
oc policy add-role-to-user \
    system:image-puller system:serviceaccount:do101-cicd:tekton-triggers-sa \
    --namespace=do101-development
```

```
oc policy add-role-to-user \
    system:image-puller system:serviceaccount:do101-cicd:tekton-triggers-sa \
    --namespace=do101-production
```

    oc adm policy add-scc-to-user privileged system:serviceaccount:do101-cicd:tekton-triggers-sa -n do101-cicd
    oc adm policy add-scc-to-user privileged system:serviceaccount:do101-cicd:tekton-triggers-sa -n do101-development
    oc adm policy add-scc-to-user privileged system:serviceaccount:do101-cicd:tekton-triggers-sa -n do101-production
    oc adm policy add-role-to-user edit system:serviceaccount:do101-cicd:tekton-triggers-sa -n do101-cicd
    oc adm policy add-role-to-user edit system:serviceaccount:do101-cicd:tekton-triggers-sa -n do101-development
    oc adm policy add-role-to-user edit system:serviceaccount:do101-cicd:tekton-triggers-sa -n do101-production

### Deploying to development environment

1. Create a new branch called `develop` and push to the repo to trigger a new build

    git checkout -b develop
    git push origin develop

2. Create a new branch called `feature/awesome-feature` and push to the repo to trigger a new independent build

    git checkout -b feature/awesome-feature
    git push origin feature/awesome-feature

### Deploying to production environment

1. From the latest `develop` branch, create a new branch called `release/1.0.0`

    git checkout -b release/1.0.0
    git push origin release/1.0.0

2. Patching and hotfixes folllows the same structure

    git checkout -b hotfix/1.0.1
    git push origin hotfix/1.0.1

    git checkout -b patch/1.0.2
    git push origin patch/1.0.2