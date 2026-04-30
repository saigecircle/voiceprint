# Humanizer floor

The humanizer rules are the floor every voiceprint draft sits on. They strip the
patterns that make text read as AI-generated, regardless of register.

These rules apply BEFORE any user-specific voice profile or register file. Voice
profile and register files override only where the user has explicitly approved
a deviation (e.g. "I do use em dashes — keep them").

## Banned punctuation

- Em dashes (—) used as sentence separators or for "punched-up" emphasis
- En dashes (–) used in place of em dashes or commas
- Curly quotes (" " ' ') — use straight quotes (" ')
- Excessive bolding for emphasis (every key term bolded)
- Title Case in regular sentences and inline phrases
- Title case in section headings (use sentence case)
- Horizontal rules (---) inserted before every heading
- Emoji used as bullet markers or section dividers
- Tables for two or three rows of data that read fine as prose

## Banned sentence shapes

- "It's not just X, it's Y"
- "Not only X, but (also) Y"
- "It's not X, it's Y"
- "No X, no Y, just Z"
- "In a world where..."
- "Let's dive in" / "Let's unpack this" / "Buckle up"
- "I hope this finds you well" / "Hope you're doing well" openings
- "I'd be happy to help" / "Great question" openings
- "In conclusion" / "Ultimately" / "All in all" / "In summary" closings
- "At the end of the day" as a closer
- Hedge stacks ("may potentially possibly", "can sometimes occasionally")
- "Despite its [positive adjective], X faces several challenges..."
- "X stands as a testament to..." / "X serves as a reminder that..."
- "X represents a shift in..." / "X marks a turning point..."
- "This underscores/highlights/emphasises the importance of..."
- "X plays a vital/crucial/pivotal/key role in..."
- "Industry reports suggest..." / "Experts argue..." / "Observers have cited..."
  (vague attribution with no named source)
- "Such as" introducing a list that is actually exhaustive
- Knowledge-cutoff disclaimers ("I don't have access to...", "As of my last
  update...")
- Apologetic AI framing ("I cannot verify...", "I'm just an AI...")

## Banned vocabulary

Replace each with the suggested plainer word, or cut entirely if it adds nothing.

### Pretentious verbs

- delve → look at, dig into, examine
- leverage → use
- utilise / utilize → use
- navigate (figuratively) → handle, get through, work through
- foster → build, grow, encourage
- cultivate → build, grow
- garner → get, attract, win
- underscore → show, point to, stress
- highlight (figuratively) → show, point to
- emphasise / emphasize (overused) → say, stress, point to
- showcase → show
- exemplify → show, be an example of
- encompass → cover, include
- align with → match, fit, agree with
- resonate with → match, ring true for
- bolster → strengthen, back up
- enhance → improve, strengthen
- ensure (overused) → make sure, see that
- boast → has (use a plainer verb)
- nestled → sits, is

### Empty modifiers

- robust → cut, or use "solid", "reliable"
- comprehensive → cut, or use "full", "complete"
- seamless → cut, or use "smooth"
- intricate → cut, or use "detailed"
- multifaceted → cut, or use "many-sided"
- nuanced (overused) → cut, or be specific
- vibrant → cut, or use a concrete colour/quality
- rich (figurative) → cut, or be specific
- profound → cut, or use "deep"
- enduring → cut, or use "lasting"
- meticulous / meticulously → cut, or use "careful"
- pivotal → cut, or use "important"
- crucial → cut, or use "important", "needed"
- vital → cut, or use "important", "needed"
- key (as adjective, overused) → cut, or use "main"
- significant (overused) → cut, or use "big", "real"
- valuable (overused) → cut, or be specific about the value
- diverse array → cut, or use "range"
- vast array → cut, or use "range"

### Marketing slop

- game-changer → cut
- paradigm shift → cut
- transformative → cut, or be specific
- revolutionary → cut, or be specific
- groundbreaking → cut, or be specific
- cutting-edge → cut, or be specific
- state-of-the-art → cut, or be specific
- next-generation → cut, or be specific
- world-class → cut
- best-in-class → cut
- unparalleled → cut
- unprecedented (overused) → cut, or be specific
- in the heart of → in
- at the forefront of → cut, or be specific
- renowned → cut, or name what they're known for
- leading (as in "leading expert") → cut, or name the credential

### Forced poetic

- tapestry (figurative) → cut
- mosaic (figurative) → cut
- kaleidoscope (figurative) → cut
- journey (figurative, overused) → cut, or use "path", "process"
- landscape (figurative, overused) → cut, or use "field", "market"
- ecosystem (figurative, overused) → cut, or be specific
- realm (figurative) → cut, or use "field", "area"
- symphony (figurative) → cut
- dance (figurative) → cut
- weave / woven (figurative) → cut
- indelible mark → cut
- deeply rooted → cut, or use "long-standing"
- focal point → cut, or use "centre"

### Connectors that flag AI rhythm

- Furthermore → cut, or use "also"
- Moreover → cut, or use "also"
- Additionally → cut, or use "also"
- Notably → cut, or be specific about why it stands out
- Importantly → cut (if it's important, write it that way)
- Indeed → cut

### Copula avoidance

Prefer plain "is/are/has". Watch for AI substitutes:

- serves as → is
- stands as → is
- represents → is
- marks → is
- embodies → is
- constitutes → is
- boasts → has
- features → has
- maintains → has, keeps
- offers (when meaning "has") → has

## Banned structural moves

- Forced rule-of-three when content doesn't have three things ("X, Y, and Z"
  triplets shoehorned in)
- Symmetric parallelism that reads machine-generated (every clause same length,
  same shape)
- Adjective-adjective-adjective stacking ("a bold, vibrant, enduring brand")
- Elegant variation — swapping synonyms to avoid repeating a noun (calling the
  same person "the artist", "the creator", "the visionary" in three sentences)
- "Despite challenges... future outlook" closing arc
- Bullet lists where two or three sentences of prose would do
- Inline-header bullets (**Bold Header:** descriptive sentence) used for every
  point in a row
- Headers on every short paragraph (over-structuring short content)
- Numbered lists for items that aren't actually sequential
- A "Key takeaways" or "TL;DR" block tacked onto short content
- Section summary recaps at the end of short pieces
- Mid-sentence pivots that reverse the claim ("While X is true, it's also true
  that not-X")
- Closing with a rhetorical question aimed at the reader ("So, what's next for
  you?")

## Default tone

- Neutral global English — avoid US-only spellings (color, organize, center)
  AND AU/UK-only spellings (colour, organise, centre) where a neutral choice
  exists. When forced to pick, follow the user's voice profile; absent that,
  default to forms shared across both registers.
- Plain language: prefer Anglo-Saxon over Latinate where both work
  ("use" not "utilise", "stop" not "cease", "show" not "demonstrate",
  "help" not "facilitate", "start" not "commence", "end" not "terminate",
  "buy" not "purchase", "ask" not "enquire")
- Contractions are fine ("don't", "it's", "we're", "that's")
- Sentence fragments are fine for rhythm. Used sparingly.
- Vary sentence length deliberately. AI defaults to medium-length, evenly paced
  sentences. Mix short and long.
- One idea per sentence, mostly. Compound sentences are fine; piling three
  clauses together to sound thoughtful is not.
- No emoji unless the user's samples use them
- No hashtags unless the user's samples use them
- No "—" em dashes anywhere

## Things to keep, not strip

These read human and should not be flattened:

- Specific numbers, names, places, dates
- Concrete sensory detail
- An actual opinion, stated plainly
- A real anecdote with a real outcome
- Admitted uncertainty ("I'm not sure", "I might be wrong about this")
- A direct question to the reader (used once, not as a closer formula)

## When to break these rules

If the user's voice profile or register file explicitly approves a banned
pattern (because the user actually writes that way), THAT overrides this floor.
The floor is the default; the profile is the user.

Examples of valid overrides:
- The user's samples consistently use em dashes — keep them.
- The user opens with "Hope you're well" in client emails — keep it for that
  register.
- The user genuinely writes "leverage" in a professional context — keep it
  there only.

If unsure whether a pattern is a real user signature or AI seepage in the
samples, flag it rather than silently keeping or stripping.

## Source

Distilled from the Wikipedia community guide *Signs of AI writing*
(en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing), CC BY-SA 4.0 content.
Adapted and condensed for use as a Claude Code skill reference.
