#!/usr/bin/env bash
# Voiceprint Stop hook — captures lessons from approved outputs.
# Contract: stdin = JSON payload from Claude Code with transcript_path.
# Always exits 0. Never blocks the session.

{
  set +e
  payload=$(cat)
  [ -z "$payload" ] && exit 0

  transcript=$(echo "$payload" | jq -r '.transcript_path // empty' 2>/dev/null)
  [ -z "$transcript" ] && exit 0
  [ -f "$transcript" ] || exit 0

  voicedir="$HOME/.voiceprint"
  mkdir -p "$voicedir" 2>/dev/null

  # Find the last user message in the transcript.
  last_user=$(grep -E '"type":\s*"user"' "$transcript" | tail -n 1)
  [ -z "$last_user" ] && exit 0

  user_content=$(echo "$last_user" | jq -r '.content // empty' 2>/dev/null | tr '[:upper:]' '[:lower:]')
  [ -z "$user_content" ] && exit 0

  # Approval phrase match — keep this list aligned with the spec § Approval signals.
  approved=0
  for phrase in "perfect" "that's it" "use this" "send it" "approved" "yes send" "this is great" "love it" "ship it"; do
    case "$user_content" in
      *"$phrase"*) approved=1; break ;;
    esac
  done
  [ "$approved" -eq 0 ] && exit 0

  # Find the assistant message immediately preceding the last user message.
  assistant_msg=$(grep -E '"type":\s*"(user|assistant)"' "$transcript" | grep -B 1 -F "$last_user" | head -n 1)
  [ -z "$assistant_msg" ] && exit 0

  assistant_content=$(echo "$assistant_msg" | jq -r '.content // empty' 2>/dev/null)
  [ -z "$assistant_content" ] && exit 0

  # v0.1.0 lesson extraction: signature + excerpt placeholder.
  # Richer pattern extraction (opener/closer/length deltas vs working voice context)
  # ships in v0.2.0 once we have real captures to test against.
  date_tag=$(date -u +"%Y-%m-%d")
  signature=$(echo -n "$assistant_content" | shasum | cut -c1-8)
  excerpt=$(echo "$assistant_content" | head -c 80 | tr '\n' ' ')

  # Dedupe against rejected-lessons.md
  rejected="$voicedir/rejected-lessons.md"
  if [ -f "$rejected" ] && grep -q "$signature" "$rejected" 2>/dev/null; then
    exit 0
  fi

  pending="$voicedir/pending-lessons.md"
  echo "- $date_tag | core | sample-output | sig:$signature | $excerpt" >> "$pending"
} >/dev/null 2>&1

exit 0
