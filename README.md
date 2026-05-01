# voiceprint

A self-improving writing-voice skill for Claude Code (Mac, Linux, Windows), from [Saige Circle](https://saigecircle.com). Strips AI tells (em dashes, "It's not just X, it's Y", banned vocabulary, generic warmth) by default. Learns your actual voice over time as you approve outputs.

## What's new in alpha 0.7.1

- **Onboarding flow.** Voiceprint now asks at first activation whether you want to seed your voice profile from an existing voice doc or 3–5 writing samples. Day-one drafts sound like you instead of starting from a generic baseline.
- **Voice profile populates across four sections.** Setup and review distribute across *Voice in a sentence* (the north-star line), *Cross-register notes*, *Things to avoid* (your specific bans on top of the humanizer floor), and *Voice anchors* (your characteristic phrases). Earlier alpha builds only populated cross-register rules.
- **Intelligent populator.** Setup writes proposed entries directly, then shows a short transparency summary. Co-create after the summary if anything's off.
- **Pattern-level review.** Reviews now ask *"embed the learnings?"* and on yes show the patterns voiceprint noticed in plain English with a concrete example each, then offer Update / Ignore all / Other (refine). Replaces the v0.6.0 per-entry approve/reject/skip loop.
- **Empty-lessons review handler.** When lessons.md is empty (or just cleared), voiceprint tells you you're current with a warm one-liner instead of forcing a menu through.
- **`profile.md` is now `voice-profile.md`.** Templates renamed accordingly.
- **Cross-harness compatibility maintained.** All prompts are plain-text MCQs — Claude Code, Codex, Copilot CLI, Gemini CLI all work the same way.

## Why voiceprint exists

LLM output has a recognisable AI voice. Most non-technical users can feel it but don't know how to fix it beyond pasting "write in my voice" into a prompt. Voiceprint fills that gap: a single skill install that strips AI tells from every draft and quietly learns your real voice over time, with your approval. No telemetry, no network calls, all local markdown.

## Install

Two paths. Pick whichever feels easier.

### Option A, paste-and-tell (recommended)

Paste this into Claude Code:

    https://github.com/saigecircle/voiceprint

    Add this skill to my system.

Claude fetches the skill into `~/.claude/skills/voiceprint/`. That's it. The skill auto-activates whenever Claude produces output another person will read, clients, followers, teammates, collaborators, anyone besides you.

### Option B, CLI

    claude skill add --url https://raw.githubusercontent.com/saigecircle/voiceprint/main/SKILL.md

For users who prefer the command line.

## Where your voice lives

`~/Documents/Voiceprint/` by default. You can move it anywhere, your Obsidian vault, Dropbox, iCloud, by telling voiceprint where to put it. Voiceprint moves the folder and remembers the new location automatically.

```
~/Documents/Voiceprint/
├── voice-profile.md ← your core voice (cross-register rules)
├── lessons.md     ← rolling capture log of approved drafts
├── samples/       ← raw writing samples from setup
└── registers/     ← per-context voice notes (social, email, blog, etc.)
```

It's all plain markdown. Read it, edit it, sync it.

**Backup.** Sync the folder somewhere (Dropbox, iCloud, Syncthing, git). Voiceprint does not write `.backup.md` files; sync is your backup story.

## How it works

- **Setup (optional but recommended):** say *"voiceprint setup"* — voiceprint asks whether to import an existing voice doc or take 3–5 writing samples, then seeds your profile so day-one drafts sound like you. The flow is also offered automatically on first activation.
- **Generate from scratch:** ask Claude to draft a LinkedIn post, an email, a blog intro. Voiceprint applies humanizer rules silently. Output already feels less AI-ish.
- **Polish what you wrote:** paste your own draft and say *"voiceprint this"*, *"polish this client email"*, *"tighten this Slack message"*, *"finesse this"*, or *"make this sound more like me"*. Voiceprint runs your text through the humanizer floor, your voice profile, and the matching register, preserving the parts that already sound like you.
- **Daily use:** type *"perfect"*, *"send it"*, *"that's it"* on outputs you like. Voiceprint quietly notes the prompt, the final draft, and any edits you made.
- **Review:** after every 5 approved drafts, voiceprint asks *"embed the learnings into your voice profile?"* Say yes, and voiceprint shows the patterns it's seeing in plain English with a concrete example each, then asks what to do: **Update** (write them), **Ignore all** (clear and reset), or **Other** (refine, drop, move). Approved patterns sharpen your voice from that point on. You can change the review cadence any time, *"make it 3"*, *"every 10 instead"*, or go manual. In manual mode voiceprint stays quiet until you ask: *"voiceprint review"*.

## Want a `/voiceprint` shortcut?

Voiceprint does not ship a slash command. If you want one, tell Claude:

> Create a `/voiceprint` slash command at `~/.claude/commands/voiceprint.md` that activates the voiceprint skill and passes through `$ARGUMENTS`.

Claude generates the file. You own the command.

## Updates

Paste this into Claude Code:

    https://github.com/saigecircle/voiceprint

    Update voiceprint to latest.

Claude re-fetches the repo into `~/.claude/skills/voiceprint/`, replacing the skill files wholesale. Your data folder (`~/Documents/Voiceprint/`) is completely separate and never touched. Skill updates always reach you with no migration step.

## What it does NOT do

- Doesn't send any data anywhere. Everything is local.
- Doesn't activate on code or notes only you will read (a private journal entry, a scratchpad). Anything with an audience, internal or external, gets voice. You can always force it on a personal note by saying *"voiceprint"* explicitly.
- Doesn't try to replace your voice, it learns *with* you, not without you.

## License

MIT. Built by [Saige Circle](https://saigecircle.com). Humanizer rules derived from the public-domain [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) guide.
