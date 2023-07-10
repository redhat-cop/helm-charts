# operators-installer

Installs a given list of operators either using Automatic or Manual InstallPlans. If Manual then version of operator can be controlled declaratively.

## Purpose

There is no native way to declaratively control the version of installed operators. If you set to Automatic, then operators will auto upgrade, breaking declarative, if set to Manual then human has to go manually approve. This helm chart allows for setting to Manual but having the helm chart automatically approve the correct InstallPlan for the specific version, so as not to accidentally approve a newer InstallPlan.

## Configuration

For all of the Subscription parameters see

| Parameter                                    | Default Value | Required? | Description
|----------------------------------------------|---------------|-----------|------------
| operators                                    | `[]`          | No        | List of operators to install.
| operators[].channel                          |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4latest/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1) channel.
| operators[].installPlanApproval              |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4latest/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1) installPlanApproval.
| operators[].name                             |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4latest/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1) name.
| operators[].source                           |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4latest/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1) source.
| operators[].sourceNamespace                  |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4latest/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1) sourceNamespace.
| operators[].csv                                      |               | Yes       | The CSV to install.
| operators[].installPlanVerifierRetries       | `10`          | No        | Number of times to check if the InstallPlan has actually been installed. This may need to increase of an operator takes a long time to install.
| operators[].installPlanVerifierActiveDeadlineSeconds | `120` | No        | Total amount of time that can be spent waiting for InstallPlan to finish installing. This may need to increase of an operator takes a long time to install.
| operators[].namespace                        | `.Release.Namespace` | No | Specify the namespace to install the operator into, which allows different operators to be installed into different namespaces from the same chart. If 
| operatorGroups                               | `[]`          | No        | Optional list of configuration for OperatorGroups. If this is not supplied then it is assumed OperatorGroups are already in place in the selected `operators[].namespace`s.
| operatorGroups[].name                        | `.Release.Namespace` | No | Name of the OperatorGroup & Namespace the OperatorGroup will be placed in.
| operatorGroups[].createNamespace             | `false`       | No        | If `true` create the Namespace of the same name of the OperatorGroup. If `false` assumed the Namespace is already in place.
| operatorGroups[].targetOwnNamespace          | `false`       | No        | If `true` add the OperatorGroup's Namespace as a `targetNamespaces`. If `true` then OperatorGroup will only work for Operators using `OwnNamespace` or `MultiNamespace` `installModes`. If blank and no `otherTargetNamespaces` specified then OperatorGroup will be configured to allow for operators using `installModes` `AllNamespaces`.
| operatorGroups[].otherTargetNamespaces       | `[]`          | No        | List of additional Namespaces to target. If specified OperatorGroup will only work for operators using `SingleNamespace` or `MultiNamespace` `installModes` depending on value of `targetOwnNamespace`.
| installPlanApproverAndVerifyJobsImage        | `registry.redhat.io/openshift4/ose-cli:v4.10` | Yes | Image to use for the InstallPlan Approver and Verify Jobs 
| approveManualInstallPlanViaHook              | `true`        | No        | `true` to create (and clean up) manual InstallPlan approval resources as part of post-install,post-upgrade helm hook<br>`false` to create  manual InstallPlan approval resources as part of normal install<br><br>The hook method is nice to not have lingering resources needed for the manual InstallPlan approval but has the downside that no CustomResources using CustomResourceDefinitions installed by the operator can be used in the same chart because the operator InstallPlan wont be approved, and therefor the operator wont be installed, until the post-install,post-upgrade phase which means you will never get to that phase because your CustomResources wont be able to apply because the Operator isn't installed.<br><br>This is is ultimately a trade off between cleaning up these resources or being able to install and configure the operator in the same helm chart that has a dependency on this helm chart.
| commonLabels                                 | `{}`          | No        | Common labels to add to all chart created resources. Implements the same idea from Kustomize for this chart.

## Caveats

### ArgoCD / Red Hat OpenShift GitOps
If using this helm chart with ArgoCD / Red Hat OpenShift GitOps then you will need to patch how ArgoCD does health checks on Subscriptions by default
because the default health check will fail if there is any pending installations which is a problem for two reasons. First the approval is a post hook
(which technically it could be made an install hook, if not for reason two), secondly if installing an older version fo an operator the Subscription will
report there is a pending update, even though you don't wan't to update, and ArgoCD will constantly say the Subscription is pending.

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
