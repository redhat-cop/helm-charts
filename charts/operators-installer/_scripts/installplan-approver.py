#!/usr/bin/python

import os
import sys
import installplan_utils

namespace_name = os.environ["NAMESPACE"]
subscription_name = os.environ["SUBSCRIPTION"]
subscription_csv = os.environ["SUBSCRIPTION_CSV"]

print()
print("******************************")
print("* START InstallPlan Approver *")
print("******************************")

# find the subscription uid
print()
print(f"Get Subscription ({subscription_name}) UID")
subscription_uid = installplan_utils.get_subscription_uid(subscription_name)
print(f"Subscription ({subscription_name}) UID: {subscription_uid}")

# if found subscription uid find InstallPlan for given CSV with owner of the given subscription
# else error
if subscription_uid:
    # find the InstallPlan that has expected owner subscription id and expected target CSV name
    # NOTE: if more then one InstallPlan matches, choose the first one
    print(
        f"Get InstallPlan for CSV ({subscription_csv}) with Subscription (${subscription_uid}) owner"
    )
    target_install_plan = installplan_utils.get_installplan(
        namespace_name, subscription_csv, subscription_uid
    )
    # if found target InstallPlan, approve it
    # else fail
    if target_install_plan:
        target_install_plan_name = target_install_plan.model.metadata.name
        print(
            f"InstallPlan for CSV ({subscription_csv}) with Subscription ({subscription_name}) ({subscription_uid}): {target_install_plan.model.metadata.name}"
        )
        print()
        print(
            f"Current InstallPlan ({target_install_plan_name}) approval state: {target_install_plan.model.spec.approved}"
        )
        # if already approved, just notify
        # else approve
        if target_install_plan.model.spec.approved:
            print(f"InstallPlan ({target_install_plan_name}) is already approved")
        else:
            print(f"Approving InstallPlan ({target_install_plan_name})")
            target_install_plan.model.spec.approved = True
            target_install_plan.apply()
            print(f"Approved InstallPlan ({target_install_plan_name})")
        sys.exit(0)
    else:
        print()
        print(
            f"Could not find InstallPlan for CSV ${subscription_csv}) with Subscription ({subscription_name}) ({subscription_uid}) owner."
            + "\nThis can happen if InstallPlan isn't created yet. Try again."
        )
        sys.exit(1)
else:
    print()
    print(
        "Failed to get Subscription ({subscription_name}) UID. This really shouldn't happen."
    )
    sys.exit(1)
