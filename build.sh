#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

IMAGE_TAG="2022-10-01_01"
UPSTREAM_TAG="latest"

##BUILD COMPLETE IMAGE

#https://stackoverflow.com/a/62357213
while IFS= read -r line; do
  if [[ "$line" != \#* ]];
   then buildargs_base+=(--build-arg "$line");
  fi
done < "args_base.args"

while IFS= read -r line; do
  if [[ "$line" != \#* ]];
   then buildargs_optional+=(--build-arg "$line");
  fi
done < "args_optional.args"

docker login

#building image and pushing to private registry since it might still contain secrets/ssh keys or vulnerabilities
#https://blog.jaimyn.dev/how-to-build-multi-architecture-docker-images-on-an-m1-mac/
docker buildx build \
    --pull \
    ${buildargs_base[@]} ${buildargs_optional[@]} \
    --platform linux/amd64,linux/arm64 \
    -t ksandermann/cloud-toolbox-private:complete-$IMAGE_TAG \
    --no-cache \
    --push \
    .

#scanning private image - skipping binaries where it is known we are already using the latest available version.
#ssh keys get removed in the step they get generated
#azure-cli ssh extension triggers a false-positive string being recognized as Alibaba access token
trivy image \
    --ignore-unfixed \
    --severity HIGH,CRITICAL,MEDIUM \
    --skip-files "/usr/local/bin/helm" \
    --skip-files "/usr/local/bin/oc" \
    --skip-files "/usr/local/bin/terraform" \
    --skip-files "/usr/local/bin/kubectl" \
    --skip-files "/usr/local/bin/crictl" \
    --skip-files "/usr/local/bin/yq" \
    --skip-files "/usr/local/bin/vault" \
    --skip-files "/usr/local/bin/tcpping" \
    --skip-files "/usr/local/bin/velero" \
    --skip-files "/usr/local/bin/stern" \
    --skip-files "/usr/local/bin/sentinel" \
    --skip-files "/usr/local/bin/containerd" \
    --skip-files "/usr/local/bin/containerd-shim" \
    --skip-files "/usr/local/bin/containerd-shim-runc-v2" \
    --skip-files "/usr/local/bin/docker" \
    --skip-files "/usr/local/bin/docker-init" \
    --skip-files "/usr/local/bin/docker-proxy" \
    --skip-files "/usr/local/bin/dockerd" \
    --skip-files "/usr/local/bin/kubelogin" \
    --skip-dirs "/root/.azure/cliextensions/ssh/" \
    ksandermann/cloud-toolbox-private:complete-$IMAGE_TAG

echo "Vulnerability scan complete. Press ctrl+c to abort and not push images. Sleeping 120 seconds, then proceeding to push images"
sleep 120
echo "proceeding with pushing the images"

COMPLETE_PRIVATE_MANIFEST_DIGEST_1=$(docker manifest inspect ksandermann/cloud-toolbox-private:complete-$IMAGE_TAG | jq '.manifests[0].digest')
COMPLETE_PRIVATE_MANIFEST_DIGEST_2=$(docker manifest inspect ksandermann/cloud-toolbox-private:complete-$IMAGE_TAG | jq '.manifests[1].digest')

docker manifest create ksandermann/cloud-toolbox:complete-$IMAGE_TAG \
    --amend ksandermann/cloud-toolbox-private@$COMPLETE_PRIVATE_MANIFEST_DIGEST_1 \
    --amend ksandermann/cloud-toolbox-private@$COMPLETE_PRIVATE_MANIFEST_DIGEST_2


#remove current manifest to not ammend more images with same architecture but create a clean one
docker manifest rm ksandermann/cloud-toolbox:complete-$UPSTREAM_TAG || true
rm -rf ~/.docker/manifests/docker.io_ksandermann_cloud-toolbox*

docker manifest create ksandermann/cloud-toolbox:complete-$UPSTREAM_TAG \
    --amend ksandermann/cloud-toolbox-private@$COMPLETE_PRIVATE_MANIFEST_DIGEST_1 \
    --amend ksandermann/cloud-toolbox-private@$COMPLETE_PRIVATE_MANIFEST_DIGEST_2

docker manifest push ksandermann/cloud-toolbox:complete-$UPSTREAM_TAG

##BUILD LATEST IMAGE

#building image and pushing to private registry since it might still contain secrets/ssh keys or vulnerabilities
#https://blog.jaimyn.dev/how-to-build-multi-architecture-docker-images-on-an-m1-mac/
docker buildx build \
    --pull \
    ${buildargs_base[@]} \
    --platform linux/amd64,linux/arm64 \
    --no-cache \
    -t ksandermann/cloud-toolbox-private:$IMAGE_TAG \
    --push \
    .

#scanning private image - skipping binaries where it is known we are already using the latest available version.
#ssh keys get removed in the step they get generated
#azure-cli ssh extension triggers a false-positive string being recognized as Alibaba access token
trivy image \
    --ignore-unfixed \
    --severity HIGH,CRITICAL,MEDIUM \
    --skip-files "/usr/local/bin/helm" \
    --skip-files "/usr/local/bin/oc" \
    --skip-files "/usr/local/bin/terraform" \
    --skip-files "/usr/local/bin/kubectl" \
    --skip-files "/usr/local/bin/crictl" \
    --skip-files "/usr/local/bin/yq" \
    --skip-files "/usr/local/bin/vault" \
    --skip-files "/usr/local/bin/tcpping" \
    --skip-files "/usr/local/bin/velero" \
    --skip-files "/usr/local/bin/stern" \
    --skip-files "/usr/local/bin/sentinel" \
    --skip-files "/usr/local/bin/containerd" \
    --skip-files "/usr/local/bin/containerd-shim" \
    --skip-files "/usr/local/bin/containerd-shim-runc-v2" \
    --skip-files "/usr/local/bin/docker" \
    --skip-files "/usr/local/bin/docker-init" \
    --skip-files "/usr/local/bin/docker-proxy" \
    --skip-files "/usr/local/bin/dockerd" \
    --skip-files "/usr/local/bin/kubelogin" \
    --skip-dirs "/root/.azure/cliextensions/ssh/" \
    ksandermann/cloud-toolbox-private:$IMAGE_TAG

echo "Vulnerability scan complete. Press ctrl+c to abort and not push images. Sleeping 120 seconds, then proceeding to push images"
sleep 120
echo "proceeding with pushing the images"

PRIVATE_MANIFEST_DIGEST_1=$(docker manifest inspect ksandermann/cloud-toolbox-private:$IMAGE_TAG | jq '.manifests[0].digest')
PRIVATE_MANIFEST_DIGEST_2=$(docker manifest inspect ksandermann/cloud-toolbox-private:$IMAGE_TAG | jq '.manifests[1].digest')

docker manifest create ksandermann/cloud-toolbox:$IMAGE_TAG \
    --amend ksandermann/cloud-toolbox-private@$PRIVATE_MANIFEST_DIGEST_1 \
    --amend ksandermann/cloud-toolbox-private@$PRIVATE_MANIFEST_DIGEST_2


#remove current manifest to not ammend more images with same architecture but create a clean one
docker manifest rm ksandermann/cloud-toolbox:$UPSTREAM_TAG || true
rm -rf ~/.docker/manifests/docker.io_ksandermann_cloud-toolbox*

docker manifest create ksandermann/cloud-toolbox:$UPSTREAM_TAG \
    --amend ksandermann/cloud-toolbox-private@$PRIVATE_MANIFEST_DIGEST_1 \
    --amend ksandermann/cloud-toolbox-private@$PRIVATE_MANIFEST_DIGEST_2

docker manifest push ksandermann/cloud-toolbox:$UPSTREAM_TAG
