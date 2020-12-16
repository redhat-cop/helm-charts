## sonatype-nexus

Chart was forked from the official sonatype nexus operator (which actually calls this chart). It uses a UBI based image set in [values.yaml](values.yaml)

```yaml
  imageName: registry.connect.redhat.com/sonatype/nexus-repository-manager:<version>
```

https://github.com/sonatype/operator-nxrm3/blob/master/helm-charts/sonatype-nexus/Chart.yaml

Features:
- nexus default admin password used
- services and route setup for openshift
- anonymouns access on by default, initial configuration turned off
- post setup k8s job to configure repositories [setup-nexus-job.yaml](templates/setup-nexus-job.yaml) suitable for labs-ci-cd in UJ (raw, helm, npm etc)

Run:
```bash
oc new-project nexus-test
helm template my -f sonatype-nexus/values.yaml sonatype-nexus/ | oc apply -f-
```

Check success of setup job:
```bash
$ stern nexus-setup-p4ddg

+ nexus-setup-p4ddg › nc
nexus-setup-p4ddg nc waiting for nexus pod ready...
nexus-setup-p4ddg nc pod/my-sonatype-nexus-58f49d48d9-2vhbz condition met
nexus-setup-p4ddg nc creating helm-charts helm hosted repo
nexus-setup-p4ddg nc creating labs-npm npm proxy
nexus-setup-p4ddg nc restarting nexus...
nexus-setup-p4ddg nc pod "my-sonatype-nexus-58f49d48d9-2vhbz" deleted
nexus-setup-p4ddg nc pod/my-sonatype-nexus-58f49d48d9-54mn8 condition met
nexus-setup-p4ddg nc creating labs-static raw hosted repo
nexus-setup-p4ddg nc restarting nexus...
nexus-setup-p4ddg nc pod "my-sonatype-nexus-58f49d48d9-54mn8" deleted
nexus-setup-p4ddg nc pod/my-sonatype-nexus-58f49d48d9-n9z8x condition met
nexus-setup-p4ddg nc Done!
```

Delete the `nexus-setup` job resources (only needed to run once)
```
oc delete job,sa -lapp=nexus-setup
oc delete rolebinding edit-0
```
