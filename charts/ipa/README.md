# 👨‍👩‍👦‍👦 FreeIPA Chart

Installs FreeIPA server to an OpenShift cluster ready for integration with OCP Authentication. This is disabled by default but if you look at the values (`ocp_auth` property) file you'll see how it can be configured easily. FreeIPA needs to know it's host up front along with other configurable fields for setting up the LDAP server so you must specify `app_domain` for it to work properly.

```bash
helm upgrade --install ipa . --namespace=ipa --create-namespace --set app_domain=apps.mycluster.example.com
```

FreeIPA takes some time to configure and launch the first time so be patient - or just go off and get a 🫖, that's what i did!


# Setup users

## BindDN user add required for OAuth Config to work in OCP
For the OAuth to work, you need to create a `bind_dn` user in the LDAP. This can just be the `admin` but better to use a service account in the LDAP. The default used by this chart is `ldap_admin`. This can be created once the LDAP is up and running using this one liner. Make sure the passwords match what you've set in the `ocp_auth` variable in `values.yaml`

```bash
# oc login ...
oc exec -it dc/ipa -n ipa -- \
    sh -c "echo Passw0rd123 | /usr/bin/kinit admin && \
    echo Passw0rd | \
    ipa user-add ldap_admin --first=ldap \
    --last=admin --email=ldap_admin@redhatlabs.dev --password"
```


## Testing the ldap group sync with some mickey mouse users
To demo using the ldap sync & the OAuth and pinning IPA to an infra node (assuming standard labelling) you can run to setup IPA. Follow the step above to create the bind_dn user and create the groups below to demo logins using the existing cluster roles of `admin, edit & view`

```bash
# from the charts dir
helm dep up ipa
helm upgrade --install ipa ipa  \
    --set runOnInfra=true \
    --set ocp_auth.enabled=true \
    --set app_domain=apps.my.sandbox.example.com \
    --set ldap_group_sync=true
```

1. login to ipa kerbros
```bash
oc exec -it dc/ipa -n ipa -- \
    sh -c "echo Passw0rd123 | /usr/bin/kinit admin"
```

2. Create the groups and wrapper `student` group to house both these groups
```bash
oc exec -it dc/ipa -n ipa -- \
    sh -c "ipa group-add student --desc 'wrapper group' || true && \
    ipa group-add ocp_admins --desc 'admin openshift group' || true && \
    ipa group-add ocp_devs --desc 'edit openshift group' || true && \
    ipa group-add ocp_viewers --desc 'view openshift group' || true && \
    ipa group-add-member student --groups=ocp_admins --groups=ocp_devs --groups=ocp_viewers || true"
```

3. Add dummy users to the groups
```bash
oc exec -it dc/ipa -n ipa -- \
    sh -c "echo Passw0rd | \
    ipa user-add mickey --first=mickey \
    --last=mouse --email=mmouse@redhatlabs.dev --password || true && \
    ipa group-add-member ocp_admins --users=mickey"

oc exec -it dc/ipa -n ipa -- \
    sh -c "echo Passw0rd | \
    ipa user-add minnie --first=minnie \
    --last=mouse --email=minmouse@redhatlabs.dev --password || true && \
    ipa group-add-member ocp_devs --users=minnie"

oc exec -it dc/ipa -n ipa -- \
    sh -c "echo Passw0rd | \
    ipa user-add pluto --first=pluto \
    --last=dog --email=pdog@redhatlabs.dev --password || true && \
    ipa group-add-member ocp_viewers --users=pluto"
```
