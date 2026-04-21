#!/bin/bash
# Claude Project Kit — updater.
# Re-fetches the latest install.sh from GitHub and runs it.
# install.sh uses curl + tar — no git needed.
# Leaves ~/projects/<your-projects>/ alone.

set -eu

INSTALL_URL="${CLAUDE_KIT_INSTALL_URL:-https://raw.githubusercontent.com/jasont-transform/terminal-mode-project-kit/main/install.sh}"

echo "Updating Claude Project Kit..."
curl -fsSL "$INSTALL_URL" | bash
