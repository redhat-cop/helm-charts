#!/usr/bin/python

import os
import sys
import installplan_utils
import time

NAMESPACE_NAME = os.getenv("NAMESPACE") or installplan_utils.error_and_exit(
    "env is missing expected value: NAMESPACE", 2
)
SUBSCRIPTION_NAME = os.getenv("SUBSCRIPTION") or installplan_utils.error_and_exit(
    "env is missing expected value: SUBSCRIPTION", 2
)
CSV = os.getenv("CSV") or installplan_utils.error_and_exit(
    "env is missing expected value: CSV", 2
)
INCREMENTAL_INSTALL_BACKOFF_LIMIT = (
    int(os.getenv("INCREMENTAL_INSTALL_BACKOFF_LIMIT")) or 10
)
INCREMENTAL_INSTALL_DELAY_INCREMENT = (
    int(os.getenv("INCREMENTAL_INSTALL_DELAY_INCREMENT")) or 5
)


print()
print("********************************************************************")
print("* START InstallPlan approver including intermediates")
print(f"*\t- NAMESPACE_NAME: {NAMESPACE_NAME}")
print(f"*\t- SUBSCRIPTION_NAME: {SUBSCRIPTION_NAME}")
print(f"*\t- CSV: {CSV}")
print(f"*\t- INCREMENTAL_INSTALL_BACKOFF_LIMIT: {INCREMENTAL_INSTALL_BACKOFF_LIMIT}")
print(
    f"*\t- INCREMENTAL_INSTALL_DELAY_INCREMENT: {INCREMENTAL_INSTALL_DELAY_INCREMENT}"
)
print("********************************************************************")

# find the subscription uid
print()
print(f"Get Subscription ({SUBSCRIPTION_NAME}) UID")
subscription_uid = installplan_utils.get_subscription_uid(SUBSCRIPTION_NAME)
print(f"\t- Subscription ({SUBSCRIPTION_NAME}) UID: {subscription_uid}")

# if found subscription uid incrementally find, approve, and verify the next InstallPlan for given CSV with owner of the given subscription
# until reaching the desired Subscription CSV
# else error
if subscription_uid:
    print(
        f"Find and approve every InstallPlan between currently installed CSV and target CSV ({CSV})"
    )
    target_installplan = None
    installed_installplans = []
    attempt = 0
    while (target_installplan is None) or (
        CSV not in target_installplan.model.spec.clusterServiceVersionNames
    ):
        # find the next InstallPlan that has expected owner subscription id and expected target CSV name
        print(
            f"\nFind next InstallPlan in Namespace ({NAMESPACE_NAME}) for CSV ({CSV}) with Subscription ({subscription_uid}) owner"
        )
        target_installplan = installplan_utils.get_next_installplan(
            NAMESPACE_NAME, CSV, subscription_uid
        )

        # if found next InstallPlan, approve it
        # else fail
        if target_installplan:
            target_installplan_name = target_installplan.model.metadata.name
            # if target install plan is not one we have already approved, then approve it
            # else wait and loop for next InstallPlan that installs a CSV less then or equal to our target CSV
            if target_installplan.model.metadata.name not in map(
                lambda approved_install_plan: approved_install_plan.model.metadata.name,
                installed_installplans,
            ):
                attempt = 0
                print(
                    f"\t- Found next InstallPlan: {target_installplan.model.metadata.name}"
                )

                installplan_approved = installplan_utils.approve_installplan(
                    target_installplan
                )
                # if InstallPlan approved
                # else unrecoverable error
                if installplan_approved:
                    installplan_installed, csvs_installed = (
                        installplan_utils.verify_installplan_and_csv_installed(
                            target_installplan,
                            INCREMENTAL_INSTALL_BACKOFF_LIMIT,
                            INCREMENTAL_INSTALL_DELAY_INCREMENT,
                        )
                    )

                    # if InstallPlan and all target CSVs installed
                    # else unrecoverable error
                    if installplan_installed and csvs_installed:
                        installed_installplans.append(target_installplan)
                    else:
                        error_message = "Unrecoverable unexpected issue with unknown resolution, see logs.\n"
                        if not installplan_installed:
                            error_message += f"InstallPlan ({target_installplan_name}) failed to install: {target_installplan}\n"
                        if not csvs_installed:
                            csvs = []
                            for csv_name in (
                                target_installplan.model.spec.clusterServiceVersionNames
                            ):
                                csvs += installplan_utils.get_csv(csv_name)
                            error_message += f"InstallPlan ({target_installplan_name}) failed to install some/all target ClusterServiceVersions: {csvs}"

                        installplan_utils.error_and_exit(error_message)
                else:
                    installplan_utils.error_and_exit(
                        f"Unrecoverable unexpected issue with unknown resolution, see logs. Failed to approve InstallPlan ({target_installplan_name}): {target_installplan.as_dict()}"
                    )
            else:
                attempt += 1
                # let everyone know what InstallPlans are currently available
                print("\t- Currently available InstallPlans:")
                for available_installplan in installplan_utils.get_all_installplans(
                    NAMESPACE_NAME
                ):
                    print(
                        f"\t\t-- {available_installplan.model.metadata.name} - {available_installplan.model.spec.clusterServiceVersionNames}: {available_installplan.model.status.phase}"
                    )

                # if attempts left, do another loop waiting for target InstallPlan to appear
                if attempt <= INCREMENTAL_INSTALL_BACKOFF_LIMIT:
                    delay = attempt * INCREMENTAL_INSTALL_DELAY_INCREMENT
                    print(
                        f"\t- Attempt ({attempt} of {INCREMENTAL_INSTALL_BACKOFF_LIMIT}) waiting ({delay} seconds) for next unapproved InstallPlan including target CSV less then or equal to be created. Target CSV: {CSV}"
                    )
                    sys.stdout.flush()
                    time.sleep(delay)
                else:
                    installplan_utils.error_and_exit(
                        f"Timed out waiting for next unapproved InstallPlan including target CSV less then or equal to be created. Target CSV: {CSV}",
                        1,
                    )
        else:
            installplan_utils.error_and_exit(
                f"Could not find next InstallPlan to reach CSV {CSV}) with Subscription ({SUBSCRIPTION_NAME}) ({subscription_uid}) owner."
                + "\nThis can happen if InstallPlan isn't created yet or no valid upgrade path between current CSV and target CSV."
                + "\nTry again.",
                1,
            )

    # report success
    success_message = f"Successfully installed target CSV ({CSV}) installed, approved intermediate InstallPlans include:"
    for approved_install_plan in installed_installplans:
        success_message += f"\t- {approved_install_plan.model.metadata.name}: {approved_install_plan.model.spec.clusterServiceVersionNames}"
    installplan_utils.success_and_exit(success_message)
else:
    installplan_utils.error_and_exit(
        f"Failed to get Subscription ({SUBSCRIPTION_NAME}) UID. This really shouldn't happen."
    )
