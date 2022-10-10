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
    sh -c "echo Passw0rd123 | /usr/bin/kinit admin"

oc exec -it dc/ipa -n ipa -- \
    sh -c "echo Passw0rd | \
    ipa user-add ldap_admin --first=ldap \
    --last=admin --email=ldap_admin@redhatlabs.dev --password"
```
