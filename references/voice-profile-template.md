---
voiceprint_version: alpha 0.8.0
review_threshold: 5
setup_complete: false
setup_method:
last_setup_run:
---

# Voice profile

This file holds your voice. Voiceprint reads it on every draft.

It has two roles:

- **Sections 1–4** are *your* voice — what you write like, what you avoid, the phrases you reach for. Voiceprint adds to these at setup time and during reviews, with your input. Edit anything by hand at any time.
- **Section 5 (Floor)** is the canonical AI-tells list — the rules that strip "this sounds AI-written" from every draft. Sacred by default: capture never logs Floor changes, review never proposes them. Edit by hand only when a global rule genuinely needs to change for your voice.

## Voice in a sentence

A short north-star line that captures how you sound at your best. Voiceprint distils this from your voice doc or samples at setup, and refines it during reviews when a clearer summary emerges. One or two sentences max — this is the orientation line, not the full picture.

## Cross-register notes

Voice rules that apply across every register. Setup-imported and review-approved patterns destined for "core profile" land here.

## Things to avoid

Words, phrases, or moves that don't sound like you, regardless of register. *Your* specific bans, on top of the Floor below.

## Voice anchors

Short snippets, phrases, or one-liners that capture how you sound at your best. Reference points for voiceprint when generating drafts.

## Floor (sacred — manual edit only)

These rules apply to every draft, regardless of register. Capture never logs them. Review never proposes changes here. Edit by hand if a global rule genuinely needs to change for your voice — e.g. "I actually use em dashes" → delete the em-dash ban below.

### Banned shapes

- No em dashes (—) anywhere — no exceptions for emphasis or separation
- No "It's not just X, it's Y" / "Not only X, but Y" / "It's not X, it's Y"
- No "In a world where..." openings
- No "Let's dive in" / "Let's unpack this" / "Buckle up"
- No "I hope this finds you well" / "Hope you're doing well" openings
- No "In conclusion" / "Ultimately" / "All in all" / "In summary" closings
- No "At the end of the day" as a closer
- No "X stands as a testament to..." / "X serves as a reminder that..."
- No "X represents a shift in..." / "X marks a turning point..."
- No "This underscores/highlights/emphasises the importance of..."
- No closing rhetorical questions to the reader ("So, what's next for you?")
- No vague attribution ("Industry reports suggest...", "Experts argue...", "Observers have cited...")
- No knowledge-cutoff disclaimers ("As of my last update...", "I don't have access to...")
- No apologetic AI framing ("I'm just an AI...", "I cannot verify...")
- No forced rule-of-three when the content doesn't have three things
- No symmetric parallelism (every clause same length and shape)
- No adjective-adjective-adjective stacking ("bold, vibrant, enduring")
- No elegant variation (swapping synonyms to avoid repeating a noun)
- No inline-header bullets (`**Header:** sentence`) used row after row
- No "key takeaways" or "TL;DR" block tacked onto short content
- No section summary recaps at the end of short pieces
- No mid-sentence pivots that reverse the claim ("While X, it's also true that not-X")
- No "Despite challenges... future outlook" closing arc

### Banned punctuation and structure

- No en dashes (–) used in place of em dashes or commas
- No curly quotes — use straight quotes (`"` and `'`)
- No excessive bolding for emphasis (every key term bolded)
- No Title Case in regular sentences and inline phrases
- No Title Case in section headings — use sentence case
- No horizontal rules (`---`) inserted before every heading
- No emoji used as bullet markers or section dividers
- No tables for two or three rows of data that read fine as prose
- No bullet lists where two or three sentences of prose would do
- No headers on every short paragraph
- No numbered lists for items that aren't actually sequential

### Banned vocabulary

**Pretentious verbs (replace with plain):** delve, leverage, utilise/utilize, navigate (figuratively), foster, cultivate, garner, underscore, highlight (figuratively), emphasise/emphasize (overused), showcase, exemplify, encompass, align with, resonate with, bolster, enhance, ensure (overused), boast, nestled

**Empty modifiers (cut or specify):** robust, comprehensive, seamless, intricate, multifaceted, nuanced (overused), vibrant, rich (figurative), profound, enduring, meticulous, pivotal, crucial, vital, key (adjective, overused), significant (overused), valuable (overused), diverse array, vast array

**Marketing slop (cut):** game-changer, paradigm shift, transformative, revolutionary, groundbreaking, cutting-edge, state-of-the-art, next-generation, world-class, best-in-class, unparalleled, unprecedented (overused), in the heart of, at the forefront of, renowned, leading

**Forced poetic (cut):** tapestry, mosaic, kaleidoscope, journey (figurative, overused), landscape (figurative, overused), ecosystem (figurative, overused), realm (figurative), symphony, dance (figurative), weave/woven (figurative), indelible mark, deeply rooted, focal point

**AI rhythm connectors (cut or use "also"):** Furthermore, Moreover, Additionally, Notably, Importantly, Indeed

**Copula avoidance (use plain "is/are/has"):** serves as → is, stands as → is, represents → is, marks → is, embodies → is, constitutes → is, boasts → has, features → has, maintains → has/keeps, offers (when meaning "has") → has

### Default tone

- Plain Anglo-Saxon over Latinate (use not utilise, stop not cease, show not demonstrate, help not facilitate, start not commence, end not terminate, buy not purchase, ask not enquire)
- Contractions are fine (don't, it's, we're, that's)
- Sentence fragments are fine for rhythm. Used sparingly.
- Vary sentence length deliberately. AI defaults to evenly paced; mix short and long.
- One idea per sentence, mostly. Compound sentences are fine; piling clauses to sound thoughtful is not.
- No emoji unless your samples use them
- No hashtags unless your samples use them
- Hedge stacks are banned ("may potentially possibly", "can sometimes occasionally")

### Keep — don't strip

- Specific numbers, names, places, dates
- Concrete sensory detail
- An actual opinion, stated plainly
- A real anecdote with a real outcome
- Admitted uncertainty ("I'm not sure", "I might be wrong about this")
- A direct question to the reader (used sparingly, not as a closer formula)

### Override mechanism

A pattern banned above is a default, not an absolute. If your voice genuinely uses one (e.g., you actually write "leverage" in a professional context, or you open client emails with "Hope you're well"), edit the relevant line out of the Floor or add an explicit override in *Things to avoid* / *Cross-register notes* naming the exception.
