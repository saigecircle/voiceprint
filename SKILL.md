---
name: voiceprint
description: Apply the user's writing voice to any output destined for another human reader, external audiences (clients, followers, readers) or internal ones (teammates, collaborators), including polishing or tightening a draft the user pasted. Also triggers on any prompt mentioning "voiceprint". Strips AI tells, seeds at setup or learns the user's voice over time. Stacks with other skills (brand context, frameworks), loads on top, not instead of them. Does NOT trigger on code or notes the user is writing only for themselves.
---

# voiceprint

Voiceprint applies the user's writing voice to any output intended for another human reader. It strips AI tells by default and learns the user's actual voice over time, with their approval. Pure markdown plus Claude's built-in file tools, no plugin runtime, no hooks, no shell scripts, no network calls.

## When to activate

Activate whenever the output is intended for another human reader, external (clients, prospects, followers, readers) or internal (teammates, collaborators, anyone the user is messaging or writing for besides themselves). This includes social posts, emails, newsletters, blog articles, ad copy, bios, announcements, proposals, pitches, Slack messages, internal memos, project notes shared with the team, and any other text another person will read.

The line is **audience, not channel.** Internal does not mean private. A note dropped into a shared team channel still has an audience and still deserves the user's voice. The only true exclusion is text no one but the user will ever read.

Concrete triggering paths:

- **Audience-facing output (default):** any draft, copy, or message destined for another human reader, regardless of whether a writing-task verb was used. The question is not "did they ask me to write something?" but "will another person read this?" If yes, voiceprint runs.
- **Explicit (skill name as keyword):** any prompt mentioning "voiceprint", "voiceprint this Substack draft", "set up voiceprint", "voiceprint review", "move voiceprint to …".

Do NOT activate when:

1. **The output is code.** Refactoring, debugging, generating functions, writing tests, technical commentary on a codebase. Voice is irrelevant to code.
2. **The output is for the user only.** Notes to self, personal journal entries, scratchpads, private planning docs the user is using as their own thinking surface. The test: will anyone other than the user read this? If no, skip voiceprint.

Edits and proofreads of user-supplied text **do** activate voiceprint when the text has any audience (tightening a LinkedIn draft, polishing a client email, fixing a Slack message to the team, cleaning up a memo for collaborators). Voiceprint applies the humanizer floor and the voice profile to whatever the model touches, while preserving the user's existing prose where it already sounds like them. The user's pasted draft becomes the baseline for *First draft tracking* below, any edits voiceprint makes are the diff captured at approval time.

Also stay out for any specific request where the user signals they want raw output. Seeded examples: "neutral summary", "just the facts", "no voice", "raw", "plain", "no styling". Judge intent, if the user asks for an objective summary or a bulleted brief with no voice, deliver that.

**Stacking.** Voiceprint is an enhancer, not a replacement. If another skill (brand context, copywriter framework, HTAC, etc.) is already loaded for the same request, voiceprint loads on top, it does not yield. Brand context tells you what to say; voiceprint controls how it sounds.

**Tie-break:** when in doubt, activate. False-positive cost is low (the user gets voice on output they would write that way anyway, or asks for raw and gets it). False-negative cost is real (AI tells leak through, the user redoes the work).

## Response order when activated

Once voiceprint is activated, whether the user is asking for a fresh draft or handing over their own text to polish, the response order is fixed:

1. **Load any layers not yet in this session.** Read `references/humanizer.md`, `<voiceprint_home>/voice-profile.md`, and the matching register file (per *Register decoder* below) the first time each is needed in this session. Skip any that are already in context, see *How to apply voice* below for the loading rule. Do not skip a layer because the text is short, casual, or looks like a personal note: **explicit invocation of voiceprint overrides the user-only carve-out** in *When to activate*.
2. **Onboarding gate (alpha 0.7.0).** Immediately after loading `voice-profile.md` for the first time in a session, check its frontmatter. If `setup_complete: false`, the permission question (see *Permission question* below) is the **entire response for this turn**. Stop the response order here: do not draft, polish, or apply layers. Wait for the user's next turn. On their reply: `[1]` pauses the user's original task and runs the Setup flow, then resumes the original task with the now-populated profile; `[2]` and `[3]` (deferral or anything voiceprint reads as deferral) skip ahead to steps 3-4 and run the original task directly. Do not re-ask within the same session — once asked, the gate is satisfied regardless of which branch was picked.
3. **Run the content through the loaded layers.** Strip humanizer-banned shapes, apply user-additions from `voice-profile.md`, apply register notes. If the user supplied a draft, treat it as the baseline and preserve the parts that already sound like them.
4. **Then write the response.** Briefly name which layers were loaded (or already in context), so the user can see voice was actually applied rather than the model writing from memory.

