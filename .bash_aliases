# --- Existing ---
alias rails-test-all="TEST_ALL_FEATURES=1 bin/rails"

# --- Dotcom test mode shortcuts (match CI suite env vars) ---
alias rails-test="bin/rails test"
alias rails-test-all-features="TEST_ALL_FEATURES=1 bin/rails test"
alias rails-test-emu="TEST_WITH_ALL_EMUS=1 bin/rails test"
alias rails-test-mt="MULTI_TENANT_ENTERPRISE=1 bin/rails test"
alias rails-test-mt-all-features="TEST_ALL_FEATURES=1 MULTI_TENANT_ENTERPRISE=1 bin/rails test"

# Note: single-test execution should be done with line numbers, e.g.
# rails-test-emu test/integration/foo_test.rb:42

# --- “Run relevant tests” / safety checks (from running-tests.md) ---
alias rails-test-oracle="bin/rails test_oracle"
alias rails-test-oracle-changed="bin/rails test_oracle -r"
alias safety-checks="bin/safety-checks"

# --- Flake reproduction helpers (from reproducing-flaky-tests.md) ---
# Run a test file repeatedly until it fails (Ctrl-C to stop).
alias rails-test-until-fail='bash -lc '"'"'while bin/rails test "$1"; do :; done'"'"' --'

# Re-run a test file with a specific seed:
alias rails-test-seed='bash -lc '"'"'bin/rails test "$1" --seed "$2"'"'"' --'

# --- Authz test framework shortcuts (test-authz-commands.md) ---
alias test-authz="bin/test-authz"
alias test-authz-run="bin/test-authz run"
alias test-authz-review="bin/test-authz review"
alias test-authz-print="bin/test-authz print"

# --- Codespaces playbook helpers (your .copilot sync workflow) ---
# Open the playbook folder quickly:
alias copilot-playbook='cd /workspaces/github/.copilot/github 2>/dev/null || echo "No playbook found at /workspaces/github/.copilot/github"'

# Show “start here” docs if present:
alias copilot-playbook-readme='sed -n "1,200p" /workspaces/github/.copilot/README.md 2>/dev/null || echo "No /workspaces/github/.copilot/README.md"'

# Remove the synced playbook folder so next Codespace restart/setup repopulates it from main:
alias copilot-playbook-clean='rm -rf /workspaces/github/.copilot/github && echo "Removed /workspaces/github/.copilot/github (will repopulate on next dotfiles run)"'

# --- Optional: GH CLI shortcuts for running CI subsets (from reproducing-flaky-tests.md) ---
# Run a subset of github-ci.yml (requires gh auth and correct repo permissions).
# Usage: gh-ci-subset <ref> <test-file> [mode]
# Example: gh-ci-subset master test/integration/foo_test.rb github
gh-ci-subset() {
  local ref="$1"
  local test_file="$2"
  local mode="${3:-}"
  if [[ -z "$ref" || -z "$test_file" ]]; then
    echo "usage: gh-ci-subset <ref> <test-file> [run-tests-subset]"
    return 2
  fi
  if [[ -n "$mode" ]]; then
    gh workflow run .github/workflows/github-ci.yml --ref "$ref" -f gh-test-subset="$test_file" -f run-tests-subset="$mode"
  else
    gh workflow run .github/workflows/github-ci.yml --ref "$ref" -f gh-test-subset="$test_file"
  fi
}

# Quick link to see your runs:
# usage: gh-ci-mine <github-handle>
gh-ci-mine() {
  local handle="$1"
  if [[ -z "$handle" ]]; then
    echo "usage: gh-ci-mine <github-handle>"
    return 2
  fi
  echo "https://github.com/github/github/actions/workflows/github-ci.yml?query=actor%3A${handle}"
}
