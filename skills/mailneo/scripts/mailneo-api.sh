#!/usr/bin/env bash
# mailneo-api.sh — thin curl+jq wrapper for the Mailneo v2 API.
#
# Usage:
#   mailneo-api.sh me
#   mailneo-api.sh get PATH [--all]        # --all follows cursors to the end
#   mailneo-api.sh post PATH JSON
#   mailneo-api.sh patch PATH JSON
#   mailneo-api.sh delete PATH
#
# Reads MAILNEO_API_KEY (required). Writes send an Idempotency-Key: a fresh
# UUID per invocation, or MAILNEO_IDEMPOTENCY_KEY verbatim when set — export
# that to make a retry replay instead of repeat. MAILNEO_BASE_URL overrides
# the production base URL.
#
# Success: prints the envelope's `data` to stdout, `meta` to stderr.
# Failure: prints the error envelope to stderr; exits 4 (HTTP 4xx) or 5 (5xx).
set -euo pipefail

BASE_URL="${MAILNEO_BASE_URL:-https://api.mailneo.co/api/v2}"

die() { printf 'mailneo-api: %s\n' "$1" >&2; exit "${2:-2}"; }

usage() {
  sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//'
  exit 2
}

require_key() {
  [[ -n "${MAILNEO_API_KEY:-}" ]] || die \
    'MAILNEO_API_KEY is not set. Create a key in the Mailneo dashboard under Settings -> API Keys, then: export MAILNEO_API_KEY=...'
}

new_uuid() {
  if command -v uuidgen >/dev/null 2>&1; then
    uuidgen | tr '[:upper:]' '[:lower:]'
  else
    od -An -N16 -tx1 /dev/urandom | tr -d ' \n' |
      sed -E 's/^(.{8})(.{4})(.{4})(.{4})(.{12})$/\1-\2-\3-\4-\5/'
  fi
}

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

# request METHOD PATH [JSON_BODY] — leaves the response envelope in $RESP.
# Called directly (never in a subshell) so a failure exits the whole script.
# The API key travels via curl's stdin config, never on the command line.
RESP=""
request() {
  local method="$1" path="$2" body="${3:-}" status
  local -a args=(-sS --config - -X "$method" -H 'accept: application/json'
    -o "$TMP" -w '%{http_code}' --url "${BASE_URL}${path}")
  if [[ "$method" != GET ]]; then
    args+=(-H "idempotency-key: ${MAILNEO_IDEMPOTENCY_KEY:-$(new_uuid)}")
  fi
  if [[ -n "$body" ]]; then
    args+=(-H 'content-type: application/json' --data-binary "$body")
  fi
  status="$(printf 'header = "x-api-key: %s"\n' "$MAILNEO_API_KEY" |
    curl "${args[@]}")" || die "could not reach ${BASE_URL}" 5
  if [[ "$status" == 2* ]]; then
    RESP="$(cat "$TMP")"
    return 0
  fi
  jq . "$TMP" >&2 2>/dev/null || cat "$TMP" >&2
  case "$status" in
    4*) exit 4 ;;
    *)  exit 5 ;;
  esac
}

# Print one envelope: data to stdout, meta (request_id, paging, impact) to stderr.
emit() {
  jq -c '.meta // empty' <<<"$1" >&2
  jq 'if has("data") then .data else . end' <<<"$1"
}

get_all() {
  local path="$1" cursor="" page_path data='[]' has_more
  while :; do
    page_path="$path"
    if [[ -n "$cursor" ]]; then
      if [[ "$path" == *\?* ]]; then page_path="${path}&cursor=${cursor}"
      else page_path="${path}?cursor=${cursor}"; fi
    fi
    request GET "$page_path"
    data="$(jq -c --argjson acc "$data" '$acc + .data' <<<"$RESP")"
    has_more="$(jq -r '.meta.has_more // false' <<<"$RESP")"
    cursor="$(jq -r '.meta.next_cursor // empty | @uri' <<<"$RESP")"
    [[ "$has_more" == true && -n "$cursor" ]] || break
  done
  jq -c '.meta // empty' <<<"$RESP" >&2
  jq . <<<"$data"
}

main() {
  local cmd="${1:-}" path method all=0
  [[ -n "$cmd" ]] || usage
  shift
  case "$cmd" in
    me)
      require_key
      request GET /me
      emit "$RESP"
      ;;
    get)
      path=""
      for arg in "$@"; do
        if [[ "$arg" == --all ]]; then all=1; else path="$arg"; fi
      done
      [[ -n "$path" ]] || usage
      require_key
      if [[ "$all" == 1 ]]; then
        get_all "$path"
      else
        request GET "$path"
        emit "$RESP"
      fi
      ;;
    post | patch | delete)
      path="${1:-}"
      [[ -n "$path" ]] || usage
      [[ "$cmd" == delete || -n "${2:-}" ]] || die "usage: $0 $cmd PATH JSON"
      require_key
      method="$(printf '%s' "$cmd" | tr '[:lower:]' '[:upper:]')"
      request "$method" "$path" "${2:-}"
      emit "$RESP"
      ;;
    *) usage ;;
  esac
}

main "$@"
