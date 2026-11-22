# my_project

![Napisane w Duckling](https://img.shields.io/badge/napisane%20w-Duckling-f2c94c)
[![CI](https://github.com/pixelofsoftware/duckling-template/actions/workflows/ci.yml/badge.svg)](https://github.com/pixelofsoftware/duckling-template/actions/workflows/ci.yml)

Szablon projektu w języku [Duckling](https://github.com/ducktype-org/duckling): pakiet `duck`, przykładowy moduł,
testy wyjścia i CI, które buduje projekt oficjalnym wydaniem Ducklinga.

> **Duckling** to nowy, statycznie typowany język programowania rozwijany przez DuckType.
> Repozytorium języka: **https://github.com/ducktype-org/duckling**
> · [dokumentacja](https://docs.duckling.pl/) · [strona](https://duckling.pl/) · [wydania](https://github.com/ducktype-org/duckling/releases)
> · [społeczność](https://duckling.pl/get_involved/)
>
> Duckling jest w fazie alfa (v0.3): składnia i biblioteki wciąż się zmieniają.

## Jak użyć szablonu

1. Na GitHubie kliknij **Use this template → Create a new repository**.
2. Sklonuj nowe repozytorium i nadaj pakietowi własną nazwę (skrypt przestawia też odznakę CI na Twoje
   repozytorium, jeśli ma ustawiony `origin` na GitHubie):

   ```bash
   scripts/init.sh moj_pakiet
   ```

   Nazwa musi być unikalna na Twoim komputerze: `duck` trzyma jedno środowisko na nazwę pakietu, więc dwa
   projekty o tej samej nazwie w różnych katalogach się blokują (`duck build` zgłasza wtedy
   „would overwrite the venv of the package at ...”; `duck build --overwrite` przejmuje środowisko).
3. Zmień tytuł i opis w tym pliku, a w `LICENSE` właściciela praw.
4. W ustawieniach repozytorium dodaj tematy (topics) `duckling` i `duckling-lang`.

## Wymagania

Duckling 0.3 ([wydanie v0.3](https://github.com/ducktype-org/duckling/releases/tag/v0.3)). Na Linuksie x86_64:

```bash
curl -fsSLO https://github.com/ducktype-org/duckling/releases/download/v0.3/duckling-0.3-linux-x86_64.tar.gz
tar -xzf duckling-0.3-linux-x86_64.tar.gz
cd duckling-0.3-linux-x86_64 && ./install.py      # instaluje do ~/.local/share/duckling i dopisuje PATH
```

Na innych systemach zbuduj Ducklinga ze źródeł według instrukcji w
[repozytorium języka](https://github.com/ducktype-org/duckling). Sprawdzenie: `duck --version`.

## Budowanie i uruchamianie

```bash
duck build                              # program w .duck_build/dev/my_project
printf '3\n4 -2 10\n' | duck run        # suma: 12, maksimum: 10
```

## Testy

```bash
scripts/test.sh
```

Każdy przypadek to para plików w `tests/cases/`: `nazwa.in` (wejście) i `nazwa.out` (oczekiwane wyjście).
Skrypt buduje pakiet, uruchamia program na każdym wejściu i porównuje wyjście bajt w bajt. Nowy test to po
prostu nowa para plików. Limit czasu na przypadek: `TEST_TIMEOUT=10` (sekundy).

## Struktura

```
.
├── quackconfig.yaml        # nazwa i wersja pakietu (duck)
├── src/
│   ├── src.dk              # punkt wejścia: fun main()
│   └── statystyki.dk       # przykładowy moduł: import statystyki;
├── tests/cases/            # testy wyjścia: *.in i *.out
├── scripts/
│   ├── init.sh             # zmiana nazwy pakietu po utworzeniu repozytorium
│   └── test.sh             # budowanie i testy
├── .github/workflows/ci.yml  # CI: oficjalny Duckling 0.3, duck build, testy
├── .gitattributes          # *.dk jako Duckling w statystykach GitHuba
└── .editorconfig
```

Po pierwszym `duck build` powstaje `quackfreeze.json` (zamrożone wersje zależności). Dodaj go do repozytorium.

## CI

`.github/workflows/ci.yml` przy każdym pushu i pull requeście:

1. pobiera oficjalne wydanie Ducklinga i sprawdza jego sumę SHA-256;
2. buduje pakiet (`duck build`);
3. uruchamia `scripts/test.sh`.

Toolchain jest zapisywany w cache GitHub Actions. Przy zmianie wersji Ducklinga zaktualizuj w pliku
`DUCKLING_VERSION` i `DUCKLING_SHA256`.

## Język repozytorium na GitHubie

GitHub Linguist nie zna jeszcze Ducklinga, więc pasek języków go nie pokazuje. `.gitattributes` oznacza pliki
`.dk` i `.dks` jako Duckling, a skrypty pomocnicze wyłącza ze statystyk. Gdy Linguist doda język, repozytoria
zbudowane z tego szablonu zostaną rozpoznane bez zmian.

## Licencja

Kod tego szablonu: MIT (`LICENSE`). Duckling (kompilator, `duck`, biblioteki) ma własną licencję, DuckType Compiler
License 1.0: zobacz [LICENSE.md w repozytorium języka](https://github.com/ducktype-org/duckling/blob/HEAD/LICENSE.md).
Toolchain nie jest częścią tego repozytorium; CI pobiera go z oficjalnych wydań.

---

**English:** a GitHub template for [Duckling](https://github.com/ducktype-org/duckling) projects: a `duck`
package with an example module, output tests (`scripts/test.sh`, `tests/cases/*.in|*.out`) and CI that builds with
the official Duckling 0.3 release (SHA-256 checked). Click *Use this template*, then run `scripts/init.sh <name>`.
