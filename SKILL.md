---
name: voiceprint
description: Apply the user's writing voice to drafts. Triggers on writing requests AND on any prompt mentioning "voiceprint". Strips AI tells, learns the user's voice over time. Stacks with other skills (brand context, frameworks) — loads on top, not instead of them. Does NOT trigger on code, edits/proofreads of user-supplied text, or scheduling/publishing requests (→ social-media-manager).
---

# voiceprint

Voiceprint applies the user's writing voice to anything they might publish. It strips AI tells by default and learns the user's actual voice over time, with their approval. Pure markdown plus Claude's built-in file tools — no plugin runtime, no hooks, no shell scripts, no network calls.

## When to activate

Activate whenever the output is text the user might publish in their voice. Concrete triggering paths:

- **Implicit (writing-task verb + publishable output):** "draft me a LinkedIn post", "summarise this article for my newsletter", "3 takeaways for my Substack", "write the cold email", "give me a hook for the ad", "rewrite this in my voice", "turn these notes into a blog draft".
- **Explicit (skill name as keyword):** any prompt mentioning "voiceprint" — "voiceprint this Substack draft", "set up voiceprint", "voiceprint review", "move voiceprint to …".

Do NOT activate when:

1. **The output is code.** Refactoring, debugging, generating functions, writing tests, technical commentary on a codebase. Voice is irrelevant to code.
2. **The request is an edit or proofread on user-supplied text.** "Proofread my draft", "tighten this paragraph I wrote", "fix the typos in this email" — the user's voice is already present in the text. Touching it with voiceprint risks overwriting them with the model's interpretation of "their voice".

Also stay out for any specific request where the user signals they want raw output. Seeded examples: "neutral summary", "just the facts", "no voice", "raw", "plain", "no styling". Judge intent — if the user asks for an objective summary or a bulleted brief with no voice, deliver that.

**Stacking.** Voiceprint is an enhancer, not a replacement. If another skill (brand context, copywriter framework, HTAC, etc.) is already loaded for the same request, voiceprint loads on top — it does not yield. Brand context tells you what to say; voiceprint controls how it sounds.

**Tie-break:** when in doubt, activate. False-positive cost is low (the user gets voice on output they would write that way anyway, or asks for raw and gets it). False-negative cost is real (AI tells leak through, the user redoes the work).

## Path resolution

Voiceprint stores user data in a folder it owns. The folder location is recorded in a single tiny pointer file at `~/.claude/voiceprint/voiceprint_home.txt`, which lives **adjacent to** the skill folder, not inside it. There are no environment variables; the pointer file is the only source of truth.

**Resolution rule:**

```
voiceprint_home =
  contents of ~/.claude/voiceprint/voiceprint_home.txt   if the pointer exists
  else ~/Documents/Voiceprint/                           (first-run default)
```

Throughout this document, `<voiceprint_home>` is shorthand for the resolved path.

**On first run** (the pointer file does not exist): create `~/Documents/Voiceprint/`, then create the parent directory `~/.claude/voiceprint/` and write the resolved absolute path into `~/.claude/voiceprint/voiceprint_home.txt`. Subsequent activations read the pointer file and use whatever path it contains.

**On every activation:** read the pointer first. If it exists but the path it points to is no longer writable (folder deleted, permission issue, sync conflict on a parent), stop and surface a clear repair message naming the file, the path, and likely causes (sync conflict, permissions, manual delete). Do not silently fall back to working without saving — the user always needs to know when voiceprint cannot persist.

**Relocation flow.** When the user says "move voiceprint to <new path>" (or anything Claude reads as that intent — "put voiceprint in my Obsidian vault", "relocate the voiceprint folder to Dropbox"), voiceprint:

1. Creates the new folder if it does not exist.
2. Moves the existing data (profile.md, lessons.md, samples/, registers/) into it.
3. Rewrites `~/.claude/voiceprint/voiceprint_home.txt` with the new absolute path.
4. Uses the new path immediately in the same session — no restart needed.

The pointer file is never bundled inside the skill folder. Skill updates (which replace `~/.claude/skills/voiceprint/`) do not touch it, so the user's chosen location survives every update.

## How to apply voice

Voice is layered, applied from broadest floor to narrowest tweak. Every draft loads all three layers in order:

