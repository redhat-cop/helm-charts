#!/usr/bin/python

import openshift_client as oc
import semver  # assumes semver 2.13 because thats whats supported on python3.6 which is what is supported by oc tools image
import re
import time
import sys


def get_subscription(subscription_name: str):
    subscriptions_selector = oc.selector(
        [f"subscriptions.operators.coreos.com/{subscription_name}"]
    )
    subscription = None
    if subscriptions_selector.objects():
        subscription = subscriptions_selector.objects()[0]

    return subscription


def get_subscription_uid(subscription_name: str):
    """Get the Subscription UID for the given Subscription name"""
    subscription = get_subscription(subscription_name)
    if subscription:
        subscription_uid = subscription.model.metadata.uid
    return subscription_uid


def get_csv(csv_name: str):
    """Get the ClusterServiceVersion object for a given CSV name"""
    csvs_selector = oc.selector(
        [f"clusterserviceversions.operators.coreos.com/{csv_name}"]
    )
    csv = None
    if csvs_selector.objects():
        csv = csvs_selector.objects()[0]

    return csv


def get_all_installplans(
    namespace_name: str,
):
    """Get all InstallPlans in a given Namespace"""
    installplans_selector = oc.selector(["installplan.operators.coreos.com"])
    return installplans_selector.objects()


def get_installplan(
    namespace_name: str,
    csv_name: str,
    subscription_uid: str,
):
    """Get InstallPlan in a given Namespace, with a given target ClusterServiceVersion name, and a given Subscription owner"""
    with oc.project(namespace_name):
        # find the InstallPlan that has expected owner subscription id and expected target CSV name
        # NOTE: if more then one InstallPlan matches, choose the first one
        installplans = get_all_installplans(namespace_name)
        target_installplan = None
        for installplan in installplans:
            installplan_owner_uids = map(
                lambda owner_reference: owner_reference.uid,
                installplan.model.metadata.ownerReferences,
            )
            if (csv_name in installplan.model.spec.clusterServiceVersionNames) and (
                subscription_uid in installplan_owner_uids
            ):
                target_installplan = installplan
                break

    return target_installplan


def get_next_installplan(
    namespace_name: str,
    csv_name: str,
    subscription_uid: str,
):
    """Find the next InstallPlan that installs a ClusterServiceVersion that is less then or equal to the given ClusterServiceVersion name and owned by the given Subscription"""
    target_csv_name_semver = get_csv_semver(csv_name)
    with oc.project(namespace_name):
        # search each InstallPlan for the one that is owned by given subscription and has the highest CSV less then or equal to our target csv
        installplans_selector = oc.selector(["installplan.operators.coreos.com"])
        latest_installplan = None
        latest_installplan_csv_semver = None
        for installplan in installplans_selector.objects():
            installplan_owner_uids = map(
                lambda owner_reference: owner_reference.uid,
                installplan.model.metadata.ownerReferences,
            )
            # if InstallPlan owned by given subscription search its CSVs
            if subscription_uid in installplan_owner_uids:
                # searching InstallPlan's CSVs for one that is less then or equal to our target CSV and greater then any already found valid InstallPlan
                for (
                    installplan_csv
                ) in installplan.model.spec.clusterServiceVersionNames:
                    installplan_csv_semver = get_csv_semver(installplan_csv)
                    # if pending InstallPlan CSV semver is less then or equal to target subscription CSV semver and greater then last found valid pending InstallPlan
                    if (installplan_csv_semver <= target_csv_name_semver) and (
                        latest_installplan_csv_semver is None
                        or installplan_csv_semver > latest_installplan_csv_semver
                    ):
                        latest_installplan = installplan
                        latest_installplan_csv_semver = installplan_csv_semver

    return latest_installplan