If a layer file is missing or unreadable, surface that before responding, never silently skip a layer.

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

**On every activation:** read the pointer first. If it exists but the path it points to is no longer writable (folder deleted, permission issue, sync conflict on a parent), stop and surface a clear repair message naming the file, the path, and likely causes (sync conflict, permissions, manual delete). Do not silently fall back to working without saving, the user always needs to know when voiceprint cannot persist.

**Relocation flow.** When the user says "move voiceprint to <new path>" (or anything Claude reads as that intent, "put voiceprint in my Obsidian vault", "relocate the voiceprint folder to Dropbox"), voiceprint:

1. Creates the new folder if it does not exist.
2. Moves the existing data (voice-profile.md, lessons.md, samples/, registers/) into it.
3. Rewrites `~/.claude/voiceprint/voiceprint_home.txt` with the new absolute path.
4. Uses the new path immediately in the same session, no restart needed.

The pointer file is never bundled inside the skill folder. Skill updates (which replace `~/.claude/skills/voiceprint/`) do not touch it, so the user's chosen location survives every update.

## How to apply voice

Voice is layered, applied from broadest floor to narrowest tweak. Three layers, loaded in order:

1. **Humanizer floor.** Load `references/humanizer.md` from the skill folder. These rules strip AI tells (em dashes, "It's not just X, it's Y", banned vocabulary, generic warmth, hedging, predictable openers). The humanizer is the floor every draft sits on, regardless of register. Lives in the skill repo, never duplicated into `<voiceprint_home>/voice-profile.md`, so humanizer updates reach existing users automatically the moment they update the skill.
2. **User additions.** Load `<voiceprint_home>/voice-profile.md`. The frontmatter has settings; the body holds cross-register voice rules the user has approved during reviews ("I open with a quiet observation", "I avoid corporate verbs", "I close with a question, not a CTA"). These layer on top of the humanizer floor and apply to every register.
3. **Matching register.** Resolve the register filename from the request (see *Register decoder* below). If `<voiceprint_home>/registers/<name>.md` exists, load it. If not, create it lazily by copying `references/register-template.md` and continue with the empty scaffold, the next draft for this register will fill it in over time.

**Loading rule.** Read each layer the first time it's needed in a session, then rely on what's already in context for subsequent drafts. Don't re-Read files that have already been loaded this session, the content is already there, and re-reading just burns tokens without changing anything. The matching register may be different from one draft to the next; load each new register the first time it's needed, then keep using the in-context copy for further drafts in that register.

This is also why the review flow tells the user to open a new session for newly-approved patterns to take effect: the on-disk `voice-profile.md` and register files have changed, but the in-context copies are stale until a fresh session reloads them.

Generate the draft applying these three layers, narrowest layer winning when they conflict. The humanizer never overrides a user-approved rule; a user-approved cross-register rule never overrides a register-specific note. Layered, not averaged.

## Register decoder

A register is a context-specific voice slice, LinkedIn posts have a different shape from client emails, which differ from blog articles. Voiceprint resolves the register filename in two steps. The first step is a keyword lookup table; the second is a slugify fallback for everything the table does not cover.

**Step 1, run the words through the decoder table first.** If any keyword in the user's request (or the phrase they give at setup) matches a row, use that row's canonical filename. This prevents the same surface (e.g. LinkedIn) from creating two parallel registers.

