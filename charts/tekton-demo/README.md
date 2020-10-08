# tekton-demo

The goal of this tool

1. Install tkn cli

Only supported images 
- ubi8/nodejs-10


1. Create github secret

## allow imagestream from dev to prod
manage taskrun via tkn command line

2. Define policies

oc policy add-role-to-user \
    system:image-puller system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa \
    --namespace=nodejs-tekton-development

oc policy add-role-to-user \
    system:image-puller system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa \
    --namespace=nodejs-tekton-production

oc adm policy add-scc-to-user privileged system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa -n nodejs-tekton-cicd
oc adm policy add-scc-to-user privileged system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa -n nodejs-tekton-development
oc adm policy add-scc-to-user privileged system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa -n nodejs-tekton-production
oc adm policy add-role-to-user edit system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa -n nodejs-tekton-cicd
oc adm policy add-role-to-user edit system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa -n nodejs-tekton-development
oc adm policy add-role-to-user edit system:serviceaccount:nodejs-tekton-cicd:tekton-triggers-sa -n nodejs-tekton-production
