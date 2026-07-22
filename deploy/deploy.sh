#!/usr/bin/env bash
# Deploy tg-spam bots to /opt/bot_antispam on OVH VPS.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${BOT_ANTISPAM_CONFIG_DIR:-/opt/bot_antispam}"
ENV_FILE="${BOT_ANTISPAM_ENV:-${CONFIG_DIR}/.env}"
COMPOSE="${DOCKER_COMPOSE:-docker compose}"
IMAGE="${TGSPAM_IMAGE:-ghcr.io/qa-guru/tg-spam:latest}"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "Missing ${ENV_FILE}" >&2
  echo "Copy deploy/.env.example → ${ENV_FILE} and fill bot tokens." >&2
  exit 1
fi

mkdir -p "${CONFIG_DIR}/log/qa-guru" "${CONFIG_DIR}/log/automation" \
         "${CONFIG_DIR}/var/qa-guru" "${CONFIG_DIR}/var/automation"

install -m 644 "${SCRIPT_DIR}/docker-compose.yml" "${CONFIG_DIR}/docker-compose.yml"

echo "=== pull ${IMAGE} ==="
if ! docker pull "${IMAGE}" 2>/dev/null; then
  echo "Pull failed (GHCR may be private) — building from qa-guru/tg-spam source"
  BUILD_DIR="${HOME}/tg-spam-build"
  if [[ ! -d "${BUILD_DIR}/.git" ]]; then
    git clone --depth 1 https://github.com/qa-guru/tg-spam.git "${BUILD_DIR}"
  else
    git -C "${BUILD_DIR}" fetch origin master && git -C "${BUILD_DIR}" reset --hard origin/master
  fi
  docker build -t "${IMAGE}" "${BUILD_DIR}"
fi

echo "=== up (preserve var/ and log/) ==="
cd "${CONFIG_DIR}"
TGSPAM_IMAGE="${IMAGE}" ${COMPOSE} --env-file "${ENV_FILE}" up -d --remove-orphans

echo "=== status ==="
TGSPAM_IMAGE="${IMAGE}" ${COMPOSE} --env-file "${ENV_FILE}" ps

echo "Deploy complete."
