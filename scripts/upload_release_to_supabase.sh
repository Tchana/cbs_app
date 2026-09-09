#!/usr/bin/env bash
set -euo pipefail

# Uploads CBS release artifacts to Supabase Storage (public read).
# Requires env: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY

SUPABASE_URL="${SUPABASE_URL:?SUPABASE_URL is required}"
if [ -z "${SUPABASE_SERVICE_ROLE_KEY:-}" ]; then
  echo "SUPABASE_SERVICE_ROLE_KEY is required." >&2
  echo "Set GitHub secret: Settings → Secrets and variables → Actions → SUPABASE_SERVICE_ROLE_KEY" >&2
  echo "Value from: Supabase Dashboard → Project Settings → API → service_role key" >&2
  exit 1
fi

BUCKET="app-releases"
DIST_DIR="${1:-dist}"
VERSION="${2:-}"
AUTH_HEADER="Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}"
APIKEY_HEADER="apikey: ${SUPABASE_SERVICE_ROLE_KEY}"

if [ ! -d "$DIST_DIR" ]; then
  echo "Dist directory not found: $DIST_DIR" >&2
  exit 1
fi

ensure_bucket() {
  local check_file
  local http_code
  local create_file
  local create_code

  echo "Checking bucket '${BUCKET}'..."
  check_file="$(mktemp)"
  http_code="$(
    curl -sS -o "${check_file}" -w "%{http_code}" \
      "${SUPABASE_URL}/storage/v1/bucket/${BUCKET}" \
      -H "${AUTH_HEADER}" \
      -H "${APIKEY_HEADER}"
  )"

  if [[ "${http_code}" -ge 200 && "${http_code}" -lt 300 ]]; then
    echo "Bucket OK."
    rm -f "${check_file}"
    return 0
  fi

  echo "Bucket missing (HTTP ${http_code}); creating '${BUCKET}'..."
  cat "${check_file}" || true
  echo
  rm -f "${check_file}"

  create_file="$(mktemp)"
  create_code="$(
    curl -sS -o "${create_file}" -w "%{http_code}" -X POST \
      "${SUPABASE_URL}/storage/v1/bucket" \
      -H "${AUTH_HEADER}" \
      -H "${APIKEY_HEADER}" \
      -H "Content-Type: application/json" \
      -d "{\"id\":\"${BUCKET}\",\"name\":\"${BUCKET}\",\"public\":true}"
  )"

  if [[ "${create_code}" -lt 200 || "${create_code}" -ge 300 ]]; then
    echo "Failed to create bucket '${BUCKET}' (HTTP ${create_code}):" >&2
    cat "${create_file}" >&2
    echo >&2
    rm -f "${create_file}"
    exit 1
  fi

  echo "Bucket created."
  cat "${create_file}"
  echo
  rm -f "${create_file}"

  update_file="$(mktemp)"
  update_code="$(
    curl -sS -o "${update_file}" -w "%{http_code}" -X PUT \
      "${SUPABASE_URL}/storage/v1/bucket/${BUCKET}" \
      -H "${AUTH_HEADER}" \
      -H "${APIKEY_HEADER}" \
      -H "Content-Type: application/json" \
      -d '{"public":true,"fileSizeLimit":52428800}'
  )"
  if [[ "${update_code}" -ge 200 && "${update_code}" -lt 300 ]]; then
    echo "Bucket file size limit set to 50MB (Free-plan safe default)."
  else
    echo "Warning: could not set bucket file size limit (HTTP ${update_code}):"
    cat "${update_file}" || true
    echo
  fi
  rm -f "${update_file}"
}

upload_file() {
  local source_path="$1"
  local dest_path="$2"
  local content_type="$3"
  local response_file
  local http_code
  local size_bytes
  local size_mb

  size_bytes="$(wc -c < "${source_path}" | tr -d ' ')"
  size_mb="$(awk "BEGIN { printf \"%.2f\", ${size_bytes}/1024/1024 }")"
  echo "Uploading ${dest_path} (${size_mb} MB)..."
  response_file="$(mktemp)"
  http_code="$(
    curl -sS -o "${response_file}" -w "%{http_code}" -X POST \
      "${SUPABASE_URL}/storage/v1/object/${BUCKET}/${dest_path}" \
      -H "${AUTH_HEADER}" \
      -H "${APIKEY_HEADER}" \
      -H "Content-Type: ${content_type}" \
      -H "x-upsert: true" \
      --data-binary @"${source_path}"
  )"

  if [[ "${http_code}" -lt 200 || "${http_code}" -ge 300 ]]; then
    echo "Upload failed for ${dest_path} (HTTP ${http_code}):" >&2
    cat "${response_file}" >&2
    echo >&2
    if grep -qi 'EntityTooLarge\|Payload too large' "${response_file}"; then
      echo "File is ${size_mb} MB. Supabase Free global upload limit is 50 MB." >&2
      echo "Use an arm64-only APK, or raise the limit / upgrade the plan in Storage settings." >&2
    fi
    rm -f "${response_file}"
    exit 1
  fi

  cat "${response_file}"
  echo
  rm -f "${response_file}"
}

ensure_bucket

ANDROID_APK="$(find "$DIST_DIR" -maxdepth 1 -name 'cbs_app-*-android.apk' -print -quit || true)"
WINDOWS_EXE="$(find "$DIST_DIR" -maxdepth 1 -name 'cbs_setup_*.exe' -print -quit || true)"
WEB_ZIP="$(find "$DIST_DIR" -maxdepth 1 -name 'cbs_app-*-web.zip' -print -quit || true)"
VERSION_JSON="${DIST_DIR}/version.json"

if [ ! -f "$VERSION_JSON" ]; then
  echo "version.json not found in $DIST_DIR" >&2
  exit 1
fi

if [ -z "$VERSION" ]; then
  VERSION="$(grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "$VERSION_JSON" | head -1 | sed 's/.*"\([^"]*\)"$/\1/')"
fi

if [ -n "$ANDROID_APK" ]; then
  upload_file "$ANDROID_APK" "latest/android.apk" "application/vnd.android.package-archive"
  upload_file "$ANDROID_APK" "releases/${VERSION}/android.apk" "application/vnd.android.package-archive"
fi

if [ -n "$WINDOWS_EXE" ]; then
  upload_file "$WINDOWS_EXE" "latest/windows-setup.exe" "application/octet-stream"
  upload_file "$WINDOWS_EXE" "releases/${VERSION}/windows-setup.exe" "application/octet-stream"
fi

if [ -n "$WEB_ZIP" ]; then
  upload_file "$WEB_ZIP" "latest/web.zip" "application/zip"
  upload_file "$WEB_ZIP" "releases/${VERSION}/web.zip" "application/zip"
fi

upload_file "$VERSION_JSON" "latest/version.json" "application/json"
upload_file "$VERSION_JSON" "releases/${VERSION}/version.json" "application/json"

echo "Release ${VERSION} published to Supabase Storage bucket '${BUCKET}'."
