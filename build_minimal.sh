#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

IMAGE_TAG=$(date --rfc-3339=date)
TAG_PREFIX_MINIMAL="minimal"
UPSTREAM_TAG_MINIMAL="${IMAGE_TAG}_${TAG_PREFIX_MINIMAL}"

echo "removing cached images"
#remove current manifest to not ammend more images with same architecture but create a clean one
docker manifest rm ksandermann/cloud-toolbox:$TAG_PREFIX_MINIMAL || true
rm -rf ~/.docker/manifests/docker.io_ksandermann_cloud-toolbox*
#
#docker buildx build \
#    --pull \
#    --platform linux/amd64,linux/arm64 \
#    -t ksandermann/cloud-toolbox-private:$UPSTREAM_TAG_MINIMAL \
#    --no-cache \
#    --push \
#    --progress plain \
#    -f Dockerfile.minimal \
#    .

trivy image \
    --severity HIGH,CRITICAL,MEDIUM \
    ksandermann/cloud-toolbox-private:$UPSTREAM_TAG_MINIMAL

echo "Vulnerability scan complete. Press ctrl+c to abort and not push images. Sleeping 120 seconds, then proceeding to push images"
sleep 120
echo "proceeding with pushing the images"

echo "extracting image layer digests"
MINIMAL_PRIVATE_MANIFEST_DIGEST_1=$(docker manifest inspect ksandermann/cloud-toolbox-private:$UPSTREAM_TAG_MINIMAL | jq -r '.manifests[0].digest')
MINIMAL_PRIVATE_MANIFEST_DIGEST_2=$(docker manifest inspect ksandermann/cloud-toolbox-private:$UPSTREAM_TAG_MINIMAL | jq -r '.manifests[1].digest')

echo "found digest 1: $MINIMAL_PRIVATE_MANIFEST_DIGEST_1"
echo "found digest 2: $MINIMAL_PRIVATE_MANIFEST_DIGEST_2"

echo "creating image manifest with tag ksandermann/cloud-toolbox:${UPSTREAM_TAG_MINIMAL}"
docker manifest create ksandermann/cloud-toolbox:${UPSTREAM_TAG_MINIMAL} \
    --amend ksandermann/cloud-toolbox-private@${MINIMAL_PRIVATE_MANIFEST_DIGEST_1} \
    --amend ksandermann/cloud-toolbox-private@${MINIMAL_PRIVATE_MANIFEST_DIGEST_2}


echo "creating image manifest with tag ksandermann/cloud-toolbox:${TAG_PREFIX_MINIMAL}"
docker manifest create ksandermann/cloud-toolbox:${TAG_PREFIX_MINIMAL} \
    --amend ksandermann/cloud-toolbox-private@${MINIMAL_PRIVATE_MANIFEST_DIGEST_1} \
    --amend ksandermann/cloud-toolbox-private@${MINIMAL_PRIVATE_MANIFEST_DIGEST_2}


#push both images
echo "pushing images"
docker manifest push ksandermann/cloud-toolbox:$UPSTREAM_TAG_MINIMAL
docker manifest push ksandermann/cloud-toolbox:$TAG_PREFIX_MINIMAL
