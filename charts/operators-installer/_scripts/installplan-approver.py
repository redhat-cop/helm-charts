#!/usr/bin/python

import os
import installplan_utils

NAMESPACE_NAME = os.getenv("NAMESPACE") or installplan_utils.error_and_exit(
    "env is missing expected value: NAMESPACE", 2
)
SUBSCRIPTION_NAME = os.getenv("SUBSCRIPTION") or installplan_utils.error_and_exit(
    "env is missing expected value: SUBSCRIPTION", 2
)
CSV = os.getenv("CSV") or installplan_utils.error_and_exit(
    "env is missing expected value: CSV", 2
)
INSTALLPLAN_SEARCH_RETRIES = int(
    os.getenv("INSTALLPLAN_SEARCH_RETRIES", "10")
)
INSTALLPLAN_SEARCH_DELAY_SECONDS = int(
    os.getenv("INSTALLPLAN_SEARCH_DELAY_SECONDS", "5")
)

print()
print("********************************************************************")
print("* START InstallPlan approver")
print(f"*\t- NAMESPACE_NAME: {NAMESPACE_NAME}")
print(f"*\t- SUBSCRIPTION_NAME: {SUBSCRIPTION_NAME}")
print(f"*\t- CSV: {CSV}")
print(f"*\t- INSTALLPLAN_SEARCH_RETRIES: {INSTALLPLAN_SEARCH_RETRIES}")
print(f"*\t- INSTALLPLAN_SEARCH_DELAY_SECONDS: {INSTALLPLAN_SEARCH_DELAY_SECONDS}")
print("********************************************************************")

# find the subscription uid
print()
print(f"Get Subscription ({SUBSCRIPTION_NAME}) UID")
subscription_uid = installplan_utils.get_subscription_uid(SUBSCRIPTION_NAME)
print(f"\t- Subscription ({SUBSCRIPTION_NAME}) UID: {subscription_uid}")

# if found subscription uid find InstallPlan for given CSV with owner of the given subscription
# else error
if subscription_uid:
    # find the InstallPlan that has expected owner subscription id and expected target CSV name
    # NOTE: if more then one InstallPlan matches, choose the first one
    print(
        f"Find InstallPlan in Namespace ({NAMESPACE_NAME}) for CSV ({CSV}) with Subscription ({subscription_uid}) owner"
    )
    target_installplan = installplan_utils.wait_for_installplan(
        lambda: installplan_utils.get_installplan(
            NAMESPACE_NAME,
            CSV,
            subscription_uid,
        ),
        INSTALLPLAN_SEARCH_RETRIES,
        INSTALLPLAN_SEARCH_DELAY_SECONDS,
    )

    # if found target InstallPlan, approve it, and success exit
    # else fail
    if target_installplan:
        print(f"\t- Found InstallPlan: {target_installplan.model.metadata.name}")
        installplan_approved = installplan_utils.approve_installplan(target_installplan)
        if installplan_approved:
            installplan_utils.success_and_exit(
                "InstallPlan ({target_installplan}) approved"
            )
        else:
            installplan_utils.error_and_exit(
                "ERROR: Failed to approve InstallPlan ({target_installplan})"
                + "\nThis is typically an unrecoverable error due to an API call issue."
                + "\nUnknown resolution at this time, more examples needed, please submit issue with any details"
            )
    else:
        installplan_utils.error_and_exit(
            f"Could not find InstallPlan for CSV ({CSV}) "
            f"with Subscription ({SUBSCRIPTION_NAME}) "
            f"({subscription_uid}) owner after "
            f"{INSTALLPLAN_SEARCH_RETRIES} attempts."
            + "\nThis can happen if the InstallPlan wasn't created within "
            "the configured retry period or no valid upgrade path exists "
            "between the current CSV and target CSV.",
            1,
        )
else:
    installplan_utils.error_and_exit(
        f"ERROR: Failed to get Subscription ({SUBSCRIPTION_NAME}) UID. This really shouldn't happen."
    )
