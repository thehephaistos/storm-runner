# Prompt: playable game from the 12 design calls

Given to Claude Code, started in this repo with the Godot MCP connected.

```
Build Storm Runner into a playable game from all 12 design calls in design_calls.md,
on top of the existing 60-tick loop (scripts/main.gd, scripts/tuning.gd). Then write
a build note for every call in a new DESIGN_LOG.md.

Rules that keep the game the same on every machine
- Keep physics/common/physics_ticks_per_second = 60. All gameplay (movement, lanes,
  burst, cooldown, debris, hits, storm, score, win and lose) runs in
  _physics_process and counts ticks, never clock time or drawn frames.
- Debris layout comes from a fixed seed or a fixed pattern, so the same inputs give
  the same run on any machine.
- Every number lives in scripts/tuning.gd.

Controls (design call 2 and call 7)
- Left and Right arrows move exactly one lane out of 3, with a fast snap. Holding a
  key moves only one lane. The Up arrow is the burst. Down does nothing.
- Swipes left, right and up do the same on a touch screen.
- Restart: one press or tap after being caught or after winning.

Build every call as written, with plain shapes (no art or sound needed)
- The runner never stops. The storm wall is always on screen, with screen edges
  that darken as it gets close. There's no text, tutorial or pop-up during play.
- The first debris sits alone in the middle lane about 3 s in. The burst icon is
  marked with an up arrow, refills visibly, and pulses the first time the edges
  darken. A hit means half speed for a moment while the storm keeps its pace. The
  shelter comes at 90 s. The score is metres run, shown during play and on the end
  screen.
- Don't add anything the calls don't ask for.

Numbers
- Pick final values that make every Check in design_calls.md pass. Stay inside
  Dev's ranges where you can. Where a call can't be met inside them (see the four
  conflicts at the end of design_calls.md), step outside the range and say why.

DESIGN_LOG.md: one entry per call, in this format
  DC-01 · <category> · <short name>
  <the call, in one sentence>
  Status: built / partly built / not built
  Build note
  Built in: the scenes and scripts changed, and what was added to each.
  Values used: the actual numbers, with units and tick conversions
  (60 ticks = 1 s), and any reset rules. Mark values outside Dev's ranges.
  Steady-speed check: where it runs (_physics_process) and what it counts (ticks).
  See it in the build: the call's Check, as one action and the result to see.
End the file with an empty section, "Changed after playing", for me to fill in.

Check it before you finish
- Use the Godot MCP to run the game and read its output. There must be no errors.
- Rerun the parity check at 30 and 60 fps caps with no input. Distances must match
  (2% or less, should be 0).
- Tell me which Checks you confirmed by running the game and which ones need a
  person to play.
- Save this prompt as prompts/game.md, then commit and push.
```
