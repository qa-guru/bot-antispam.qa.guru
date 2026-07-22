#!/usr/bin/env bash
# Smoke: both containers running and logs show recent activity.
set -euo pipefail

CONFIG_DIR="${BOT_ANTISPAM_CONFIG_DIR:-/opt/bot_antispam}"
COMPOSE="${DOCKER_COMPOSE:-docker compose}"

cd "${CONFIG_DIR}"
running=$(${COMPOSE} ps --status running --services | wc -l | tr -d ' ')
if [[ "${running}" -lt 2 ]]; then
  echo "Expected 2 running services, got ${running}" >&2
  ${COMPOSE} ps >&2
  exit 1
fi

for c in bot_antispam-tg-spam-qa-guru-1 bot_antispam-tg-spam-automation-1; do
  if ! docker inspect -f '{{.State.Running}}' "$c" 2>/dev/null | grep -q true; then
    echo "Container not running: $c" >&2
    exit 1
  fi
  echo "OK $c"
done

echo "Smoke passed."
