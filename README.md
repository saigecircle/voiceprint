# voiceprint

A self-improving writing-voice skill for Claude Code, from [Saige Circle](https://saigecircle.com). Strips AI tells (em dashes, "It's not just X, it's Y", banned vocabulary) by default. Learns your actual voice over time as you approve outputs.

## Install

Paste these two lines into Claude Code:

    /plugin marketplace add saigecircle/voiceprint
    /plugin install voiceprint@voiceprint

That's it. The skill auto-activates when you ask Claude to write something.

## How it works

- **Day one:** ask Claude to draft a LinkedIn post, an email, a blog intro — voiceprint applies humanizer rules silently. Output already feels less AI-ish.
- **Setup (optional):** run `/voiceprint setup` for two questions — paste a few samples, name the kinds of writing you do. Each is independently skippable.
- **Daily use:** type *"perfect"*, *"send it"*, *"that's it"* on outputs you like. Voiceprint quietly notes what was good.
- **Review:** when 3 lessons pile up, voiceprint nudges you. Run `/voiceprint review`. Approve, reject, edit, or skip each. Approved lessons land in your profile.

## Where your voice lives

`~/.voiceprint/` — outside the plugin folder, so plugin updates never touch it.

```
~/.voiceprint/
├── profile.md             ← your core voice
├── registers/             ← per-context tweaks (social, email, blog, etc.)
├── samples/               ← raw writing samples you pasted during setup
├── pending-lessons.md     ← lessons captured but not yet reviewed
└── rejected-lessons.md    ← patterns you've explicitly rejected
```

It's all plain markdown. Read it, edit it, sync it to Dropbox/iCloud, share it with another machine.

## Slash commands

| Command | What it does |
|---|---|
| `/voiceprint setup` | Two-question setup — paste samples + name what you mainly write |
| `/voiceprint review` | Walk pending lessons, approve / reject / edit / skip each |

Other things you might want, done with shell:

- See your profile: `cat ~/.voiceprint/profile.md`
- Back up: copy or sync `~/.voiceprint/`
- Reset to defaults: `rm -rf ~/.voiceprint/` (next draft recreates it)
- Share: zip `~/.voiceprint/` and send

## What it does NOT do

- Doesn't send any data anywhere. Everything is local.
- Doesn't activate on code, summarisation, or editing existing text.
- Doesn't try to replace your voice — it learns *with* you, not without you.

## Philosophy

We believe the most valuable thing about a piece of writing is that a real human wrote it, in their own voice, from their own experience. Voiceprint helps you keep your voice when you use AI as a draft partner — instead of flattening into AI-default.

## License

MIT. Built by [Saige Circle](https://saigecircle.com). Humanizer rules derived from the public-domain [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) guide.
