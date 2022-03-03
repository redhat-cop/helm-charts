# 👨‍👩‍👦‍👦 FreeIPA Chart

Installs FreeIPA server to an OpenShift cluster ready for integration with OCP Authentication. This is disabled by default but if you look at the values file you'll see how it can be configured easily. FreeIPA needs to know it's host up front along with other configurable fields for setting up the LDAP server so you must specify `app_domain` for it to work properly.

```bash
helm upgrade --install my . --namespace=ipa --set app_domain=apps.mycluster.example.com
```

FreeIPA takes some time to configure and launch the first time so be patient - or just go off and get a 🫖, that's what i did!
