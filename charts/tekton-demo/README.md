# tekton-demo

1. Create github secret

## allow imagestream from dev to prod

2. Define policies

oc policy add-role-to-user \
    system:image-puller system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa \
    --namespace=nodejs-tekton-production

oc adm policy add-scc-to-user privileged system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa -n nodejs-tekton-cicd
oc adm policy add-scc-to-user privileged system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa -n nodejs-tekton-development
oc adm policy add-scc-to-user privileged system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa -n nodejs-tekton-production
oc adm policy add-role-to-user edit system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa -n nodejs-tekton-cicd
oc adm policy add-role-to-user edit system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa -n nodejs-tekton-development
oc adm policy add-role-to-user edit system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa -n nodejs-tekton-production
