#!/usr/bin/python

import os
import sys
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

print()
print("********************************************************************")
print("* START InstallPlan approver")
print(f"*\t- NAMESPACE_NAME: {NAMESPACE_NAME}")
print(f"*\t- SUBSCRIPTION_NAME: {SUBSCRIPTION_NAME}")
print(f"*\t- CSV: {CSV}")
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
        f"Find InstallPlan in Namespace ({NAMESPACE_NAME}) for CSV ({CSV}) with Subscription (${subscription_uid}) owner"
    )
    target_installplan = installplan_utils.get_installplan(
        NAMESPACE_NAME, CSV, subscription_uid
    )

    # if found target InstallPlan, approve it, and success exit
    # else fail
    if target_installplan:
        print(f"\t- Found InstallPlan: {target_installplan.model.metadata.name}")
        installplan_utils.approve_installplan(target_installplan)
        sys.exit(0)
    else:
        print()
        print(
            f"ERROR: Could not find next InstallPlan to reach CSV ${CSV}) with Subscription ({SUBSCRIPTION_NAME}) ({subscription_uid}) owner."
            + "\nThis can happen if InstallPlan isn't created yet or no valid upgrade path between current CSV and target CSV."
            + "\nTry again."
        )
        sys.exit(1)
else:
    print()
    print(
        f"ERROR: Failed to get Subscription ({SUBSCRIPTION_NAME}) UID. This really shouldn't happen."
    )
    sys.exit(1)