1. **Humanizer floor.** Load `references/humanizer.md` from the skill folder. These rules strip AI tells (em dashes, "It's not just X, it's Y", banned vocabulary, generic warmth, hedging, predictable openers). The humanizer is the floor every draft sits on, regardless of register. Loaded fresh from the skill repo on every activation — never duplicated into `<voiceprint_home>/profile.md`. This way, humanizer updates reach existing users automatically the moment they update the skill.
2. **User additions.** Load `<voiceprint_home>/profile.md`. The frontmatter has settings; the body holds cross-register voice rules the user has approved during reviews ("I open with a quiet observation", "I avoid corporate verbs", "I close with a question, not a CTA"). These layer on top of the humanizer floor and apply to every register.
3. **Matching register.** Resolve the register filename from the request (see *Register decoder* below). If `<voiceprint_home>/registers/<name>.md` exists, load it. If not, create it lazily by copying `references/register-template.md` and continue with the empty scaffold — the next draft for this register will fill it in over time.

Generate the draft applying these three layers, narrowest layer winning when they conflict. The humanizer never overrides a user-approved rule; a user-approved cross-register rule never overrides a register-specific note. Layered, not averaged.

## Register decoder

A register is a context-specific voice slice — LinkedIn posts have a different shape from client emails, which differ from blog articles. Voiceprint resolves the register filename in two steps. The first step is a keyword lookup table; the second is a slugify fallback for everything the table does not cover.

**Step 1 — run the words through the decoder table first.** If any keyword in the user's request (or the phrase they give at setup) matches a row, use that row's canonical filename. This prevents the same surface (e.g. LinkedIn) from creating two parallel registers.

| If the request mentions… | Register file |
|---|---|
| LinkedIn, Twitter, X, Instagram, Facebook, post, caption, social | `registers/social-posts.md` |
| email, reply, message, DM, client | `registers/client-comms.md` |
| newsletter, Substack, broadcast | `registers/newsletter.md` |
| blog, article, long-form, essay | `registers/blog-articles.md` |
| ad, headline, hook, ad copy | `registers/ad-copy.md` |
| bio, about, intro, profile | `registers/bio-headlines.md` |
| VSL, video sales letter, sales video, sales script | `registers/video-sales-letters.md` |

Examples: "draft me a LinkedIn post" → `registers/social-posts.md`. "Write a reply to this client" → `registers/client-comms.md`. "Hook for the new ad" → `registers/ad-copy.md`. At setup, "LinkedIn posts" matches the same row, so the file created is `registers/social-posts.md` — not a new `linkedin-posts.md`.

**Step 2 — if no decoder keyword matches, slugify the descriptive name.** Lowercase, ASCII only, spaces and underscores become hyphens, punctuation stripped. Examples:

- "weekly digest" → `registers/weekly-digest.md`
- "event invites" → `registers/event-invites.md`
- "Internal team Slack notes" → `registers/internal-team-slack-notes.md`

If the user's phrase is genuinely ambiguous between two decoder rows ("a LinkedIn newsletter post"), pick the row that best matches the dominant noun and continue. The user can rename or merge later.

## First run

The first time voiceprint activates on a machine where the data folder does not yet exist:

1. Resolve voiceprint home as described above. On a fresh install with no pointer file, this resolves to `~/Documents/Voiceprint/`.
2. Create the home folder.
3. Copy `references/profile-template.md` from the skill folder to `<voiceprint_home>/profile.md`. Set `created` and `last_review` in the frontmatter to today's date.
4. Create `~/.claude/voiceprint/` if it does not exist, and write the resolved absolute path of the home folder into `~/.claude/voiceprint/voiceprint_home.txt`.
5. Print a one-time announcement at the end of the current response. The announcement should communicate, in voiceprint's own warm and direct phrasing:
   - Where the profile was created (using the actual resolved path, not a placeholder).
   - That the folder can be moved any time by telling voiceprint where to put it — voiceprint handles the move and remembers the new location automatically. No environment variables, no manual config.

Phrasing is voiceprint's call. The announcement shows once, ever — never on subsequent activations.

After the first run, the data layout under `<voiceprint_home>/` is:

