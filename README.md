# Open Innovation Labs Charts

A collection of Helm Charts to support Labs Developer Experience

## How do I run it?

To deploy just jenkins (using it's default config)
```
helm template ds -f jenkins/values.yaml jenkins | oc apply -n labs-ci-cd -f -
```