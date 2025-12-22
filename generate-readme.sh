#!/bin/sh

echo "# My humble NixOS Configuration" > README.md

echo "## Repository Structure" >> README.md
echo "" >> README.md
echo '```' >> README.md
tree -a -I '.git|README.md|hardware-configuration.nix|result|update.sh|generate-readme.sh' >> README.md
echo '```' >> README.md
