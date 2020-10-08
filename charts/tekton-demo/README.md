# tekton-demo

The goal of this tool

1. Install tkn cli

Only supported images 
- ubi8/nodejs-10


1. Create github secret

oc create secret generic github-webhook-secret --from-literal=token=xxxx -n do101-cicd

## allow imagestream from dev to prod
manage taskrun via tkn command line

2. Define policies

oc policy add-role-to-user \
    system:image-puller system:serviceaccount:do101-cicd:tekton-triggers-sa \
    --namespace=do101-development

oc policy add-role-to-user \
    system:image-puller system:serviceaccount:do101-cicd:tekton-triggers-sa \
    --namespace=do101-production

oc adm policy add-scc-to-user privileged system:serviceaccount:do101-cicd:tekton-triggers-sa -n do101-cicd
oc adm policy add-scc-to-user privileged system:serviceaccount:do101-cicd:tekton-triggers-sa -n do101-development
oc adm policy add-scc-to-user privileged system:serviceaccount:do101-cicd:tekton-triggers-sa -n do101-production
oc adm policy add-role-to-user edit system:serviceaccount:do101-cicd:tekton-triggers-sa -n do101-cicd
oc adm policy add-role-to-user edit system:serviceaccount:do101-cicd:tekton-triggers-sa -n do101-development
oc adm policy add-role-to-user edit system:serviceaccount:do101-cicd:tekton-triggers-sa -n do101-production
