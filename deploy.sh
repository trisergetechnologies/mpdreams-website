#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="${REPO_DIR}/public_html/public_html"
DEPLOY_ROOT="/var/www/mpdreams"
LIVE_DIR="${DEPLOY_ROOT}/dist"
BACKUP_DIR="${DEPLOY_ROOT}/dist.old"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Missing source: $SOURCE_DIR" >&2
  exit 1
fi

mkdir -p "$DEPLOY_ROOT"

if [[ -d "$LIVE_DIR" ]]; then
  rm -rf "$BACKUP_DIR"
  mv "$LIVE_DIR" "$BACKUP_DIR"
fi

mkdir -p "$LIVE_DIR"
rsync -a --delete "${SOURCE_DIR}/" "${LIVE_DIR}/"

chown -R www-data:www-data "$DEPLOY_ROOT"

nginx -t
systemctl reload nginx

echo "OK: ${LIVE_DIR} (previous live -> ${BACKUP_DIR})"
