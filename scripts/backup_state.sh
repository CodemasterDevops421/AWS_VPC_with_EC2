#!/usr/bin/env bash
set -euo pipefail

# Back up terraform state files to S3 with timestamped archives plus latest pointer.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_DIR="${STATE_DIR:-$ROOT_DIR}"
BUCKET="${BUCKET:-terraformraspberrypi5}"
PREFIX="${PREFIX:-state-backups}"
AWS_REGION="${AWS_REGION:-ap-south-1}"
# Environment label drives S3 path; defaults to dev but accepts override via first argument or ENVIRONMENT var.
ENVIRONMENT="${1:-${ENVIRONMENT:-dev}}"
TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
ARCHIVE_NAME="terraform-state-${TIMESTAMP}.tar.gz"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

log() {
  printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "ERROR: Required command '$1' not found in PATH"
    exit 1
  fi
}

require_command aws
require_command tar

# Guard against invalid environment names that would break S3 key layout
if [[ ! "${ENVIRONMENT}" =~ ^[A-Za-z0-9_-]+$ ]]; then
  log "ERROR: Environment '${ENVIRONMENT}' contains invalid characters"
  exit 1
fi

STATE_FILES=("terraform.tfstate" "terraform.tfstate.backup")
FILES_TO_ARCHIVE=()
for file in "${STATE_FILES[@]}"; do
  path="${STATE_DIR}/${file}"
  if [[ -f "${path}" ]]; then
    FILES_TO_ARCHIVE+=("${file}")
  else
    log "WARN: State file '${file}' not found at '${STATE_DIR}', skipping"
  fi
done

if [[ ${#FILES_TO_ARCHIVE[@]} -eq 0 ]]; then
  log "ERROR: No state files found to back up"
  exit 1
fi

ARCHIVE_PATH="${TMP_DIR}/${ARCHIVE_NAME}"
log "Creating archive '${ARCHIVE_NAME}'"
tar -czf "${ARCHIVE_PATH}" -C "${STATE_DIR}" "${FILES_TO_ARCHIVE[@]}"

S3_BASE="s3://${BUCKET}/${PREFIX}/${ENVIRONMENT}"
S3_ARCHIVE_URI="${S3_BASE}/${ARCHIVE_NAME}"
LATEST_STATE_URI="${S3_BASE}/latest/terraform.tfstate"

log "Uploading archive to '${S3_ARCHIVE_URI}'"
aws s3 cp "${ARCHIVE_PATH}" "${S3_ARCHIVE_URI}" \
  --region "${AWS_REGION}" \
  --sse AES256

PRIMARY_STATE_PATH="${STATE_DIR}/terraform.tfstate"
if [[ -f "${PRIMARY_STATE_PATH}" ]]; then
  log "Updating latest state object at '${LATEST_STATE_URI}'"
  aws s3 cp "${PRIMARY_STATE_PATH}" "${LATEST_STATE_URI}" \
    --region "${AWS_REGION}" \
    --sse AES256
fi

log "Backup complete"
