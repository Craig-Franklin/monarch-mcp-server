#!/bin/sh
# Launch only an already-built, recorded image; never read secrets into arguments.
set -eu
image=${1:?Usage: run-apollo.sh IMAGE_ID APPDATA_DIRECTORY}
data=${2:?Usage: run-apollo.sh IMAGE_ID APPDATA_DIRECTORY}
case "$image" in sha256:*) ;; *) echo 'Use the recorded local image ID (sha256:...)' >&2; exit 1;; esac
[ "$(stat -c '%a' "$data")" = 700 ] || { echo 'Appdata directory must be mode 0700' >&2; exit 1; }
[ -f "$data/config/tunnel.yaml" ] && [ -s "$data/secrets/openai-runtime-key" ]
[ "$(stat -c '%a' "$data/secrets/openai-runtime-key")" = 600 ]
[ "$(stat -c '%u' "$data/secrets/openai-runtime-key")" = 10001 ]
if docker container inspect monarch-private >/dev/null 2>&1; then
    echo 'monarch-private already exists; inspect and explicitly replace it before upgrade.' >&2
    exit 1
fi
if ! docker network inspect monarch-private >/dev/null 2>&1; then
    docker network create --driver bridge monarch-private >/dev/null
fi
docker run -d --name monarch-private --network monarch-private \
    --restart unless-stopped --read-only --cap-drop ALL \
    --security-opt no-new-privileges:true --pids-limit 128 --memory 512m --cpus 1 \
    --tmpfs /tmp:rw,noexec,nosuid,size=32m \
    --env MONARCH_MCP_TRANSPORT=stdio --env MONARCH_MCP_READ_ONLY=0 \
    --mount "type=bind,src=$data/session,dst=/home/app/.monarch-mcp-server" \
    --mount "type=bind,src=$data/config,dst=/config,readonly" \
    --mount "type=bind,src=$data/secrets,dst=/run/secrets,readonly" \
    --log-driver json-file --log-opt max-size=1m --log-opt max-file=2 \
    "$image"
