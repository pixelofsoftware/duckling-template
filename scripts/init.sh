#!/usr/bin/env bash
# Pierwsze uruchomienie po utworzeniu repozytorium z szablonu: zmienia nazwę pakietu.
#
#   scripts/init.sh moj_pakiet
#
# Nazwa musi być unikalna na Twoim komputerze: duck trzyma jedno środowisko (venv) na nazwę pakietu,
# więc dwa projekty o nazwie my_project w różnych katalogach wchodzą sobie w drogę.
set -euo pipefail
cd "$(dirname "$0")/.."

new="${1:-}"
if [[ ! "$new" =~ ^[a-z][a-z0-9_]*$ ]]; then
    echo "Użycie: scripts/init.sh <nazwa>  (małe litery, cyfry i _, zaczyna się od litery)" >&2
    exit 2
fi
old="$(sed -n 's/^[[:space:]]*name:[[:space:]]*//p' quackconfig.yaml | head -n 1 | tr -d "\"'")"

perl -pi -e "s/^(\s*name:\s*).*/\${1}$new/" quackconfig.yaml
perl -pi -e "s/\b\Q$old\E\b/$new/g" README.md
# Odznaka CI w README: z repozytorium szablonu na to, z którego pochodzi klon (origin na GitHubie).
origin="$(git remote get-url origin 2>/dev/null || true)"
if [[ "$origin" =~ github\.com[:/]([^/]+/[^/.]+)(\.git)?$ ]]; then
    repo="${BASH_REMATCH[1]}"
    perl -pi -e "s#pixelofsoftware/duckling-template#$repo#g" README.md
fi
rm -f quackfreeze.json   # powstanie od nowa przy duck build, z nową nazwą
echo "Pakiet: $old -> $new. Teraz: duck build && scripts/test.sh"