def approve_installplan(installplan: oc.APIObject):
    """Approves a given install plan"""
    installplan_name = installplan.model.metadata.name
    applied_change = False
    print()
    print(
        "Approve InstallPlan:"
        + f"\n\t- name: {installplan_name}"
        + f"\n\t- CSVs: {installplan.model.spec.clusterServiceVersionNames}"
        + f"\n\t- approval state: {installplan.model.spec.approved}"
    )
    # if already approved, just notify
    # else approve
    if installplan.model.spec.approved:
        print(
            f"\t- InstallPlan ({installplan_name}) is already approved, nothing to do."
        )
        applied_change = True
    else:
        print(f"\t- Approving InstallPlan ({installplan_name})")

        # NOTE: using patch and not modify_and_apply because in some cases we get the following error:
        #
        #       Warning: resource installplans/install-kwgwp is missing the kubectl.kubernetes.io/last-applied-configuration annotation
        #       which is required by oc apply. oc apply should only be used on resources created declaratively by either
        #       oc create --save-config or oc apply. The missing annotation will be patched automatically.\nThe InstallPlan \"install-kwgwp\" is invalid:
        #       metadata.annotations: Too long: must have at most 262144 bytes\n",
        #
        # which translated means, dont do an apply, do a patch, since you wont be applying again anyway
        result = installplan.patch(
            {"spec": {"approved": True}}, strategy="merge", cmd_args=["-o=yaml"]
        )
        applied_change = result.status() == 0

        # verify change applied
        if applied_change:
            print(f"\t- Approved InstallPlan ({installplan_name})")
        else:
            print(f"\t- Failed to approve InstallPlan ({installplan_name}): {result}")

    return applied_change


def get_csv_semver(
    csv_name: str,
):
    """Get the semver section of a given ClusterServiceVersion name"""
    csv_version_regex_pattern = re.compile("[^\.]*.v?(.*)")
    csv_version = csv_version_regex_pattern.match(csv_name).group(1)
    return semver.VersionInfo.parse(csv_version)


def verify_installplan_and_csv_installed(
    installplan: oc.APIObject,
    backoffLimit: int = 1,
    delay_increment: int = 2,
):
    """Wait until a given InstallPlan and its associated ClusterServiceVersions are installed"""
    installplan_name = installplan.model.metadata.name
    print()
    print(
        "Verify InstallPlan and CSV installed:"
        + f"\n\t- InstallPlan name: {installplan_name}"
        + f"\n\t- InstallPlan CSVs: {installplan.model.spec.clusterServiceVersionNames}"
    )
    installplan_installed = False
    csvs_installed = False
    for attempt in range(backoffLimit):
        # progressively wait longer with each attempt
        time.sleep(attempt * delay_increment)

        if not installplan_installed:
            # refresh and check if installed
            installplan.refresh()
            installplan_installed = installplan.model.status.conditions.can_match(
                {
                    "type": "Installed",
                    "status": "True",
                }
            )
            if installplan_installed:
                print(
                    f"\t- Verify InstallPlan ({installplan_name}) installed attempt ({attempt} of {backoffLimit}) success, current phase: {installplan.model.status.phase}"
                )
            else:
                print(
                    f"\t- Verify InstallPlan ({installplan_name}) installed attempt ({attempt} of {backoffLimit}) failed, current phase: {installplan.model.status.phase}"
                )

        if not csvs_installed:
            for csv_name in installplan.model.spec.clusterServiceVersionNames:
                # get the CSV and check if installed
                csv = get_csv(csv_name)
                if csv:
                    csvs_installed = csv.model.status.conditions.can_match(
                        {
                            "reason": "InstallSucceeded",
                            "phase": "Succeeded",
                        }
                    )
                    if csvs_installed:
                        print(
                            f"\t- Verify CSV ({csv_name}) installed attempt ({attempt} of {backoffLimit}) success, csv is installed. Current phase: {csv.model.status.phase}"
                        )
                    else:
                        print(
                            f"\t- Verify CSV ({csv_name}) installed attempt ({attempt} of {backoffLimit}) failed, csv found but not installed. Current phase: {csv.model.status.phase}"
                        )
                else:
                    print(
                        f"\t- Verify CSV ({csv_name}) installed attempt ({attempt} of {backoffLimit}) failed, csv not found."
                    )

        sys.stdout.flush()
        if installplan_installed and csvs_installed:
            break

    return installplan_installed, csvs_installed


def success_and_exit(message: str):
    """Print success message and exit"""
    print()
    print(f"SUCCESS: {message}")
    sys.exit(0)


def error_and_exit(message: str, code: int = 1):
    """Print and error and exit"""
    print()
    print(f"ERROR: {message}")
    sys.exit(code)
