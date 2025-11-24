#!/usr/bin/env bash
# git-pr-merge  ── interactive “gpm” helper
# Usage:  gpm   (after adding:  alias gpm="git-pr-merge")

set -euo pipefail

# 0️⃣  Show the latest 30 open PRs
echo -e "\n\033[1mOpen pull-requests on $(basename "$(git rev-parse --show-toplevel)")\033[0m"
gh pr list --limit 30 --state open --json number,title \
  -q '.[] | "\(.number)\t\(.title)"' | column -t -s $'\t'

# 1️⃣  Ask which PR to merge
read -rp $'\n→ Enter PR number to merge: ' pr_number
[[ -z "$pr_number" ]] && { echo "No PR selected – aborting."; exit 1; }

# 2️⃣  Default commit body = PR title
pr_title=$(gh pr view "$pr_number" --json title -q '.title')
default_body="Merges PR #$pr_number – $pr_title"

# 3️⃣  Let the user tweak / accept the body
read -rp "→ Merge message [${default_body}]: " body
body=${body:-$default_body}

# 4️⃣  Merge (regular merge; swap --merge for --squash / --rebase to taste)
echo -e "\n\033[1mMerging…\033[0m"
gh pr merge "$pr_number" \
  --merge \
  --delete-branch \
  --body "$body"

