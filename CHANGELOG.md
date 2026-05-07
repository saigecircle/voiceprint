# Changelog

All notable changes to voiceprint, newest first.

> **Release process — bump versions in lockstep.** When cutting a new release, update the version string in every file that carries one: this CHANGELOG (new heading), `references/voice-profile-template.md` frontmatter (`voiceprint_version`), and any inline references in `SKILL.md` or `README.md`. Grep for the previous version string before tagging.

## alpha 0.8.0

Structural release. Three architectural changes; user-facing surface largely unchanged.

- **Project-scoped data location.** Voiceprint now stores user data in `<project-root>/.claude/voiceprint/`, found by walking up from the current working directory. Different projects can have different voices, no global state, no pointer file. The pointer-file mechanism (`~/.claude/voiceprint/voiceprint_home.txt`) is removed. *Migration:* move existing data into your project's `.claude/voiceprint/` folder and delete the orphaned `~/.claude/voiceprint/` folder. See README *Migrating from v0.7.x*.
- **Floor inlined into voice-profile.md.** The humanizer rules now ship inside `voice-profile.md` as a `## Floor` section, no longer loaded from `references/humanizer.md` at runtime. Faster activation (one less file read per draft) and direct edit access — the Floor is the user's, not the skill's. `references/humanizer.md` is kept as the canonical seed for fresh inits and explicit `voiceprint refresh-floor` operations.
- **Earned-existence registers.** Empty register stubs are no longer auto-created when a trigger keyword matches and no register file exists yet. An empty register imposes preconceptions without enough content to steer well, which actively harms drafts. Registers are now created only when there's earned content — explicitly via "make this a LinkedIn register" or via review when accumulated patterns earn promotion.
- **Deferred to v0.8.1+:** cluster-aware nudge thresholds, 3-MCQ fresh-init path, `voiceprint refresh-floor` command. Existing auto-prompt at threshold (default 5) and Path A/Path B onboarding flows unchanged.

## alpha 0.7.3

- **Sample filenames now use a content slug.** Path A saves cleaned samples to `samples/<YYYY-MM-DD>-<slug>.md` instead of `<YYYY-MM-DD>-<n>.md`. The slug is 2–4 lowercase hyphenated words distilled from the sample's content (hook, theme, signature phrase, addressee), so a folder of samples reads as a table of contents instead of a numbered pile. Same-day collisions append `-2`, `-3`, etc.

## alpha 0.7.2

- **Pre-output check.** Voiceprint now fires on the *output*, not just the request. Borderline cases — a chat reply you might copy into Slack, an email body sketched inline, a caption drafted mid-conversation — trigger activation even when no writing-task verb was used. Closes the failure mode where audience-facing text slipped through because the prompt didn't look like a draft request.
- **Activation block consolidated.** *When to activate* is now a single decision table covering audience-facing output, edits/proofreads, explicit invocation, code, notes-to-self, and raw-output requests. Replaces three overlapping prose blocks.
- **Onboarding gate consolidated.** *Permission question* is the single source of truth for the gate. *Response order* step 2 is a one-line pointer.
- **Output caps deduplicated.** Caps live in *Intelligent populator* only. Path A and Path B reference instead of restating.
- **Version archaeology removed from SKILL.md.** Spec reads as current behaviour; CHANGELOG owns version history.

## alpha 0.7.1

- **Onboarding flow.** Voiceprint now asks at first activation whether you want to seed your voice profile from an existing voice doc or 3–5 writing samples. Day-one drafts sound like you instead of starting from a generic baseline.
- **Voice profile populates across four sections.** Setup and review distribute across *Voice in a sentence* (the north-star line), *Cross-register notes*, *Things to avoid* (your specific bans on top of the humanizer floor), and *Voice anchors* (your characteristic phrases). Earlier alpha builds only populated cross-register rules.
- **Intelligent populator.** Setup writes proposed entries directly, then shows a short transparency summary. Co-create after the summary if anything's off.
- **Pattern-level review.** Reviews now ask *"embed the learnings?"* and on yes show the patterns voiceprint noticed in plain English with a concrete example each, then offer Update / Ignore all / Other (refine). Replaces the v0.6.0 per-entry approve/reject/skip loop.
- **Empty-lessons review handler.** When lessons.md is empty (or just cleared), voiceprint tells you you're current with a warm one-liner instead of forcing a menu through.
- **`profile.md` is now `voice-profile.md`.** Templates renamed accordingly.
- **Cross-harness compatibility maintained.** All prompts are plain-text MCQs — Claude Code, Codex, Copilot CLI, Gemini CLI all work the same way.
