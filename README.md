# voiceprint

A self-improving writing-voice skill for Claude Code (Mac, Linux, Windows), from [Saige Circle](https://saigecircle.com). Strips AI tells (em dashes, "It's not just X, it's Y", banned vocabulary, generic warmth) by default. Learns your actual voice over time as you approve outputs.

Version history lives in [CHANGELOG.md](./CHANGELOG.md).

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

Voiceprint is **project-scoped** as of v0.8. Your voice lives in a `.claude/voiceprint/` folder inside the project you're working in:

```
<your-project>/.claude/voiceprint/
├── voice-profile.md ← your core voice (Floor inlined + cross-register rules)
├── lessons.md      ← rolling capture log of approved drafts
├── samples/        ← raw writing samples from setup
└── registers/      ← per-register voice notes (only earned ones)
```

Different projects can have different voices — your personal vault is one project, a client brand might be another. Voiceprint walks up from the current directory looking for the nearest `.claude/voiceprint/` folder; that folder is the voice for that session.

It's all plain markdown. Read it, edit it, sync it.

**Backup.** Voiceprint folders sync however your project syncs (git, Dropbox, iCloud, Syncthing). Voiceprint does not write `.backup.md` files; sync is your backup story.

## How it works

- **Setup (optional but recommended):** say *"voiceprint setup"* — voiceprint asks whether to import an existing voice doc or take 3–5 writing samples, then seeds your profile so day-one drafts sound like you. The flow is also offered automatically on first activation.
- **Generate from scratch:** ask Claude to draft a LinkedIn post, an email, a blog intro. Voiceprint applies the Floor (AI-tells stripper) silently. Output already feels less AI-ish.
- **Polish what you wrote:** paste your own draft and say *"voiceprint this"*, *"polish this client email"*, *"tighten this Slack message"*, *"finesse this"*, or *"make this sound more like me"*. Voiceprint runs your text through the Floor, your voice profile, and the matching register if one exists, preserving the parts that already sound like you.
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

Claude re-fetches the repo into `~/.claude/skills/voiceprint/`, replacing the skill files wholesale. Your data folder (`<your-project>/.claude/voiceprint/`) is completely separate and never touched. Skill updates always reach you with no migration step.

### Migrating from v0.7.x

v0.7.x stored data at a path recorded in `~/.claude/voiceprint/voiceprint_home.txt`. v0.8 ignores that pointer file. To migrate:

1. Move your existing `voice-profile.md`, `lessons.md`, `registers/`, and `samples/` into `<your-project>/.claude/voiceprint/`.
2. Delete the orphaned `~/.claude/voiceprint/` folder (pointer file lived there).
3. Open a fresh session. Voiceprint walks up from your project's cwd and finds the moved data.

## What it does NOT do

- Doesn't send any data anywhere. Everything is local.
- Doesn't activate on code or notes only you will read (a private journal entry, a scratchpad). Anything with an audience, internal or external, gets voice. You can always force it on a personal note by saying *"voiceprint"* explicitly.
- Doesn't try to replace your voice, it learns *with* you, not without you.

## License

MIT. Built by [Saige Circle](https://saigecircle.com). Floor rules derived from the public-domain [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) guide.
