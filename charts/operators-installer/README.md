# operators-installer

Installs a given list of operators either using Automatic or Manual InstallPlans. If Manual then version of operator can be controlled declarativly.

## Purpose

There is no native way to declarativly control the version of installed operators. If you set to Automatic, then operators will auto upgrade, breaking declraative, if set to Manual then human has to go manaully approve. This helm chart allows for setting to Manual but having the helm chart automatically approve the correct InstallPlan for the specific version, so as not to accidently approve a newer InstallPlan.

## Configuration

For all of the Subscription parameters see

| Parameter                                    | Default Value | Required? | Description
|----------------------------------------------|---------------|-----------|------------
| operators[].channel                          |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4latest/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1) channel.
| operators[].installPlanApproval              |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4latest/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1) installPlanApproval.
| operators[].name                             |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4latest/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1) name.
| operators[].source                           |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4latest/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1) source.
| operators[].sourceNamespace                  |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4latest/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1) sourceNamespace.
| operators[].csv                                      |               | Yes       | The CSV to install.
| operators[].installPlanVerifierRetries       | `10`          | No        | Number of times to check if the InstallPlan has actually been installed. This may need to increase of an operator takes a long time to install.
| operators[].installPlanVerifierActiveDeadlineSeconds | `120` | No        | Total amount of time that can be spent waiting for InstallPlan to finish installing. This may need to increase of an operator takes a long time to install.
| installPlanApproverAndVerifyJobsImage        | `registry.redhat.io/openshift4/ose-cli:v4.10` | Yes | Image to use for the InstallPlan Approver and Verify Jobs 
| createOperatorGroup                          | `false`       | No        | Whether or not to create an OperatorGroup in the target release namespace
| commonLabels                                 | `{}`          | No        | Common labels to add to all chart created resources. Implements the same idea from Kustomize for this chart.

## Cavieats

### ArgoCD / Red Hat OpenShift GitOps
If using this helm chart with ArgoCD / Red Hat OpenShift GitOps then you will need to patch how ArgoCD does health checks on Subscriptions by default
because the default health check will fail if there is any pending installations which is a problem for two reasons. First the approval is a post hook
(which technically it could be made an install hook, if not for reason two), secondly if installing an older version fo an operator the Subscription will
report there is a pending update, even though you dont wan't to update, and ArgoCD will constently say the Subscription is pending.

Here is a sample updated health check to use which if the InstallPlan is set to Manual then will ignore pending plan approvals with a detailed message. How you patch ArgoCD with this health check depends on your version of ArgoCD so see the docs for your version.

```lua
health_status = {}
if obj.status ~= nil then
    if obj.status.conditions ~= nil then
    numDegraded = 0
    numPending = 0
    msg = ""
    for i, condition in pairs(obj.status.conditions) do
        msg = msg .. i .. ": " .. condition.type .. " | " .. condition.status .. "\n"
        if condition.type == "InstallPlanPending" and condition.status == "True" then
        numPending = numPending + 1
        elseif (condition.type == "InstallPlanMissing" and condition.reason ~= "ReferencedInstallPlanNotFound") then
        numDegraded = numDegraded + 1
        elseif (condition.type == "CatalogSourcesUnhealthy" or condition.type == "InstallPlanFailed" or condition.type == "ResolutionFailed") and condition.status == "True" then
        numDegraded = numDegraded + 1
        end
    end
    if numDegraded == 0 and numPending == 0 then
        health_status.status = "Healthy"
        health_status.message = msg
        return health_status
    elseif numPending > 0 and numDegraded == 0 and obj.spec.installPlanApproval == "Manual" then
        health_status.status = "Healthy"
        health_status.message = "An install plan for a subscription is pending installation but install plan approval is set to manual so considering this as healthy: " .. msg
        return health_status
    elseif numPending > 0 and numDegraded == 0 then
        health_status.status = "Progressing"
        health_status.message = "An install plan for a subscription is pending installation - ian was here 1"
        return health_status
    else
        health_status.status = "Degraded"
        health_status.message = msg
        return health_status
    end
    end
end
health_status.status = "Progressing"
health_status.message = "An install plan for a subscription is pending installation - ian was here 2"
return health_status
```

### Rollbacks

This operator can not currently role operator versions back. PRs welcome.
