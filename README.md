# voiceprint

A self-improving writing-voice skill for Claude Code (Mac, Linux, Windows), from [Saige Circle](https://saigecircle.com). Strips AI tells (em dashes, "It's not just X, it's Y", banned vocabulary, generic warmth) by default. Learns your actual voice over time as you approve outputs.

## Why voiceprint exists

LLM output has a recognisable AI voice. Most non-technical users can feel it but don't know how to fix it beyond pasting "write in my voice" into a prompt. Voiceprint fills that gap: a single skill install that strips AI tells from every draft and quietly learns your real voice over time, with your approval. No telemetry, no network calls, all local markdown.

## Install

Two paths. Pick whichever feels easier.

### Option A — paste-and-tell (recommended)

Paste this into Claude Code:

    https://github.com/saigecircle/voiceprint

    Add this skill to my system.

Claude fetches the skill into `~/.claude/skills/voiceprint/`. That's it. The skill auto-activates whenever Claude produces output another person will read — clients, followers, teammates, collaborators, anyone besides you.

### Option B — CLI

    claude skill add --url https://raw.githubusercontent.com/saigecircle/voiceprint/main/SKILL.md

For users who prefer the command line.

## Where your voice lives

`~/Documents/Voiceprint/` by default. You can move it anywhere — your Obsidian vault, Dropbox, iCloud — by telling voiceprint where to put it. Voiceprint moves the folder and remembers the new location automatically.

```
~/Documents/Voiceprint/
├── profile.md     ← your core voice (cross-register rules)
├── lessons.md     ← rolling capture log of approved drafts
├── samples/       ← raw writing samples from setup
└── registers/     ← per-context voice notes (social, email, blog, etc.)
```

It's all plain markdown. Read it, edit it, sync it.

**Backup.** Sync the folder somewhere (Dropbox, iCloud, Syncthing, git). Voiceprint does not write `.backup.md` files; sync is your backup story.

## How it works

- **Setup (optional):** say *"voiceprint setup"* for two questions — paste a few samples, name the kinds of writing you do. Each is independently skippable.
- **Generate from scratch:** ask Claude to draft a LinkedIn post, an email, a blog intro. Voiceprint applies humanizer rules silently. Output already feels less AI-ish.
- **Polish what you wrote:** paste your own draft and say *"voiceprint this"*, *"polish this client email"*, *"tighten this Slack message"*, *"finesse this"*, or *"make this sound more like me"*. Voiceprint runs your text through the humanizer floor, your voice profile, and the matching register — preserving the parts that already sound like you.
- **Daily use:** type *"perfect"*, *"send it"*, *"that's it"* on outputs you like. Voiceprint quietly notes the prompt, the final draft, and any edits you made.
- **Review:** after every 5 approved drafts, voiceprint asks if you're ready to look at what it's noticed. Say yes, walk the queue, choose what to keep. Approved patterns sharpen your voice for everything you write from that point on. You can change the review cadence any time — *"make it 3"*, *"every 10 instead"* — or go manual. In manual mode voiceprint stays quiet until you ask: *"voiceprint review"*.

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
- Doesn't activate on code or notes only you will read (a private journal entry, a scratchpad). Anything with an audience — internal or external — gets voice.
- Doesn't try to replace your voice — it learns *with* you, not without you.

## License

MIT. Built by [Saige Circle](https://saigecircle.com). Humanizer rules derived from the public-domain [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) guide.