```
<voiceprint_home>/
├── profile.md       # core voice — frontmatter + cross-register user additions
├── lessons.md       # rolling capture log of approved drafts (created lazily on first approval)
├── samples/         # raw writing samples (created at setup)
└── registers/       # one file per register, created lazily
```

Lessons file and the two subdirectories are created only when first needed. No empty scaffolding.

## Setup flow

Triggered when the user says "voiceprint setup" or anything Claude reads as that intent ("set up voiceprint", "configure voiceprint", "let's get voiceprint going"). Two questions, asked one at a time. Each is independently skippable.

**Question 1** (verbatim — the user-facing text is fixed):

> Paste 3 to 5 short pieces of your writing — anything you've actually published or sent. Or type **skip**.

Each pasted sample is saved to `<voiceprint_home>/samples/sample-N.md` (auto-incrementing N starting from the next unused number — never overwrite an existing file).

**Question 2** (verbatim — the user-facing text is fixed):

> What do you mainly write? (e.g. LinkedIn posts, client emails, blog drafts) — or type **skip**.

Each kind named is run through the register decoder (Step 1 first, Step 2 fallback) to produce a canonical filename. For each filename that does not already exist, copy `references/register-template.md` to `<voiceprint_home>/registers/<filename>` so future lessons have somewhere to land. Existing register files are left alone.

Setup is **idempotent**. Re-running it adds samples (continuing the N counter) and adds registers (only creating files that do not already exist). Nothing is wiped, nothing is overwritten.

## Approval logging (per-turn rule)

When the user signals approval of a draft voiceprint generated, append a structured entry to `<voiceprint_home>/lessons.md`. Capture time stores enough raw material that a review weeks later still makes sense — the original conversation will be long gone by then.

**Approval signal.** Judge intent. Seeded canonical examples that count: "perfect", "that's it", "use this", "send it", "yes this is closest to my voice", "love it", "ship it". Extend probabilistically: "yeah this works", "better", "go with this one", "nailed it", "yep" all count. Things that look like approval but are not — "perfect… but make it shorter", "love it, can we tweak the close?" — do NOT count. Those are revision signals; wait for approval on the next iteration.

**Entry format.** When approval fires, append this block to `lessons.md` (creating the file if it does not exist — if creating, write `# Lessons\n` as the first line before the first entry):

```markdown
---

## YYYY-MM-DDTHH:MM — <register-name>

**You asked:** <the user's original prompt for this draft>

**Final approved version:**
> <the full final approved text — full, not an 80-char excerpt>

**Changes you made from my draft:**
- <bullet describing change 1>
- <bullet describing change 2>
```

If the user accepted Claude's draft as written (no edits between draft and approval), the last section reads:

```markdown
**Changes you made from my draft:**
(none — accepted as written)
```

**Post-approval edits.** Approval often fires before the user finishes polishing. If the user edits a draft that voiceprint already logged as approved within the current session, update the lessons.md entry in place: replace the final approved version with the revised text, and update the diff to reflect what changed from voiceprint's original draft (not from the first-approved version). Timestamp and register stay unchanged. The signal to detect: the user changes specific lines of a draft voiceprint just wrote, within the same session, after an approval was logged.

Use the local timestamp in `YYYY-MM-DDTHH:MM` form. The `<register-name>` is the slug used for the matching register (e.g. `social-posts`, `client-comms`). The full approved text goes into the blockquote, even if it is long — completeness matters more than tidiness here, because review time has only what was captured.

**Three pieces are captured, patterns are not:**

| Captured | Why it matters at review time |
|---|---|
| **You asked** | Reminds the user what they were trying to make |
| **Final approved version** | The actual artifact whose voice we are learning from |
| **Changes you made** | The strongest signal — what the user actively reshaped |

Pattern extraction happens at *review time*, not capture time. Capture is fast and lossless; analysis is slower and more accurate when the user is paying attention to the result.

## Auto-prompt at threshold

**When the check runs.** Right after writing a new entry to `lessons.md`. That is the only moment the count changes, so no other check is needed.

**When the prompt fires.** When the entry count crosses a multiple of `review_threshold` (5, 10, 15, … by default). One prompt per crossing — no nagging. If the user defers at 5, voiceprint stays quiet until the count reaches 10, then prompts again.