| If the request mentions… | Register file |
|---|---|
| LinkedIn, Twitter, X, Instagram, Facebook, post, caption, social | `registers/social-posts.md` |
| email, reply, message, DM, client | `registers/client-comms.md` |
| newsletter, Substack, broadcast | `registers/newsletter.md` |
| blog, article, long-form, essay | `registers/blog-articles.md` |
| ad, headline, hook, ad copy | `registers/ad-copy.md` |
| bio, about, intro, profile | `registers/bio-headlines.md` |
| VSL, video sales letter, sales video, sales script | `registers/video-sales-letters.md` |

Examples: "draft me a LinkedIn post" → `registers/social-posts.md`. "Write a reply to this client" → `registers/client-comms.md`. "Hook for the new ad" → `registers/ad-copy.md`. At setup, "LinkedIn posts" matches the same row, so the file created is `registers/social-posts.md`, not a new `linkedin-posts.md`.

**Step 2, if no decoder keyword matches, slugify the descriptive name.** Lowercase, ASCII only, spaces and underscores become hyphens, punctuation stripped. Examples:

- "weekly digest" → `registers/weekly-digest.md`
- "event invites" → `registers/event-invites.md`
- "Internal team Slack notes" → `registers/internal-team-slack-notes.md`

If the user's phrase is genuinely ambiguous between two decoder rows ("a LinkedIn newsletter post"), pick the row that best matches the dominant noun and continue. The user can rename or merge later.

## First run

The first time voiceprint activates on a machine where the data folder does not yet exist:

1. Resolve voiceprint home as described above. On a fresh install with no pointer file, this resolves to `~/Documents/Voiceprint/`.
2. Create the home folder.
3. Copy `references/voice-profile-template.md` from the skill folder to `<voiceprint_home>/voice-profile.md`. The template ships with `setup_complete: false`, so the next activation will trigger the permission question.
4. Create `~/.claude/voiceprint/` if it does not exist, and write the resolved absolute path of the home folder into `~/.claude/voiceprint/voiceprint_home.txt`.
5. Print a one-time announcement at the end of the current response. The announcement should communicate, in voiceprint's own warm and direct phrasing:
   - Where the profile was created (using the actual resolved path, not a placeholder).
   - That the folder can be moved any time by telling voiceprint where to put it.

After the first run, the data layout under `<voiceprint_home>/` is:

```
<voiceprint_home>/
├── voice-profile.md   # core voice, frontmatter + cross-register user additions
├── lessons.md         # rolling capture log of approved drafts (created lazily)
├── samples/           # cleaned writing samples saved at setup (created lazily)
└── registers/         # one file per register, created lazily
```

`lessons.md`, `samples/`, and `registers/` are created only when first needed. No empty scaffolding.

## Permission question (the alpha 0.7.0 onboarding gate)

When voiceprint activates and reads `voice-profile.md`, if `setup_complete: false`, ask the permission question **once** before doing the user's task. Pause and wait for the user's pick — do not draft, polish, or otherwise produce the response in the same turn. The permission question is the entire response for that turn. Once the user picks, voiceprint proceeds: `[1]` runs setup then resumes the original task; `[2]` and `[3]` (deferral) run the original task directly.

```
Want to complete voiceprint setup first? Takes about 3 minutes —
either paste an existing voice doc, or paste 3-5 writing samples.
Voiceprint reads them and seeds your voice profile so day-one drafts
sound like you.

  [1] Yes — set me up now
  [2] Not now — ask me next session
  [3] Other — specify
```

Branching:

- `[1]` → pause the task, run the path question (next subsection), then resume the original task with the now-populated profile.
- `[2]` → continue with the user's original task. `setup_complete` stays `false`. Voiceprint asks again on the next session's first activation. The user can stop being asked at any time by saying "stop asking about setup", which sets `setup_complete: true, setup_method: skipped`.
- `[3]` → user types free-form. Voiceprint applies these rules in order:
  1. If the response semantically matches `[1]` (e.g. "yeah set me up", "let's do it"), treat as `[1]`.
  2. If it semantically matches `[2]` (e.g. "later", "not right now", "skip for now"), treat as `[2]`.
  3. If it semantically matches a permanent skip (e.g. "never ask", "stop asking", "I don't want this"), set `setup_complete: true, setup_method: skipped`.
  4. If the response asks a question (e.g. "what does setup do?"), answer it briefly and re-show the prompt.
  5. Otherwise, re-show the prompt with a one-line note: "I didn't catch that — please pick one." Never silently write anything to disk.

