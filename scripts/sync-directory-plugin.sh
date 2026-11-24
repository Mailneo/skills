#!/usr/bin/env bash
# Copies the four knowledge skills into claude-directory/, the connector-only
# plugin submitted to the Claude Directory. The directory accepts no scripts
# and no locally read credentials from unverified organizations, so that
# folder carries its own mailneo skill (connector only) and copies of the rest.
# Edit skills/ and re-run this; CI fails when the copies drift.
set -euo pipefail
cd "$(dirname "$0")/.."
for skill in email-compliance email-copywriting email-deliverability email-lifecycle; do
  rm -rf "claude-directory/skills/$skill"
  cp -R "skills/$skill" "claude-directory/skills/$skill"
done
