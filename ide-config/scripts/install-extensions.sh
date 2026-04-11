#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  install-extensions.sh <extensions.txt> <vscode|cursor> [profile]

Arguments:
  extensions.txt   Path to a txt file containing one extension ID per line
  vscode|cursor    Which editor CLI to use
  profile          Optional profile name

Behavior:
  - Empty lines and lines starting with # are ignored
  - If profile is omitted, the script will ask whether to install into the default profile
EOF
}

if [[ $# -lt 2 || $# -gt 3 ]]; then
  usage
  exit 1
fi

EXT_FILE="$1"
EDITOR="$2"
PROFILE="${3:-}"

if [[ ! -f "$EXT_FILE" ]]; then
  echo "Error: file not found: $EXT_FILE" >&2
  exit 1
fi

case "$EDITOR" in
  vscode)
    CLI_CMD="code"
    ;;
  cursor)
    CLI_CMD="cursor"
    ;;
  *)
    echo "Error: second argument must be 'vscode' or 'cursor'" >&2
    usage
    exit 1
    ;;
esac

if ! command -v "$CLI_CMD" >/dev/null 2>&1; then
  echo "Error: '$CLI_CMD' command not found in PATH" >&2
  exit 1
fi

PROFILE_ARGS=()
if [[ -n "$PROFILE" ]]; then
  PROFILE_ARGS=(--profile "$PROFILE")
else
  read -r -p "No profile specified. Install into the default profile? [y/N] " reply
  case "$reply" in
    [yY]|[yY][eE][sS])
      ;;
    *)
      echo "Aborted."
      exit 1
      ;;
  esac
fi

installed=0
skipped=0
failed=0

while IFS= read -r line || [[ -n "$line" ]]; do
  ext="$(printf '%s' "$line" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"

  if [[ -z "$ext" || "$ext" == \#* ]]; then
    ((skipped+=1))
    continue
  fi

  if [[ -n "$PROFILE" ]]; then
    echo "Installing: $ext (profile: $PROFILE)"
  else
    echo "Installing: $ext (default profile)"
  fi

  if [[ "$EDITOR" == "vscode" ]]; then
    if "$CLI_CMD" "${PROFILE_ARGS[@]}" --install-extension "$ext" --force; then
      ((installed+=1))
    else
      echo "Failed: $ext" >&2
      ((failed+=1))
    fi
  else
    if "$CLI_CMD" "${PROFILE_ARGS[@]}" --install-extension "$ext"; then
      ((installed+=1))
    else
      echo "Failed: $ext" >&2
      ((failed+=1))
    fi
  fi
done < "$EXT_FILE"

echo
echo "Done."
echo "Installed: $installed"
echo "Skipped:   $skipped"
echo "Failed:    $failed"

if [[ $failed -gt 0 ]]; then
  exit 2
fi