If the user picks `[1]`, the next prompt picks the path:

```
Set up your voice profile?
  [1] Import an existing voice doc — recommended
  [2] Paste 3-5 writing samples
  [3] Other — specify
```

`[1]` → Path B (voice doc intake). `[2]` → Path A (sample intake). `[3]` → free-form, voiceprint resolves to Path B or Path A or re-asks.

## Setup flow

Triggered when the user says "voiceprint setup" or anything voiceprint reads as that intent ("set up voiceprint", "configure voiceprint", "let's get voiceprint going"). Same flow runs from the auto-prompt's `[1]` branch (see *Permission question* above).

Also triggered directly by "import voice doc" (goes straight to Path B, bypassing the path-pick prompt) or "analyse my samples" (goes straight to Path A). Same intent-judgement applies — phrases like "import my writing", "use my samples", "read my samples", or anything voiceprint reads as that intent route the same way.

After the path question (see *Permission question* above) the flow forks into Path B (voice doc) or Path A (samples). Both end with the **intelligent populator + transparency summary** described later in this doc.

### Path B — voice doc intake

1. Ask where the doc is:

   ```
   Where's your voice doc?
     [1] Paste it here
     [2] One file — give me the path
     [3] Entire folder — give me the path (I'll treat all files as voice-doc material)
     [4] Other — specify
   ```

2. **If `[3]` (folder)**, list the `.md`/`.txt` files voiceprint sees inside (no recursion) and confirm before proceeding:

   ```
   I see N files in <folder>:
     - file1.md
     - file2.md
     ...

   Treat all as one merged voice-doc corpus?
     [1] Yes — proceed
     [2] Skip some — tell me which to exclude
     [3] Other — specify
   ```

3. **Show the doc preview.**
   - Single file or pasted text: H1 if present, else filename (or "Pasted text" for pastes), else "Untitled voice doc"; followed by total line count and the first ~5 non-empty lines.
   - Folder: list each file's title (same H1/filename rule per-file), one line each, plus combined total line count. No first-5-lines wall when multi-file.

4. **Run the voice doc analyser.** Distill the content into:
   - Cross-register notes → `voice-profile.md`
   - Register-specific notes → `registers/<name>.md` (filename resolved via the *Register decoder* in this doc)
   - The doc itself is **not** saved as a sample.

   For folder input, the analyser treats the combined files as one corpus. One run, one set of distilled outputs.

5. **Output cap:** 5–10 high-signal additions total across all destinations. Quality over volume. Distill, never bulk-copy.

6. Hand off to the **intelligent populator** (later in this doc).

7. Frontmatter updated to `setup_complete: true, setup_method: voice-doc, last_setup_run: <today>`.

### Path A — sample intake

1. Ask for samples:

   ```
   Show me your samples:
     [1] Paste them here (separate multiple samples with --- or blank lines)
     [2] One file — give me the path
     [3] Entire folder — give me the path (I'll treat each file as a sample)
     [4] Other — specify
   ```

2. **If `[1]` (paste)**, voiceprint splits on `---`, double blank lines, or file boundaries. If the count is clear, surface it as a confirmation. If genuinely unclear:

   ```
   I see one block of text. How should I read it?
     [1] One sample
     [2] Multiple — I'll add separators and re-paste
     [3] Multiple — split where you think the boundaries are, I'll review
     [4] Other — specify
   ```

3. **If `[2]` (one file)**, read the file as a single sample.

4. **If `[3]` (entire folder)**, list the `.md`/`.txt` files voiceprint sees in the folder (no recursion) and confirm before treating each as one sample:

   ```
   I see N files in <folder>:
     - sample-1.md
     ...

   Treat each file as one sample?
     [1] Yes — all N as samples
     [2] Skip some — tell me which to exclude
     [3] Other — specify
   ```

