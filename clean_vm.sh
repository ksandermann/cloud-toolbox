#!/usr/bin/env bash
# Reclaim disk space on the self-hosted runner.
# Safe to run any time: everything removed is regenerable (build cache,
# dangling images, stopped containers, scanner caches). The runner install
# and its config are never touched.
set -uo pipefail

echo "=== Disk before cleanup ==="
df -h /

# 1) Prune EVERY buildx builder's cache, not just the default one.
#    The persistent "toolbox0" builder is the main space hog and is NOT
#    covered by a plain "docker buildx prune -af".
for builder in $(docker buildx ls --format '{{.Name}}' 2>/dev/null | awk 'NF'); do
  echo "=== Pruning buildx builder: ${builder} ==="
  docker buildx prune -af --builder "${builder}" || true
done

# 2) Fallback: prune cache directly inside any running buildkit container
#    (catches builders that aren't listed by "docker buildx ls").
for c in $(docker ps --filter 'name=buildx_buildkit' --format '{{.Names}}' 2>/dev/null); do
  echo "=== buildctl prune in container: ${c} ==="
  docker exec "${c}" buildctl prune --all || true
done

# 3) Remove dangling images and stopped containers.
docker image     prune -af || true
docker container prune -f   || true

# 4) Trivy vulnerability-DB cache (re-downloads on next scan).
rm -rf "${HOME}/.cache/trivy"/* 2>/dev/null || true

echo "=== Disk after cleanup ==="
df -h /
