# operators-installer

Installs a given list of operators either using Automatic or Manual InstallPlans. If Manual then version of operator can be controlled declaratively.

- [Purpose](#purpose)
- [Configuration](#configuration)
- [Warnings](#warnings)
  * [Can not install / upgrade different operators in same namespace independently](#can-not-install--upgrade-different-operators-in-same-namespace-independently)
  * [ArgoCD / Red Hat OpenShift GitOps Sync Status and Health Checks](#argocd--red-hat-openshift-gitops-sync-status-and-health-checks)
- [Caveats](#caveats)
  * [Rollbacks](#rollbacks)

## Purpose

There is no native way to declaratively control the version of installed operators. If you set to Automatic, then operators will auto upgrade, breaking declarative, if set to Manual then human has to go manually approve. This helm chart allows for setting to Manual but having the helm chart automatically approve the correct InstallPlan for the specific version, so as not to accidentally approve a newer InstallPlan.

## Configuration

For all of the Subscription parameters see

| Parameter                                    | Default Value | Required? | Description
|----------------------------------------------|---------------|-----------|------------
| operators                                    | `[]`          | No        | List of operators to install.
| operators[].channel                          |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4.14/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1.html#spec) channel.
| operators[].installPlanApproval              |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4.14/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1.html#spec) installPlanApproval.
| operators[].name                             |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4.14/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1.html#spec) name.
| operators[].source                           |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4.14/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1.html#spec) source.
| operators[].sourceNamespace                  |               | Yes       | [Subscription](https://docs.openshift.com/container-platform/4.14/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1.html#spec) sourceNamespace.
| operators[].config                           |               | No        | [Subscription](https://docs.openshift.com/container-platform/4.14/rest_api/operatorhub_apis/subscription-operators-coreos-com-v1alpha1.html#spec-config) config.
| operators[].csv                              |               | Yes       | The CSV to install.
| operators[].installPlanApproverRetries       | `10`          | No        | Number of times to try to approve the InstallPlan. This may need to be increased for unpredictable reasons about some clusters taking longer to create InstallPlans.
| operators[].installPlanApproverActiveDeadlineSeconds | None  | No        | Total amount of time that can be spent waiting for InstallPlan to be approved. If having issues with InstallPlans never finishing to install and thus approval job getting infinity stuck, set this to some reasonable number. But, keep in mind if `automaticIntermediateManualUpgrades` is `true` then it can take a while to increment through a bunch of intermediate installs on the way to the specified `csv` if an old `csv` is already installed.
| operators[].installPlanVerifierRetries       | `10`          | No        | Number of times to check if the InstallPlan has actually been installed. This may need to increase of an operator takes a long time to install.
| operators[].installPlanVerifierActiveDeadlineSeconds | None  | No        | Total amount of time that can be spent waiting for InstallPlan to finish installing. This may need to increase of an operator takes a long time to install. If having issues with InstallPlans never finishing to install and thus verify job getting infinity stuck, set this to some reasonable number. But, keep in mind if `automaticIntermediateManualUpgrades` is `true` then it can take a while to increment through a bunch of intermediate installs on the way to the specified `csv` if an old `csv` is already installed.
| operators[].namespace                        | `.Release.Namespace` | No | Specify the namespace to install the operator into, which allows different operators to be installed into different namespaces from the same chart.
| operators[].automaticIntermediateManualUpgrades | `false`     |           | If `true` and `installPlanApproval` is `Manual` and there are required intermediate upgrades between the currently installed `csv` and the specified `csv`, automatically inclemently install those intermediate versions until reaching the specified `csv`. If `false` and there are required intermediate upgrades then chart will fail.
| operators[].automaticIntermediateManualUpgradesIncrementalInstallBackoffLimit   | `10` | No | When `automaticIntermediateManualUpgrades` is `true`, the number of retries for installing and then then verifying each incremental install
| operators[].automaticIntermediateManualUpgradesIncrementalInstallDelayIncrement | `5`  | No | When `automaticIntermediateManualUpgrades` is `true`, the delay increment to scale by attempts to wait between each retry of installing or  verifying each incremental install
| operatorGroups                               | `[]`          | No        | Optional list of configuration for OperatorGroups. If this is not supplied then it is assumed OperatorGroups are already in place in the selected `operators[].namespace`s.
| operatorGroups[].name                        | `.Release.Namespace` | No | Name of the OperatorGroup & Namespace the OperatorGroup will be placed in.
| operatorGroups[].createNamespace             | `false`       | No        | If `true` create the Namespace of the same name of the OperatorGroup. If `false` assumed the Namespace is already in place.
| operatorGroups[].targetOwnNamespace          | `false`       | No        | If `true` add the OperatorGroup's Namespace as a `targetNamespaces`. If `true` then OperatorGroup will only work for Operators using `OwnNamespace` or `MultiNamespace` `installModes`. If blank and no `otherTargetNamespaces` specified then OperatorGroup will be configured to allow for operators using `installModes` `AllNamespaces`.
| operatorGroups[].otherTargetNamespaces       | `[]`          | No        | List of additional Namespaces to target. If specified OperatorGroup will only work for operators using `SingleNamespace` or `MultiNamespace` `installModes` depending on value of `targetOwnNamespace`.
| installPlanApproverAndVerifyJobsImage        | `registry.redhat.io/openshift4/ose-cli:v4.10` | Yes | Image to use for the InstallPlan Approver and Verify Jobs
| installPlanApproverAndVerifyJobsImagePullSecret   | `''` | No | Name of existing secret for pulling `installPlanApproverAndVerifyJobsImage` from a private registry
| approveManualInstallPlanViaHook              | `true`        | No        | `true` to create (and clean up) manual InstallPlan approval resources as part of post-install,post-upgrade helm hook<br>`false` to create  manual InstallPlan approval resources as part of normal install<br><br>The hook method is nice to not have lingering resources needed for the manual InstallPlan approval but has the downside that no CustomResources using CustomResourceDefinitions installed by the operator can be used in the same chart because the operator InstallPlan wont be approved, and therefor the operator wont be installed, until the post-install,post-upgrade phase which means you will never get to that phase because your CustomResources wont be able to apply because the Operator isn't installed.<br><br>This is is ultimately a trade off between cleaning up these resources or being able to install and configure the operator in the same helm chart that has a dependency on this helm chart.
| installRequiredPythonLibraries               | `true`        | No        | If `true`, install the required Python libraries (openshift-client, semver==2.13.0) dynamically from the given `pythonIndexURL` and `pythonExtraIndexURL` into the `installPlanApproverAndVerifyJobsImage` at run time
| pythonIndexURL                               | https://pypi.org/simple/ | No | If `installRequiredPythonLibraries` is `true` then use this python index to pull required libraries
| pythonExtraIndexURL                          | https://pypi.org/simple/ | No | If `installRequiredPythonLibraries` is `true` then use this python extra index to pull required library dependencies
| commonLabels                                 | `{}`          | No        | Common labels to add to all chart created resources. Implements the same idea from Kustomize for this chart.
| global.commonLabels                          | `{}`          | No        | Common labels coming from global values to add to all chart created resources. Implements the same idea from Kustomize for this chart.

## Warnings

### Disconnected Use
If wanting use this chart in a disconnected environment you need to either:

#### Option 1: local python index
Set the `pythonIndexURL` and `pythonExtraIndexURL` values to a local disconnected python index that minimally includes (and their dependencies):
* openshift-client
* semver==2.13.0

#### Option 2: custom `installPlanApproverAndVerifyJobsImage` with required dependencies
Build a custom container image with:
* binary - `oc`
* python lib - `openshift-client`
* python lib - `semver==2.13.0`

Suggestion is to build such an image on top of the latest `registry.redhat.io/openshift4/ose-cli` image

Then provide that custom image to `installPlanApproverAndVerifyJobsImage` and set `installRequiredPythonLibraries` to false.

### Can not install / upgrade different operators in same namespace independently
As documented in [How can Operators be updated independently from each other?](https://access.redhat.com/solutions/6389681) when more then one operator install or update is pending in the same namespace the Operator Lifecycle Manager (OLM) will combine those installs/updates into a single InstallPlan and there is no way to separate them. Therefor if you use this helm chart in namespace ZZZ to install operator A at v1.0 and it has a pending update to v1.1 and then update the configuration to also install operator B at v42.0 in namespace ZZZ the ZZZ v42.0 InstallPlan and the A v1.1 InstallPlan will get merged (by OLM) and this helm chart will then approve that InstallPlan as it will match on the ZZZ v42.0 pending install, which will incidentally install the A v1.1 update.

There is no way for this or any helm chart, automation, or even click ops to prevent this, as documented in [How can Operators be updated independently from each other?](https://access.redhat.com/solutions/6389681) this is currently considered "a feature of OLM".

Therefor if you do not want this unintentional behavior, which these helm chart righters assume you don't since you are going to the trouble of declaratively controlling your operator versions, your only current option is to only have one operator installed per namespace, which primarily means don't use the `openshift-operators` namespace, or if you do, only use it for one operator, maybe OpenShift GitOps (ArgoCD).


### ArgoCD / Red Hat OpenShift GitOps Sync Status and Health Checks
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
        health_status.message = "An install plan for a subscription is pending installation"
        return health_status
    else
        health_status.status = "Degraded"
        health_status.message = msg
        return health_status
    end
end
return health_status
```

## Caveats

### Rollbacks

This helm chart can not currently role operator versions back. PRs welcome.
