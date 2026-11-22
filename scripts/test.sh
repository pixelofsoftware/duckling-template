#!/usr/bin/env bash
# Testy wyjścia: buduje pakiet i porównuje wyjście programu z oczekiwanym.
# Każdy przypadek to para tests/cases/<nazwa>.in (wejście) i tests/cases/<nazwa>.out (oczekiwane wyjście).
# Opcjonalny plik tests/cases/<nazwa>.code zawiera oczekiwany kod zakończenia (domyślnie 0).
#
#   scripts/test.sh              # duck build, potem wszystkie przypadki
#   scripts/test.sh --no-build   # bez budowania (np. w CI po osobnym kroku duck build)
set -euo pipefail
cd "$(dirname "$0")/.."

name="$(sed -n 's/^[[:space:]]*name:[[:space:]]*//p' quackconfig.yaml | head -n 1 | tr -d "\"'")"
[[ -n "$name" ]] || { echo "Nie znaleziono metadata.name w quackconfig.yaml" >&2; exit 2; }

if [[ "${1:-}" != "--no-build" ]]; then
    # Bez -q: komunikat o błędzie (np. "would overwrite the venv of the package at ...") ma być widoczny.
    duck build > /dev/null || { echo "duck build nie powiódł się (szczegóły wyżej)" >&2; exit 2; }
fi

exe=".duck_build/dev/$name"
[[ -x "$exe" ]] || { echo "Brak programu $exe: czy duck build się udał?" >&2; exit 2; }

limit="${TEST_TIMEOUT:-10}"
runner=()
if command -v timeout >/dev/null 2>&1; then runner=(timeout "$limit"); fi

passed=0 failed=0
for input in tests/cases/*.in; do
    case_name="$(basename "$input" .in)"
    expected="tests/cases/$case_name.out"
    [[ -f "$expected" ]] || { echo "SKIP $case_name (brak $expected)"; continue; }
    want_code=0
    [[ -f "tests/cases/$case_name.code" ]] && want_code="$(tr -d '[:space:]' < "tests/cases/$case_name.code")"
    actual="$(mktemp)"
    code=0
    ${runner[@]+"${runner[@]}"} "$exe" < "$input" > "$actual" 2>/dev/null || code=$?
    if [[ "$code" == "$want_code" ]] && diff -u "$expected" "$actual" > /dev/null; then
        echo "OK   $case_name"
        passed=$((passed + 1))
    else
        echo "FAIL $case_name (kod zakończenia $code, oczekiwany $want_code)"
        diff -u "$expected" "$actual" | sed 's/^/     /' || true
        failed=$((failed + 1))
    fi
    rm -f "$actual"
done

echo "wynik: $passed OK, $failed FAIL"
[[ "$failed" -eq 0 && "$passed" -gt 0 ]]
