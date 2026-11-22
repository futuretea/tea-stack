#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="${SCRIPT_DIR}/skills"

TARGET=""
CUSTOM_DIR=""
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [--target claude|codex|agy|cursor|kimi|all | --skills-dir <dir>] [--dry-run]

Install tea-stack skills by creating safe symlinks.
Global rule files (rules/AGENTS.md) are NOT overwritten automatically; merge them manually as needed.

Options:
  --target <name>       Target tool: claude, codex, agy (or antigravity), cursor, kimi, or all
  --skills-dir <path>   Custom skills destination directory
  --dry-run             Show planned actions without modifying the filesystem
  -h, --help            Show this help message
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --target)
      [ $# -ge 2 ] || { echo "Error: --target requires a value" >&2; exit 1; }
      TARGET="$2"
      shift 2
      ;;
    --skills-dir)
      [ $# -ge 2 ] || { echo "Error: --skills-dir requires a value" >&2; exit 1; }
      CUSTOM_DIR="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [ -n "$TARGET" ] && [ -n "$CUSTOM_DIR" ]; then
  echo "Error: specify either --target or --skills-dir, not both" >&2
  exit 1
fi

if [ -z "$TARGET" ] && [ -z "$CUSTOM_DIR" ]; then
  usage
  exit 1
fi

DEST_DIRS=()
if [ -n "$CUSTOM_DIR" ]; then
  DEST_DIRS+=("$CUSTOM_DIR")
else
  case "$TARGET" in
    claude) DEST_DIRS+=("${HOME}/.claude/skills") ;;
    codex)  DEST_DIRS+=("${HOME}/.codex/skills") ;;
    agy|antigravity) DEST_DIRS+=("${HOME}/.gemini/config/skills") ;;
    cursor) DEST_DIRS+=("${HOME}/.cursor/skills") ;;
    kimi)   DEST_DIRS+=("${KIMI_CODE_HOME:-${HOME}/.kimi-code}/skills") ;;
    all)
      DEST_DIRS+=(
        "${HOME}/.claude/skills"
        "${HOME}/.codex/skills"
        "${HOME}/.gemini/config/skills"
        "${HOME}/.cursor/skills"
        "${KIMI_CODE_HOME:-${HOME}/.kimi-code}/skills"
      )
      ;;
    *)
      echo "Error: unsupported target '${TARGET}' (expected claude|codex|agy|cursor|kimi|all)" >&2
      exit 1
      ;;
  esac
fi

install_to_dir() {
  local dest_dir="$1"
  echo "Target directory: ${dest_dir}"

  if [ "$DRY_RUN" -eq 0 ]; then
    mkdir -p "$dest_dir"
  fi

  local skill_path skill_name link_path current_target
  for skill_path in "${SKILLS_SRC}"/*; do
    [ -d "$skill_path" ] || continue
    skill_name="$(basename "$skill_path")"
    link_path="${dest_dir}/${skill_name}"

    if [ -L "$link_path" ]; then
      current_target="$(readlink "$link_path")"
      if [ "$current_target" = "$skill_path" ]; then
        echo "  [ok]      ${skill_name} (already linked)"
        continue
      fi
      echo "  [skip]    ${skill_name} (existing symlink -> ${current_target})"
      continue
    elif [ -e "$link_path" ]; then
      echo "  [skip]    ${skill_name} (existing file/directory at ${link_path})"
      continue
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
      echo "  [dry-run] ln -s ${skill_path} ${link_path}"
    else
      ln -s "$skill_path" "$link_path"
      echo "  [linked]  ${skill_name} -> ${skill_path}"
    fi
  done
}

for dir in "${DEST_DIRS[@]}"; do
  install_to_dir "$dir"
done

echo ""
echo "Done. Review rules/AGENTS.md and templates/PROJECT-AGENTS.md to adopt rules manually."
