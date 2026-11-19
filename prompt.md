# Prompt for design_calls.md

This is what to paste into Claude to regenerate `design_calls.md`, the 12 design calls for Storm Runner.

**Before you run it:** the pitch is not in this repo. Put a copy of `Storm Runner One-Page Pitch.md` in the same folder, or change the path in the first line.

**To tweak a call:** change the matching line under "These decisions are already made" and rerun.

## The prompt

```
Read Hana Kobayashi's pitch in "Storm Runner One-Page Pitch.md".
Turn it into exactly 12 design calls for Storm Runner, numbered 1–12.

A design call is one clear decision about how the game plays. Each one must be
something a reviewer can check by playing, with no access to the code. Not a
feeling, not a goal, not something the player "understands".

Players can't see metres or m/s. Every Check must use only what is on screen or
can be counted while playing: the storm wall, the screen edges, the burst icon,
a count of seconds, and the score (1 point per metre, so it works as the
player's ruler).

Use one call per topic, in this order:
1 the runner never stops, 2 steering, 3 showing the storm, 4 storm pressure,
5 the wordless opening, 6 the first debris, 7 finding the burst, 8 the burst
cooldown, 9 debris layout, 10 the cost of a hit, 11 winning and score,
12 losing and restart.

These decisions are already made. Build them in and don't reopen them:
- Runner: at full speed on the first frame and never stops. No input changes
  its speed apart from the burst.
- Steering: 3 fixed lanes. Each press of Left or Right, or one swipe left or
  right on a phone, moves exactly one lane in a fast snap. Holding a key moves
  only one lane. One hand, same on keyboard and phone.
- Showing the storm: the wall itself, always on screen, plus screen edges that
  darken as it gets close. No bar or number.
- Storm pressure: it speeds up smoothly with no sudden jumps. A run that dodges
  everything but never bursts is caught before the shelter.
- Opening: no tutorial screen, no text box, no "press X" pop-up. The wall
  visibly gains on the runner during the first 10 s, even if the player dodges
  everything.
- First debris: the runner starts in the middle lane, and the first piece of
  debris sits alone in that lane about 3 s in, with both other lanes clear.
- Finding the burst: Up arrow, or swipe up on a phone. It works from the first
  frame. Its icon is marked with an up arrow and pulses the first time in each
  run that the screen edges start to darken. Its Check must work in a normal
  run, without hitting debris on purpose.
- Burst cooldown: a cooldown, not a charge. The icon empties and refills, and
  presses before it is full do nothing.
- Debris layout: trees, signs and broken fencing, each blocking exactly one
  lane. All three lanes are never blocked at once. Pieces come closer together
  as the run goes on.
- Hit: half speed for a moment, and the storm keeps its pace. It does not ease
  off after a hit.
- Winning and score: every run that survives 90 s reaches the shelter and wins.
  The shelter comes at a fixed time, not a fixed distance, so a cleaner win
  with well-timed bursts scores more.
- Losing and restart: when the wall reaches the runner, the run ends and the
  score shows. One press or tap starts a new run straight away, with no menus
  and no reloading.

For each call, write four lines:
- Call: the decision, in one sentence.
- Why: the line of the pitch it serves, quoted.
- Check: one test a reviewer can run by playing.
- Numbers: Dev Malhotra's ranges behind the call, or "none". Don't pick final
  values. Those get fixed in DESIGN_LOG.md.

End with a section "Conflicts between Dev's ranges and these calls". Work out
the gap between the storm and the runner from Dev's ranges over the 90 s run,
and list every call the ranges break, with the numbers. Keep the call; don't
change it to fit the ranges.

Don't add anything the pitch doesn't ask for. Use plain language.
Save the result as design_calls.md.
```

## History: the prompts actually used

The prompt above folds these three steps into one. They are kept here so you can see where each rule came from.

1. **First draft** (commit `bd06e82`). The original prompt, word for word, except that the path to the pitch is now just the file name:

   ```
   Read Hana Kobayashi's pitch at "Storm Runner One-Page Pitch.md".
   Turn it into exactly 12 design calls for Storm Runner, numbered 1–12.

   A design call is one clear decision about how the game plays. Each one must be
   something a reviewer can check by playing. Not a feeling, not a goal.

   These decisions are already made. Build them in and don't reopen them:
   - Opening (no tutorial, no text): the runner is at full speed on the first frame
     and never stops. The storm is on screen from the first frame and visibly closes in.
     The first piece of debris sits alone in the path about 3 s in. The burst is ready
     from the first frame, and the player finds it when they need it. By 10 s the player
     knows the storm is coming and they can't stop.
   - Steering: 3 fixed lanes, a fast snap between them, one input per dodge.
   - Storm distance: shown by the wall itself, plus screen edges that darken as it gets
     close. No bar or number.
   - After a hit: the storm keeps its pace. It does not ease off.
   - Burst: a cooldown, ready from the first frame, with a visible refill.

   Cover the whole pitch: the opening, the runner and controls (one hand, plays the same
   on keyboard and phone), the storm, the burst, debris and hits, winning at the shelter,
   losing, instant restart, and score.

   For each call, write:
   1. The call, in one sentence.
   2. Why: the line of the pitch it serves.
   3. How to check it by playing: one test a reviewer can run.

   Where a call needs a number, use Dev Malhotra's ranges, but don't pick final values.
   Those get fixed in DESIGN_LOG.md. If a range conflicts with a call (for example, the
   storm falling back in the first 10 s), keep the call and list the conflict in a short
   note at the end.

   Don't add anything the pitch doesn't ask for. Use plain language.
   Save the result as design_calls.md.
   ```

2. **Playability pass** (commit `53a667b`):

   ```
   Rewrite any call a player can't check just by playing.
   ```

   This rewrote calls 1, 2, 4, 5, 7, 8, 9 and 11, and moved Dev's ranges onto a Numbers line in each call.

3. **Call 7 fix** (commit `65abc91`):

   ```
   Call 7 is the only one where the Check needs you to hit debris on purpose before
   the icon pulses, so you might see if a player would trigger it that way in a
   normal run.
   ```

   This changed call 7's Check to work in a normal run and added conflict 4.
