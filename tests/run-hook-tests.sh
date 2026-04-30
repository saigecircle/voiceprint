#!/usr/bin/env bash
set -u  # NOT set -e — we want to inspect failures

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOOK="$REPO_ROOT/hooks/stop-capture.sh"
FIXTURES="$REPO_ROOT/tests/fixtures"
TEST_HOME="$(mktemp -d)"
export HOME="$TEST_HOME"
PENDING="$TEST_HOME/.voiceprint/pending-lessons.md"

pass=0
fail=0

run_hook() {
  local fixture="$1"
  local payload
  payload=$(jq -nc --arg path "$fixture" '{session_id:"test",transcript_path:$path,cwd:"/tmp",permission_mode:"default",hook_event_name:"Stop"}')
  echo "$payload" | "$HOOK"
}

assert() {
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "PASS: $label"
    pass=$((pass+1))
  else
    echo "FAIL: $label — expected '$expected', got '$actual'"
    fail=$((fail+1))
  fi
}

# Test 1: approval transcript → pending file gets a lesson
rm -rf "$TEST_HOME/.voiceprint"
run_hook "$FIXTURES/transcript-with-approval.jsonl"
if [ -f "$PENDING" ] && [ -s "$PENDING" ]; then
  assert "approval transcript creates pending entry" "yes" "yes"
else
  assert "approval transcript creates pending entry" "yes" "no"
fi

# Test 2: non-approval transcript → no pending entry
rm -rf "$TEST_HOME/.voiceprint"
run_hook "$FIXTURES/transcript-without-approval.jsonl"
if [ ! -f "$PENDING" ] || [ ! -s "$PENDING" ]; then
  assert "non-approval transcript leaves pending empty" "yes" "yes"
else
  assert "non-approval transcript leaves pending empty" "yes" "no"
fi

# Test 3: malformed transcript → hook exits 0, doesn't crash
rm -rf "$TEST_HOME/.voiceprint"
run_hook "$FIXTURES/transcript-malformed.jsonl"
exit_code=$?
assert "malformed transcript exits 0" "0" "$exit_code"

# Test 4: missing transcript file → hook exits 0
rm -rf "$TEST_HOME/.voiceprint"
run_hook "/nonexistent/path.jsonl"
exit_code=$?
assert "missing transcript exits 0" "0" "$exit_code"

echo ""
echo "Total: $((pass+fail)). Pass: $pass. Fail: $fail."
[ "$fail" -eq 0 ]
