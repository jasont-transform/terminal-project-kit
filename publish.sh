#!/bin/bash
# publish.sh — one-command publish of the kit to GitHub.
# Run from the kit repo root.
#
# Usage:
#   ./publish.sh <github-org>
#   ./publish.sh <github-org> <repo-name>          # default repo name: claude-project-kit
#   VISIBILITY=private ./publish.sh <org>          # default is public
#
# Does:
#   - Verifies git and gh are installed
#   - Substitutes YOUR-GITHUB-USERNAME in README with the given org/username
#   - git init + first commit
#   - gh repo create + push
#   - Prints the install one-liner your team should run

set -eu

BOLD='\033[1m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

info()  { printf "${BOLD}%s${RESET}\n" "$1"; }
ok()    { printf "  ${GREEN}✓${RESET} %s\n" "$1"; }
warn()  { printf "  ${YELLOW}⚠${RESET} %s\n" "$1"; }
fatal() { printf "  ${RED}✗${RESET} %s\n" "$1" >&2; exit 1; }

echo ""
info "Publishing Claude Project Kit to GitHub"
echo ""

# ---- Preflight ----
if ! command -v git >/dev/null 2>&1; then
  echo "git not found. On macOS, install Xcode Command Line Tools:"
  echo ""
  echo "    xcode-select --install"
  echo ""
  echo "Then re-run this script."
  exit 1
fi
ok "git present"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI not found. Install it:"
  echo ""
  echo "    brew install gh"
  echo ""
  echo "Then authenticate with:  gh auth login"
  exit 1
fi
ok "gh CLI present"

if ! gh auth status >/dev/null 2>&1; then
  fatal "gh is not authenticated. Run:  gh auth login"
fi
ok "gh is authenticated"

# ---- Locate repo root ----
if [ ! -f "VERSION" ] || [ ! -d "kit" ]; then
  fatal "Run this from the Claude Project Kit repo root (where VERSION and kit/ live)."
fi

# ---- Args ----
ORG="${1:-}"
REPO="${2:-claude-project-kit}"
VISIBILITY="${VISIBILITY:-public}"

if [ -z "$ORG" ]; then
  printf "GitHub org or username: "
  read ORG
fi
[ -z "$ORG" ] && fatal "Org is required."

if [ "$VISIBILITY" != "public" ] && [ "$VISIBILITY" != "private" ]; then
  fatal "VISIBILITY must be 'public' or 'private' (got '$VISIBILITY')"
fi

echo ""
echo "  Org:         $ORG"
echo "  Repo:        $REPO"
echo "  Visibility:  $VISIBILITY"
echo "  Version:     $(cat VERSION)"
echo ""
printf "Continue? [y/N] "
read answer
case "$answer" in
  y|Y|yes|YES) ;;
  *) echo "Aborted."; exit 0 ;;
esac

# ---- Substitute placeholder in README ----
if grep -q "YOUR-GITHUB-USERNAME" README.md 2>/dev/null; then
  # BSD sed (macOS) requires '' after -i
  sed -i '' "s|YOUR-GITHUB-USERNAME|$ORG|g" README.md
  ok "Updated README with org '$ORG'"
fi

# ---- Git init if needed ----
if [ ! -d .git ]; then
  git init -q
  ok "Initialised git"
fi

# ---- Refuse if remote already configured ----
if git remote get-url origin >/dev/null 2>&1; then
  fatal "Remote 'origin' is already set: $(git remote get-url origin). Not overwriting."
fi

# ---- Commit ----
git add -A
if git diff --cached --quiet; then
  ok "No staged changes to commit"
else
  git commit -q -m "Initial commit: Claude Project Kit v$(cat VERSION)"
  ok "Committed"
fi

# ---- Create + push ----
info "Creating GitHub repo and pushing..."
gh repo create "$ORG/$REPO" --"$VISIBILITY" --source=. --remote=origin --push

echo ""
printf "${GREEN}${BOLD}Published.${RESET}  https://github.com/$ORG/$REPO\n"
echo ""
echo "Share with your team — they run this on their own Mac:"
echo ""
printf "    ${BOLD}curl -fsSL https://raw.githubusercontent.com/$ORG/$REPO/main/install.sh | bash${RESET}\n"
echo ""
