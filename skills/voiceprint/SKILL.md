---
name: voiceprint
description: Apply the user's writing voice to drafts. Triggers on requests to write, draft, compose, post, or publish a piece of content (LinkedIn / X / Instagram / Facebook / TikTok / blog / newsletter / email / message / DM / reply / thread / caption / headline / bio / ad copy). Strips AI tells (em dashes, "It's not just X, it's Y", banned vocabulary) and applies the user's profile from ~/.voiceprint/. Does NOT trigger on code generation, summarisation, edit-on-supplied-text, or how-to / explanation requests.
---

## When to activate (be strict)

ACTIVATE when the user asks for a piece of writing to be created from scratch:

- Verbs: write, draft, compose, post, publish, send, pen, craft + (a / an / the / some)
- Output objects: post, caption, email, message, reply, DM, comment, ad copy, blog, article, newsletter, thread, tweet, story, bio, headline, subject line
- Platform tells: LinkedIn, X, Twitter, Instagram, Facebook, TikTok, blog, newsletter, Slack, WhatsApp

DO NOT activate when:

- The user wants code, scripts, or technical configuration
- The user asks to summarise, extract, or analyse
- The user supplies their own draft for editing or proofreading (their voice is already there)
- The user asks for an explanation, how-to, or teaching content
- The request is about voice/profile management (those go to /voiceprint commands)

If unsure, do NOT activate — better to miss a draft than impose voice on a non-writing task.

## How to apply voice

On activation, in order:

1. Load `references/humanizer.md` — bundled rules, the floor every output must respect.
2. If `~/.voiceprint/profile.md` exists, read its frontmatter version + `## User additions` section.
3. Pick the matching register from the decoder below. If `~/.voiceprint/registers/<register>.md` exists, load it. If it doesn't but the prompt matched a known register, create an empty stub (copy from `references/register-template.md`, fill the `register:` and `created:` frontmatter fields) so future lessons have somewhere to land.
4. Concatenate in order — humanizer floor → user additions → register-specific notes — into the working voice context for this draft.
5. Generate the draft applying every rule from the working voice context.
6. If `~/.voiceprint/` did not exist before this invocation, after returning the draft, append one line: *"Voiceprint is using default humanizer rules. Run /voiceprint setup when you'd like to teach it your actual voice."* Set a marker file `~/.voiceprint/.nudged` so the nudge never repeats.

## Register decoder

Match the user's prompt against the trigger column. First match wins. If nothing matches, write from `profile.md` only (no register layer).

| Trigger keywords | Register | File |
|---|---|---|
| LinkedIn, social post, IG, Instagram, Facebook post, FB post, TikTok caption, Threads, Bluesky | social-posts | `registers/social-posts.md` |
| email to (a person), reply to, message to, WhatsApp, DM, Messenger, client check-in, follow-up | client-comms | `registers/client-comms.md` |
| ad copy, ad headline, campaign copy, landing page copy, sales page, brand positioning | advocacy | `registers/advocacy.md` |
| support ticket, help request, vendor email, platform email (Stripe, systeme, Meta) | support-provider | `registers/support-provider.md` |
| message to a friend, casual reply, group chat, banter | friends-casual | `registers/friends-casual.md` |
| blog post, article, newsletter, long-form, essay | blog-newsletter | `registers/blog-newsletter.md` |

## First run

If `~/.voiceprint/` does not exist:

1. Create the folder.
2. Copy `references/profile-template.md` (in the plugin folder) to `~/.voiceprint/profile.md`. Fill the `created:` frontmatter date with today's date.
3. Create empty `~/.voiceprint/pending-lessons.md` and `~/.voiceprint/rejected-lessons.md`.
4. Proceed with the draft. After returning it, emit the one-time setup nudge from Section 2 step 6.