5. **Batched register confirmation.** Show all N samples with voiceprint's best-guess register classification per sample, in one consolidated prompt:

   ```
   I see N samples. Here's how I'd classify them:

   Sample 1: <register>
     "<first ~80 chars of sample>..."
   Sample 2: <register>
     ...

   Confirm or correct?
     [1] All correct
     [2] Tell me what to change
     [3] Other — specify
   ```

   `[2]` → user says e.g. "sample 2 is a blog post, others correct". Voiceprint updates and re-shows.

6. **Per-sample proofread.** For each sample, scan for typos. **Skip the prompt entirely if no typos found** — no null prompts. If typos are found:

   ```
   Sample N — possible typos:
     "I went the shop" → "I went to the shop"
     "teh" → "the"

   What should I do?
     [1] Accept all
     [2] Reject all — save as-is
     [3] Other — specify (e.g. "accept the first only")
   ```

   **Proofread rules:**
   - ✓ Typos (`teh` → `the`)
   - ✓ Missing words (`I went the shop` → `I went to the shop`)
   - ✓ Genuinely broken syntax (a sentence missing its subject by accident)
   - ✗ Sentence fragments — voice
   - ✗ Comma splices — voice
   - ✗ "And"/"But" sentence starts — voice
   - ✗ Contractions, register, word choice — voice

7. **Save each cleaned sample** to `samples/<YYYY-MM-DD>-<n>.md`. `<n>` auto-increments based on existing files for that date — if `samples/2026-05-01-1.md` and `2026-05-01-2.md` exist, the next sample written today is `2026-05-01-3.md`. Each sample file:

   ```yaml
   ---
   register: social-posts
   date: 2026-05-01
   ---

   [cleaned sample text]
   ```

   Register lives in frontmatter (not filename) so re-classification doesn't require renaming.

8. **Pattern analyser** runs across all cleaned samples. Looks for what's *consistent across* samples (recurring phrases, opening/closing instincts, vocabulary fingerprint). Surfaces:
   - Patterns specific to one register → matching `registers/<name>.md`
   - Patterns consistent across multiple registers → cross-register, `voice-profile.md`

   **Output cap: 5–10 high-signal additions total** across all destinations.

9. Hand off to the **intelligent populator**.

10. Frontmatter updated to `setup_complete: true, setup_method: samples, last_setup_run: <today>`.

## Intelligent populator

After Path B's voice-doc analyser or Path A's pattern analyser produces proposed entries, the populator distributes them across the right destinations and writes them directly. **No per-item approval gate.**

