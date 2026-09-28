#!/usr/bin/env bash
# Copie les résumés et revues du dépôt privé glads-code/veille-techno
# vers content/fr/veille/ (pages publiées sous /veille/, en noindex).
# Les passages entre les lignes <!-- prive --> et <!-- /prive --> (détail des failles et
# écarts de conformité) restent dans le dépôt privé et ne sont pas publiés.
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
    awk '!done && /^# /{done=1; next}
         /^<!-- *prive *-->[[:space:]]*$/{skip=1; next}
         /^<!-- *\/prive *-->[[:space:]]*$/{skip=0; next}
         !skip{print}' "$1" |
      # le rendu Markdown ne fait une case que de la première « [ ] » d'une ligne
      sed 's|^- \[ \] valider / \[ \] refuser$|- ☐ valider · ☐ refuser|'
  } > "$2"
}

# Liste des décisions en attente (section de projets/README.md), lisible depuis le
# téléphone : /veille/attente/, avec la date de la revue tirée de l'identifiant.
attente() { # $1 projets/README.md, $2 destination
  {
    printf -- '---\ntitle: "Décisions en attente"\ndate: %s\nurl: /veille/attente/\nsitemap:\n  disable: true\n---\n\n' "$(date +%F)"
    printf 'Propositions des revues pas encore tranchées. Détail dans chaque [revue](/veille/).\n\n'
    awk -F'|' '/^## En attente de décision/{on=1; next}
         on && /^## /{exit}
         on && /^\|/{
           if ($2 ~ /^ *ID *$/) { print "| Depuis" $0; next }
           if ($2 ~ /^-+$/)     { print "|--------" $0; next }
           id=$2; gsub(/ /, "", id)
           d=substr(id, 3, 8)
           printf "| %s/%s %s", substr(d, 7, 2), substr(d, 5, 2), $0 "\n"
         }' "$1"
  } > "$2"
}

attente "$src/projets/README.md" "$dst/attente.md"

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
