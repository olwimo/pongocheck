#!/bin/bash
if ! type brew &>/dev/null; then /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; brew install openssl ; fi
[ -e ./pongocheck ] && mv -v pongocheck pongocheck.bak
curl -fsSL "https://github.com/olwimo/pongocheck/raw/main/pongocheck.tar.gz.enc" | openssl enc -aes-256-cbc -d | tar xz
cd pongocheck
./pongoterm <cmd.txt &
./checkra1n.app/Contents/MacOS/checkra1n -k Pongo.bin -g
cd ..
rm -rf pongocheck
[ -e ./pongocheck.bak ] && mv -v pongocheck.bak pongocheck