**Threshold storage.** `review_threshold` lives in `profile.md` frontmatter, default `5`. `0` disables auto-prompting entirely (manual-only mode). Update the frontmatter when the user asks:

| User says | Set `review_threshold` to |
|---|---|
| "make it 3", "more frequent", "every 2" | matching number |
| "every 10 instead", "longer stretch", "7" | matching number |
| "manual only", "don't prompt me", "I'll do it myself" | `0` |
| "go back to auto", "check in every 5 again" (from manual) | matching number |

**First auto-prompt** (when `auto_prompt_intro_shown` is `false` in `profile.md` frontmatter). Print a short message at the end of the current response with two parts:

1. **The nudge:** voiceprint has noticed N things about the user's voice (use the actual current count) and offer to look at them now.
2. **The dial explanation (shown once, ever):** the current threshold (use the actual value), that it is adjustable to any number — smaller for more frequent reviews, larger for a longer stretch — that the user can switch to manual-only mode (which stops prompts entirely; reviews then run on demand via "voiceprint review" or similar phrasing), and that the user just tells voiceprint what they want.

Phrasing is voiceprint's call. After printing this, flip `auto_prompt_intro_shown` to `true` in the frontmatter so the long version never repeats. This stays `true` for the lifetime of the profile, even if the user later switches to manual mode and back to auto — the intro is shown once per user, not once per round of auto.

**Subsequent auto-prompts** (short form). Print a short message at the end of the current response with two parts:

1. **The nudge:** voiceprint has noticed N things (use the actual current count) and offer to look at them now.
2. **The lightweight reminder:** the current threshold (use the actual value) and that the user can change it or switch to manual reviews. No re-explanation of the dial.

Both forms always use the actual current threshold and lessons count, never hardcoded numbers.

If the user says "yes", "sure", "okay", "let's go", "go for it", or any clear assent, **start the review flow immediately** — the user does not need to type "voiceprint review". If the user says "not now", "later", "busy", etc., defer. The prompt resurfaces next time the threshold is crossed.

When `review_threshold` is `0`, the auto-prompt is disabled entirely. The user runs reviews on their own schedule by saying "voiceprint review" (or similar — judge intent). They can re-enable auto-prompts any time by giving voiceprint a number.

## Review flow (the main learning loop)

The review flow is the heart of voiceprint. It runs whenever either of the following happens:

- The user responds yes / sure / okay / let's go to the auto-prompt (auto mode only).
- The user says "voiceprint review" any time (judge intent — "review my voice lessons", "what has voiceprint learned?", "let's look at what you've noticed" all work).

In manual mode (`review_threshold: 0`), the second path is the only one available — there is no auto-prompt to respond to. In auto mode, both paths are available. Both run the same flow.

**Step 1 — assemble the queue.** Read `<voiceprint_home>/lessons.md`. Then scan the current session's conversation for any approvals voiceprint may have missed logging at the time. For each session-recovered approval not already in `lessons.md` (dedupe by timestamp + first 80 characters of the final approved draft), append a structured entry to `lessons.md` so it is persisted.

After the queue is assembled, transparently tell the user when items came from the current conversation — communicate that a few entries were noticed live in this session, alongside the ones already on the queue from past sessions. Phrasing is voiceprint's call. The point is honesty about provenance, not a status report.

Everything goes into a single review queue. Approvals missed in past sessions are unrecoverable — the conversation is gone — and that is the accepted cost of being plugin-free and hook-free.

**Step 2 — extract patterns at review time.** For each entry, read the three captured pieces (You asked, Final approved version, Changes you made) and ask: *what is distinctive about this approved draft compared to the current voice profile, given the user's ask and any edits they made?* Pattern extraction works from the captured material. The captured diff is usually the strongest signal — what the user actively reshaped points directly at a voice rule.

**Step 3 — present each candidate one at a time.** Each card includes five elements:

1. **Position in the queue** — e.g. "1 of 5".
2. **The original prompt** — the date and what the user asked for.
3. **The approved draft** — show in full inline, or if the draft is too long to read comfortably in the card, tell the user exactly where to find it: the resolved `<voiceprint_home>/lessons.md` path and the entry heading (e.g. `## 2026-05-01T12:00 — ad-copy`). Never silently excerpt.
4. **The diff** — what the user changed from voiceprint's draft (or "accepted as written" if they did not).
5. **The pattern voiceprint extracted** — what voiceprint noticed about the user's voice from this entry, plus the proposed destination (a specific register file, the cross-register user-additions area in profile.md, or samples/).

