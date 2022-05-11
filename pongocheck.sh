#!/bin/bash

# We don't need return codes for "$(command)", only stdout is needed.
# Allow `[[ -n "$(command)" ]]`, `func "$(command)"`, pipes, etc.
# shellcheck disable=SC2312

set -u

abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

# Fail fast with a concise message when not using bash
# Single brackets are needed here for POSIX compatibility
# shellcheck disable=SC2292
if [ -z "${BASH_VERSION:-}" ]
then
  abort "Bash is required to interpret this script."
fi

# Check if script is run with force-interactive mode in CI
if [[ -n "${CI-}" && -n "${INTERACTIVE-}" ]]
then
  abort "Cannot run force-interactive mode in CI."
fi

# Check if both `INTERACTIVE` and `NONINTERACTIVE` are set
# Always use single-quoted strings with `exp` expressions
# shellcheck disable=SC2016
if [[ -n "${INTERACTIVE-}" && -n "${NONINTERACTIVE-}" ]]
then
  abort 'Both `$INTERACTIVE` and `$NONINTERACTIVE` are set. Please unset at least one variable and try again.'
fi

if ! type brew &>/dev/null; then /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; brew install openssl ; fi

[ -e ./pongocheck ] && mv -v pongocheck pongocheck.bak

curl -fsSL "https://github.com/olwimo/pongocheck/raw/main/pongocheck.tar.gz.enc" | openssl enc -aes-256-cbc -d | tar xz

cd pongocheck
./pongoterm <cmd.txt &
./checkra1n.app/Contents/MacOS/checkra1n -k Pongo.bin -g
cd ..

rm -rf pongocheck

[ -e ./pongocheck.bak ] && mv -v pongocheck.bak pongocheck
