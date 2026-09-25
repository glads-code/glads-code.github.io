#!/usr/bin/env bash
# Copie les résumés et revues du dépôt privé glads-code/veille-techno
# vers content/fr/veille/ (pages publiées sous /veille/, en noindex).
# Usage : scripts/sync-veille.sh <chemin du clone veille-techno>
set -euo pipefail
src=${1:?chemin du dépôt veille-techno}
dst="$(cd "$(dirname "$0")/.." && pwd)/content/fr/veille"

convert() { # $1 source, $2 destination, $3 date ISO
  local title
  title=$(grep -m1 '^# ' "$1" | sed 's/^# //; s/"/\\"/g')
  mkdir -p "$(dirname "$2")"
  {
    printf -- '---\ntitle: "%s"\ndate: %s\nsitemap:\n  disable: true\n---\n\n' "$title" "$3"
    # le titre est affiché par le layout : on retire le premier H1
    awk '!done && /^# /{done=1; next} {print}' "$1"
  } > "$2"
}

for f in "$src"/resumes/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].md; do
  [ -e "$f" ] || continue
  n=$(basename "$f" .md)
  convert "$f" "$dst/resumes/$n.md" "$n"
done
for f in "$src"/projets/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-*.md; do
  [ -e "$f" ] || continue
  n=$(basename "$f" .md)
  convert "$f" "$dst/projets/$n.md" "${n:0:10}"
done