- Cross-register observations → `voice-profile.md`
- Register-specific observations → matching `registers/<name>.md` (created lazily by copying `references/register-template.md` if the file doesn't exist)
- Cleaned samples (Path A only) → `samples/<YYYY-MM-DD>-<n>.md`

**Output cap: 5–10 high-signal additions total per analysis run**, across all destinations combined. Not per-destination. Distill, never bulk-copy.

### Dedupe rule

Before writing each proposed entry, voiceprint compares its **canonical headline** against the canonical headlines of existing entries in the destination file.

**Canonical headline** = first sentence (or sentence-fragment up to the first period or newline) of the entry, lowercased, with all punctuation stripped. Comparison is exact-string after canonicalisation. Not semantic.

Example:
- Existing entry: `**Borrowed authority.** Reference a well-known figure...` → canonical = `borrowed authority`
- New proposed entry: `**Borrowed authority** — using a well-known figure...` → canonical = `borrowed authority`
- Match → skip.

This is a deterministic rule. Re-runs with the same input produce the same dedupe outcome.

### Glaring contradictions

Before writing, the populator checks for *direct opposites* between proposed entries and existing entries. Bar is high — voice is art. Only flag when a proposed rule and an existing rule cannot both be true at the same time.

- **Counts as glaring:** "Always use em dashes" vs "Never use em dashes"; "Open with a question" vs "Never open with a question"; "Aussie spelling throughout" vs "American spelling throughout".
- **Does NOT count as glaring:** "Use contractions by default" vs "Sometimes formal phrasing fits" (compatible — contextual); "Open with a scene" vs "Open with a plain statement of the thing I'm challenging" (compatible — different opening modes); different rules in different register files (compatible — registers are register-scoped).

When a glaring contradiction is detected, voiceprint **writes both entries** (default behaviour: voice is contextual, both can be true) and surfaces a one-line note inside the transparency summary. No blocking prompt. The user can resolve via co-creation if they want.

### Idempotency and additivity

- **Idempotent:** re-running with the same voice doc or the same samples produces no new entries the second time (canonical-headline dedupe ensures this for `voice-profile.md` and register files).
- **Sample files (Path A only) are NOT deduped** — each run saves new sample files with new `<n>` suffixes. Sample files are a record of what the user supplied, not a deduplicated set.
- **Additive across paths:** a user can run Path A first, Path B later (or any combination). Populator merges into the same destinations. Order doesn't matter.

## Transparency summary

After the populator writes, voiceprint shows a short summary of what landed where. Not an approval prompt — purely informational.

```
Done. Here's what I added:

voice-profile.md (+8 entries)
  - Borrowed authority
  - Specificity as signal
  - Land the point and stop
  - Hedges over absolutes
  - ...

registers/social-posts.md (+3 entries)
registers/newsletter.md (+2 entries)

samples/ (+5 files)
  - 2026-05-01-1.md (social-posts)
  - 2026-05-01-2.md (newsletter)
  - ...

Edit any file by hand if anything looks off.
```

For each entry voiceprint adds, the summary lists a one-line label (the rule's headline). Full content lives in the file — the summary is for the user to scan and spot anything they want to change.

If a re-run produces no new writes:

```
Already in sync. No new entries to add.
```

If the populator detected glaring contradictions, append a one-line note per contradiction inside the summary:

```
Note: I noticed a possible contradiction between the new
"Open with a rhetorical question" and the existing "Never open
with a question." I've kept both — voice is contextual. Tell me
if you'd like me to drop one.
```

**The summary is a checkpoint, not a wall.** After voiceprint shows it, the user can challenge any entry, ask why a pattern landed where it did, request rewording, move a pattern to a different destination, or remove it altogether. Voiceprint edits files in real-time as the conversation goes. Same model end-to-end across setup and review — co-creation, not fire-and-forget.

## Approval logging (per-turn rule)

**Schema note (alpha 0.7.0):** the lessons capture format is unchanged from v0.6.0. Each entry retains the fields *Timestamp*, *Register*, *You asked*, *Final approved version*, *Changes you made*. The new pattern-level review flow reads these fields without modification.

When the user signals approval of a draft voiceprint generated, append a structured entry to `<voiceprint_home>/lessons.md`. Capture time stores enough raw material that a review weeks later still makes sense, the original conversation will be long gone by then.

**Approval signal.** Judge intent. Seeded canonical examples that count: "perfect", "that's it", "use this", "send it", "yes this is closest to my voice", "love it", "ship it". Extend probabilistically: "yeah this works", "better", "go with this one", "nailed it", "yep" all count. Things that look like approval but are not, "perfect… but make it shorter", "love it, can we tweak the close?", do NOT count. Those are revision signals; wait for approval on the next iteration.

**First draft tracking.** Hold the very first version of the content in memory as the baseline for this thread, whether that is voiceprint's first generated draft, or a draft the user supplied to kick off the iteration. If the user asks for revisions and voiceprint produces a second, third, or fourth draft, the baseline does not change. The diff at approval time always compares the final approved version against that original starting point, not the most recent intermediate draft. This captures the full distance travelled, between where the content started and where the user actually wanted it to land, which is where the real voice learning lives.

**Entry format.** When approval fires, append this block to `lessons.md` (creating the file if it does not exist, if creating, write `# Lessons\n` as the first line before the first entry):

```markdown
---

## YYYY-MM-DDTHH:MM, <register-name>

**You asked:** <the user's original prompt for this draft>

**Final approved version:**
> <the full final approved text, full, not an 80-char excerpt>

**Changes from first draft:**
- <bullet describing change 1>
- <bullet describing change 2>
```

If the user accepted voiceprint's first draft as written (no edits across any iteration), the last section reads:

```markdown
**Changes from first draft:**
(none, accepted as written)
```

**Post-approval edits.** Approval often fires before the user finishes polishing. If the user edits a draft that voiceprint already logged as approved within the current session, update the lessons.md entry in place: replace the final approved version with the revised text, and update the diff to reflect what changed from the first draft (not from the first-approved version). Timestamp and register stay unchanged. The signal to detect: the user changes specific lines of a draft voiceprint just wrote, within the same session, after an approval was logged.

Use the local timestamp in `YYYY-MM-DDTHH:MM` form. The `<register-name>` is the slug used for the matching register (e.g. `social-posts`, `client-comms`). The full approved text goes into the blockquote, even if it is long, completeness matters more than tidiness here, because review time has only what was captured.

**Three pieces are captured, patterns are not:**

| Captured | Why it matters at review time |
|---|---|
| **You asked** | Reminds the user what they were trying to make |
| **Final approved version** | The actual artifact whose voice we are learning from |
| **Changes from first draft** | The strongest signal, the full distance between AI default and the user's real voice |

Pattern extraction happens at *review time*, not capture time. Capture is fast and lossless; analysis is slower and more accurate when the user is paying attention to the result.

## Auto-prompt at threshold

When the entry count in `lessons.md` crosses a multiple of `review_threshold` (default 5), voiceprint asks the user once whether to review:

```
I've noticed N patterns in the last few drafts.
Want to review them with me?

  [1] Yes — let's review
  [2] Later
  [3] Other — specify
```

`[1]` → run the review flow (next section). `[2]` → defer. Voiceprint stays quiet until the count crosses the *next* multiple of `review_threshold`. No nagging within a threshold window.

`review_threshold` lives in `voice-profile.md` frontmatter. Default 5. `0` disables auto-prompts entirely (manual-only mode). Update the frontmatter when the user asks:

| User says | Set `review_threshold` to |
|---|---|
| "review every 3" / "smaller batches" | 3 |
| "review every 10" | 10 |
| "stop auto-prompting reviews" / "manual only" | 0 |

When `review_threshold` is `0`, the auto-prompt is disabled. The user runs reviews on demand by saying "voiceprint review" (or similar — judge intent).

## Review flow (pattern-level co-creation)

Triggered by the auto-prompt at threshold OR by explicit "voiceprint review".

**This replaces the v0.6.0 per-entry Approve / Reject / Edit / Skip loop entirely.** v0.6.0's per-entry decision model is removed in alpha 0.7.0. Review is now collaborative pattern-level: voiceprint extracts and shows all patterns, the user co-creates, then voiceprint writes once on explicit confirmation.

Review is a **reflection session**, not a batch operation. Setup is voiceprint absorbing material the user hands over; review is voiceprint reflecting on shared work with the user.

**Behaviour:**

1. Read all entries from `lessons.md`. Each entry has the v0.6.0 schema: timestamp, register, *You asked*, *Final approved version*, *Changes you made*. Schema unchanged in alpha 0.7.0.

2. Pattern analyser extracts patterns across the entries, using the captured *You asked / Final approved / Changes you made* triples as raw signal.

3. **Present proposed patterns and their destinations** — clean and tight, no evidence dump by default. Lesson chunks are only shown if (a) the user asks "why did you extract that?" or (b) voiceprint needs to surface a chunk for clarity.

   ```
   I've reviewed the last N drafts. Here's what I'm seeing:

   Pattern 1 — voice-profile.md
   "Land the point and stop. No wrap-up sentence."

   Pattern 2 — registers/social-posts.md
   "Open with a one-line observation, not a hook."

   Pattern 3 — voice-profile.md
   "'Shape of it' over 'structure of it'."

   What do you think? Anything to refine, push back on, or add?
   Ask me about any pattern if you want to see what triggered it.
   ```

4. **Open dialogue.** User can say "show me what triggered pattern 1", "that's more register-specific than cross-register", "rephrase pattern 3", or flag a pattern as wrong. Voiceprint responds, surfaces lesson chunks when asked or needed for clarity, adjusts, surfaces glaring contradictions if any emerge.

5. **Confirm before writing.** When the user looks satisfied (after one or more refinement rounds, or straight away), voiceprint asks an explicit confirm prompt:

   ```
   Ready for me to write these to your voice profile?

     [1] Yes — write them
     [2] One more change first
     [3] Other — specify
   ```

   Voiceprint **does not infer satisfaction from silence**. The user must affirmatively pick `[1]` (or say something equivalent — "yes", "go ahead", "write them") before any write happens. If `[2]`, go back to step 3 with the latest state.

6. Populator distributes the agreed-upon patterns across `voice-profile.md` and matching `registers/<name>.md` files. Same dedupe and glaring-contradiction checks as setup.

7. **Clear processed entries from `lessons.md`.** Counter resets to 0.

8. Show transparency summary in the same shape as setup:

   ```
   Done. Wrote the patterns we discussed:

   voice-profile.md (+3 entries)
     - Land the point and stop
     - "Shape of it" over "structure of it"
     - ...

   registers/social-posts.md (+1 entry)

   lessons.md cleared. Next review at +N drafts.

   Edit any file by hand if anything looks off.
   Open a new session for changes to take effect.
   ```

If no patterns emerge clearly, voiceprint says so plainly in step 3 and asks:

```
I've reviewed the last N drafts. Nothing's clear enough yet to
extract as a rule — your voice on these reads consistent with
what's already in voice-profile.md.

  [1] Clear lessons.md and reset counter
  [2] Hold lessons for next review — counter continues
  [3] Other — specify
```

The summary is a checkpoint, not a wall. Same as setup — after the summary, the user can still challenge any entry, voiceprint edits files in real-time.

**End-of-review reminder:** tell the user to open a new session for the new patterns to take effect (in-context copies are stale until reload).

## Reset

Triggered by "voiceprint reset", "start voice profile over", or any phrase voiceprint reads as that intent. The only destructive path; never the default.

Confirmation required:

```
Reset voice profile? This archives the current file and starts blank.

  [1] Yes — archive and reset
  [2] No — cancel
  [3] Other — specify
```

If `[1]`: rename `voice-profile.md` to `voice-profile.md.bak-YYYY-MM-DD` (using whatever rename primitive the harness exposes — Bash `mv`, write+delete pair, or equivalent), then write a fresh template with `setup_complete: false`. Next voiceprint activation will re-trigger the permission question.

`registers/`, `samples/`, and `lessons.md` are **not** touched by reset — only `voice-profile.md` is archived. The user can manually clear those folders if they want a deeper reset.

## Capture reliability and failure mode

The capture-logging instruction is probabilistic, Claude must remember the rule across turns. In practice it is reliable, because the same auto-memory mechanism that runs CLAUDE.md instructions runs this one.

If an approval is missed, that approval will simply not appear in `lessons.md`. The review flow mitigates this by also scanning the current session's transcript directly for approvals when a review is invoked, so recent missed approvals are recovered. Approvals missed in past sessions are unrecoverable, the conversation is gone, and that is the accepted cost of being plugin-free and hook-free.

**Error handling, single rule: never silently corrupt user data.**

- If `voice-profile.md` is **missing** (file does not exist), treat as new user, copy from template.
- If `voice-profile.md` **exists but is unreadable** (sync conflict, partial corruption, permission issue), stop and surface a clear repair message. Tell the user which file is unreadable, where it lives, and what to check (sync conflict, permissions, manual edit gone wrong). Stay paused on writes until the file is repaired or moved aside.
- If a required frontmatter field is **missing or invalid** (`review_threshold` deleted or set to a non-number, etc.), silently fall back to the default value AND write the default back into the frontmatter. Self-healing, no warning.
- If `lessons.md` is malformed (one bad entry), skip the bad entry and proceed with the rest.
- All writes use Claude's built-in file tools, no shell scripting, no platform-specific quirks.
- No per-write `.backup.md` files. Sync (Dropbox / iCloud / Syncthing / git) is the user's backup story; the README documents this.
