#!/bin/bash

OLM_VERSION='v0.41.0'
LOCAL_REGISTRY_USER='registryuser1'
LOCAL_REGISTRY_PASSWORD='registrypassword1'
LOCAL_REGISTRY_URI='registry.localhost'
LOCAL_REGISTRY_IMAGES='quay.io/openshift/origin-cli:4.15'
CLUSTER_NAME='chart-testing'

echo
echo "Determine if kind cluster already exists 🔎"
kind get clusters | grep ${CLUSTER_NAME}
kind_cluster_exists=$?

if [ ${kind_cluster_exists} -eq 0 ]; then
  echo
  echo "Kind cluster already exists"
else
  echo
  echo "Setup kind cluster 🧰"
  kind create cluster --name ${CLUSTER_NAME} --config kind-config.yaml || exit 1
fi

echo
echo "Setup kind cluster - Install OLM 🧰"
if kubectl get deployment olm-operator -n olm > /dev/null 2>&1; then
  echo "OLM already installed"
else
  curl -L https://github.com/operator-framework/operator-lifecycle-manager/releases/download/${OLM_VERSION}/install.sh -o olm-install.sh || exit 1
  chmod +x olm-install.sh
  ./olm-install.sh ${OLM_VERSION}
  rm -f ./olm-install.sh
fi

echo
echo "Setup kind cluster - Install ingress controller 🧰"
helm repo add haproxy-ingress https://haproxy-ingress.github.io/charts
helm upgrade --install haproxy-ingress haproxy-ingress/haproxy-ingress \
    --create-namespace --namespace=ingress-controller \
    --set controller.hostNetwork=true \
    || exit 1

echo
echo "Setup kind cluster - Configure ingress controller 🧰"
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: haproxy
  annotations:
    ingressclass.kubernetes.io/is-default-class: 'true'
spec:
  controller: haproxy-ingress.github.io/controller
EOF

echo
echo "Setup kind cluster - create expected namespaces 🧰"
kubectl create namespace openshift-operators

echo
echo "Setup kind cluster - install private registry 🧰"
helm upgrade --install private-registry private-registry \
    --namespace registry \
    --create-namespace \
    --wait \
    --set registryUser=${LOCAL_REGISTRY_USER} \
    --set registryPassword=${LOCAL_REGISTRY_PASSWORD} \
    --set registryIngressHost=${LOCAL_REGISTRY_URI} \
    || exit 1

echo
echo "Setup kind cluster - Copy images into private registry 🔺"
for image in ${LOCAL_REGISTRY_IMAGES}; do
    image_name_regex='.*\/(.*$)'
    if [[ "${image}" =~ ${image_name_regex} ]]; then
        image_name="${BASH_REMATCH[1]}"
        remote_image="docker://${image}"
        local_image="docker://${LOCAL_REGISTRY_URI}/${image_name}"

        echo "Copy image (${remote_image}) to local registry (${local_image})"
        skopeo copy \
          --dest-creds ${LOCAL_REGISTRY_USER}:${LOCAL_REGISTRY_PASSWORD} \
          --dest-tls-verify=false \
          ${remote_image} \
          ${local_image} \
	  || exit 1
    else
        echo "ERROR: parsing image name from source image uri: ${image}"
        exit 1
    fi
done

echo
echo "Setup kind cluster - Add the registry config to the nodes 🧰"
REGISTRY_DIR="/etc/containerd/certs.d/${LOCAL_REGISTRY_URI}"
for node in $(kind get nodes -n "${CLUSTER_NAME}"); do
    podman exec "${node}" mkdir -p "${REGISTRY_DIR}"
    cat <<EOF | podman exec -i "${node}" cp /dev/stdin "${REGISTRY_DIR}/hosts.toml"
[host."http://${LOCAL_REGISTRY_URI}"]
EOF
done
