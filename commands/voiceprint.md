---
description: Voiceprint control panel — setup or review pending lessons. Usage: /voiceprint setup | /voiceprint review
---

# /voiceprint

Dispatch on the first argument:

- `setup` → run setup flow below
- `review` → run review flow below
- (no arg) → print this help text

## /voiceprint setup

Run the two-question setup. Each question is independently skippable. After each answer, write the result to `~/.voiceprint/` and confirm in chat.

### Question 1: Samples

Ask the user (verbatim):

> Paste 3 to 5 short pieces of your writing — anything you've actually published or sent. Or type **skip** if you'd rather teach me as we go.

Wait for response. If they type `skip`, move to Question 2. Otherwise:

1. Treat each pasted block (separated by blank lines, or each separate user message in a multi-turn paste) as one sample.
2. Save each sample to `~/.voiceprint/samples/sample-N.md` (N = next available integer; create the `samples/` directory if it doesn't exist).
3. Extract patterns from the samples:
   - **Sentence length distribution** — average words per sentence, range
   - **Opener shapes** — first 10 words of each sample, find the recurring shape (question? declarative? quote?)
   - **Closing patterns** — last 1–2 sentences, recurring shape
   - **Recurring phrases** — phrases ≥ 3 words appearing 2+ times across samples
   - **Word register** — Anglo-Saxon vs Latinate ratio (rough)
   - **Punctuation tells** — em-dash usage (yes/no — if yes, allow them in output despite humanizer floor)
4. Write extracted patterns into `~/.voiceprint/profile.md` under `## User additions`, one bullet each. Format:
   ```
   - <observation about user voice>. Source: <which sample>.
   ```
5. Confirm in chat: *"Saved N samples and pulled M patterns into your profile."*

### Question 2: What do you mainly write?

Ask (verbatim):

> What do you mainly write? Examples: LinkedIn posts, client emails, blog drafts, cold outreach. List anything that comes to mind, comma-separated. Or type **skip**.

Wait for response. If they type `skip`, finish setup. Otherwise:

1. Map each item to a register using the decoder table in SKILL.md:
   - "LinkedIn", "social", "IG", "Instagram", "Facebook", "Threads" → `social-posts`
   - "email", "DM", "message", "WhatsApp", "Messenger", "client" → `client-comms`
   - "blog", "article", "newsletter" → `blog-newsletter`
   - "ad", "campaign", "sales page" → `advocacy`
   - "support", "help" → `support-provider`
   - Anything else → ask the user which register it fits, or note as `core`
2. For each mapped register, if `~/.voiceprint/registers/<register>.md` doesn't exist, create one from `references/register-template.md` (in the plugin folder) with frontmatter filled in (`register:` = the name, `created:` = today's date).
3. Confirm in chat: *"Created N register stubs. They'll fill in as you write and approve outputs."*

### Setup is idempotent

Re-running `/voiceprint setup` adds new samples and registers without wiping existing ones. Question 1 appends to `~/.voiceprint/samples/`. Question 2 only creates register files that don't already exist.

## /voiceprint review

Walk pending lessons one at a time. For each, surface the pattern, target file, and ask the user to approve / reject / edit / skip.

### Steps

1. Read `~/.voiceprint/pending-lessons.md`. If empty or missing, say *"No pending lessons. Voiceprint will keep listening."* and exit.
2. For each line in pending-lessons.md:
   1. Parse the line: `- DATE | target | category | sig:SIGNATURE | description`.
   2. Display:
      ```
      [N of TOTAL]

      Pattern: <description>
      Target: <target file>
      Action: <inferred action — "Add as opener convention" / "Add to user additions" / etc.>

      [A]pprove  [R]eject  [E]dit  [S]kip for now
      ```
   3. Wait for user input. Accept letter or full word.
3. After all items:
   - **Approved lessons:** append the description as a bullet to the target file's appropriate section (Openers / Closings / User additions / etc., inferred from category). Remove the line from pending-lessons.md.
   - **Edited lessons:** treat the user-edited version as approved; otherwise same as Approve.
   - **Rejected lessons:** append `- sig:<SIGNATURE>` to `~/.voiceprint/rejected-lessons.md`. Remove the line from pending-lessons.md.
   - **Skipped lessons:** leave the line in pending-lessons.md.
4. Update the `last_review` field in `~/.voiceprint/profile.md` frontmatter to today's date.
5. Print summary: *"Reviewed N lessons — A approved, R rejected, S skipped."*
