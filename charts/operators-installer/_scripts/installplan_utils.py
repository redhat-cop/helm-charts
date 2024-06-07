#!/usr/bin/python

import openshift_client as oc


def get_subscription_uid(subscription_name: str):
    subscriptions_selector = oc.selector(
        [f"subscriptions.operators.coreos.com/{subscription_name}"]
    )
    subscription_uid = None
    if subscriptions_selector.objects():
        subscription_uid = subscriptions_selector.objects()[0].model.metadata.uid
    return subscription_uid


def get_installplan(
    namespace_name: str,
    subscription_csv: str,
    subscription_uid: str,
):
    with oc.project(namespace_name):
        # find the InstallPlan that has expected owner subscription id and expected target CSV name
        # NOTE: if more then one InstallPlan matches, choose the first one
        install_plans_selector = oc.selector(["installplan.operators.coreos.com"])
        target_install_plan = None
        for install_plan in install_plans_selector.objects():
            owner_uids = map(
                lambda owner_reference: owner_reference.uid,
                install_plan.model.metadata.ownerReferences,
            )
            if (
                subscription_csv in install_plan.model.spec.clusterServiceVersionNames
            ) and (subscription_uid in owner_uids):
                target_install_plan = install_plan
                break

    return target_install_plan
