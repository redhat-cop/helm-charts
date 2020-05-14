{{- define "config-nexus" }}
#!/bin/bash

# a standalone script for testing - see setup-nexus-job.yaml for embedded k8s version

NS=$(cat /run/secrets/kubernetes.io/serviceaccount/namespace)
NEXUS_USER=admin:admin123
NEXUS_URL=https://$(oc -n ${NS} get route nexus -o custom-columns=ROUTE:.spec.host --no-headers)

echo "waiting for nexus pod ready..."
oc -n ${NS} wait pod -lapp=sonatype-nexus --for=condition=Ready --timeout=300s
sleep 2

# helm hosted via rest
echo "creating helm-charts helm hosted repo"
curl -s -k -X POST "${NEXUS_URL}/service/rest/beta/repositories/helm/hosted" \
  --user "${NEXUS_USER}" \
  -H "accept: application/json" \
  -H "Content-Type: application/json" \
  -d "{ \"name\": \"helm-charts\", \"online\": true, \"storage\": { \"blobStoreName\": \"default\", \"strictContentTypeValidation\": true, \"writePolicy\": \"ALLOW\" }}"

# npm proxy
echo "creating labs-npm npm proxy"
curl -s -k -X POST "${NEXUS_URL}/service/rest/beta/repositories/npm/proxy" \
  --user "${NEXUS_USER}" \
  -H "accept: application/json" \
  -H "Content-Type: application/json" \
  -d "{ \"name\": \"labs-npm\", \"online\": true, \"storage\": { \"blobStoreName\": \"default\", \"strictContentTypeValidation\": true}, \"proxy\": { \"remoteUrl\": \"https://registry.npmjs.org\", \"contentMaxAge\": 1440, \"metadataMaxAge\": 1440 }, \"httpClient\": { \"blocked\": false, \"autoBlock\": false, \"connection\": { \"retries\": 0, \"userAgentSuffix\": \"string\", \"timeout\": 60, \"enableCircularRedirects\": false, \"enableCookies\": false}}, \"negativeCache\": { \"enabled\": false, \"timeToLive\": 1440 } }"

# disable anonymous access by not running onboarding
oc -n ${NS} exec $(oc -n ${NS} get pods -o custom-columns=NAME:.metadata.name --no-headers -lapp=sonatype-nexus) -- bash -c 'if ! grep -q "nexus.onboarding.enabled" /nexus-data/etc/nexus.properties; then echo "nexus.onboarding.enabled=false" >> /nexus-data/etc/nexus.properties; fi'

# make groovy script api active
oc -n ${NS} exec $(oc -n ${NS} get pods -o custom-columns=NAME:.metadata.name --no-headers -lapp=sonatype-nexus) -- bash -c 'if ! grep -q "nexus.scripts.allowCreation" /nexus-data/etc/nexus.properties; then echo "nexus.scripts.allowCreation=true" >> /nexus-data/etc/nexus.properties; fi'

# restart pod
echo "restarting nexus..."
oc -n ${NS} delete pod -lapp=sonatype-nexus
oc -n ${NS} wait pod -lapp=sonatype-nexus --for=condition=Ready --timeout=300s
sleep 2

# raw hosted not available on new beta rest api
echo "creating labs-static raw hosted repo"
curl -s -X POST "${NEXUS_URL}/service/rest/v1/script" \
     --user "admin:admin123" \
     -H "accept: application/json" \
     -H "Content-Type: application/json" \
     -d "{ \"name\": \"labs-static\", \"content\": \"repository.createRawHosted('labs-static', 'default')\", \"type\": \"groovy\"}"

# start repo up
curl -s -X POST -u admin:admin123 --header "Content-Type: text/plain" "${NEXUS_URL}/service/rest/v1/script/labs-static/run" > /dev/null

# disable groovy
oc -n ${NS} exec $(oc -n ${NS} get pods -o custom-columns=NAME:.metadata.name --no-headers -lapp=sonatype-nexus) -- bash -c 'if grep -q "nexus.scripts.allowCreation" /nexus-data/etc/nexus.properties; then sed -i -e "s|nexus.scripts.allowCreation=true|#nexus.scripts.allowCreation=true|g" /nexus-data/etc/nexus.properties; fi'

# restart
echo "restarting nexus..."
oc -n ${NS} delete pod -lapp=sonatype-nexus
oc -n ${NS} wait pod -lapp=sonatype-nexus --for=condition=Ready --timeout=300s

echo "Done!"
{{- end}}