End each card by asking the user to choose one of four actions: always spell them out — **Approve**, **Reject**, **Edit**, **Skip** — with single-letter shortcuts in parentheses: e.g. "Approve (A) / Reject (R) / Edit (E) / Skip (S)". Never show letters alone without the word — A/R/E/S on its own is opaque. Layout, separators, and surrounding phrasing are voiceprint's call.

**Step 4 — apply each action.**

- **Approved.** Write the pattern wherever it best fits **inside the existing user data layout**, decided at the moment of approval based on what the pattern is. Possible destinations:
  - The matching register file at `<voiceprint_home>/registers/<name>.md` (most common — register-specific rules).
  - The cross-register user-additions area in `<voiceprint_home>/profile.md` (rules that apply across every register).
  - `<voiceprint_home>/samples/` as a new exemplar file (when what is captured is more an artifact-as-reference than a stateable rule).
  
  Stay within the declared structure (`profile.md`, `lessons.md`, `samples/`, `registers/`). No inventing new top-level files or folders. Remove the entry from `lessons.md` after writing.
- **Rejected.** Remove the entry from `lessons.md`. **No separate rejected file.** If the same pattern resurfaces in a future review, that is the signal the original rejection was wrong — the pattern IS the user's voice. Don't suppress it permanently.
- **Edited.** The user edits the **pattern description** voiceprint proposed (rewording "opens with quiet observation under 15 words" into something that better captures their voice rule). The captured draft text and destination logic are unchanged — write the user-edited pattern to the same place an Approved pattern would go. Remove the entry from `lessons.md`.
- **Skipped.** Leave the entry in `lessons.md` for the next review.

**Step 5 — update `last_review`** in `profile.md` frontmatter to today's date.

**Step 6 — closing message.** Print a one-line confirmation that reflects the current setting, so the user always sees the system is alive and behaving as they configured it.

- **If `review_threshold > 0` (auto mode):** confirm the review is complete and that another check-in will come once N more patterns have been captured (use the actual threshold value, never a hardcoded number — use the word "patterns" in the user-facing message). Then tell the user to open a new session for the updated patterns to take effect. Phrasing is voiceprint's call.
- **If `review_threshold == 0` (manual mode):** confirm the review is complete, voiceprint will not check in on its own, the user can run a review on demand by saying "voiceprint review" (or similar), and the user can re-enable auto-prompts any time by giving voiceprint a number. Then tell the user to open a new session for the updated patterns to take effect. Phrasing is voiceprint's call.

This design means **pattern extraction happens once, at review time, when accuracy matters**. Capture stores raw material; the analytical work happens when the user is paying attention to the result.

## Capture reliability and failure mode

The capture-logging instruction is probabilistic — Claude must remember the rule across turns. In practice it is reliable, because the same auto-memory mechanism that runs CLAUDE.md instructions runs this one.

If an approval is missed, that approval will simply not appear in `lessons.md`. The review flow mitigates this by also scanning the current session's transcript directly for approvals when a review is invoked, so recent missed approvals are recovered. Approvals missed in past sessions are unrecoverable — the conversation is gone — and that is the accepted cost of being plugin-free and hook-free.

**Error handling — single rule: never silently corrupt user data.**

- If `profile.md` is **missing** (file does not exist), treat as new user — copy from template.
- If `profile.md` **exists but is unreadable** (sync conflict, partial corruption, permission issue), stop and surface a clear repair message. Tell the user which file is unreadable, where it lives, and what to check (sync conflict, permissions, manual edit gone wrong). Stay paused on writes until the file is repaired or moved aside.
- If a required frontmatter field is **missing or invalid** (`review_threshold` deleted or set to a non-number, etc.), silently fall back to the default value AND write the default back into the frontmatter. Self-healing, no warning.
- If `lessons.md` is malformed (one bad entry), skip the bad entry and proceed with the rest.
- All writes use Claude's built-in file tools — no shell scripting, no platform-specific quirks.
- No per-write `.backup.md` files. Sync (Dropbox / iCloud / Syncthing / git) is the user's backup story; the README documents this.
