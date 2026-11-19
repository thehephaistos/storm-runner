# Storm Runner: Design Calls

Twelve decisions about how Storm Runner plays, taken from Hana Kobayashi's one-page pitch (submitted 2026-10-28). Each one can be checked by playing. Numbers use Dev Malhotra's proposed ranges and stay open until they are fixed in DESIGN_LOG.md.

## 1. The runner never stops

- **Call:** The runner moves forward at 7–9 m/s from the first frame, and no input slows, stops or speeds them up, apart from the burst.
- **Why:** "The runner moves forward on their own and never stops. The player does not control speed."
- **Check:** Start a run and touch nothing. The runner is moving on the first frame and keeps going until the storm catches them.

## 2. Three lanes, one move per input, one hand

- **Call:** The path has 3 fixed lanes, and each press of Left or Right (or one swipe on a phone) moves the runner exactly one lane with a fast snap, so the runner feels light and quick and the game plays the same on a keyboard and a phone.
- **Why:** "Input has to be one key or one thumb so the game plays the same on a laptop keyboard and on a phone." / "the runner should feel light and quick, like they are skimming the ground"
- **Check:** Play one run on a laptop with one hand on the arrow keys and one on a phone with one thumb. Each press or swipe moves exactly one lane.

## 3. The storm is always on screen

- **Call:** The storm wall is on screen behind the runner at all times, and how close it is is shown by the wall itself plus screen edges that darken as it gets close. There is no bar or number.
- **Why:** "The player should always see how close it is."
- **Check:** Play a full run. The wall never leaves the screen, and the edges get darker as it gets closer.

## 4. The storm speeds up and never lets up

- **Call:** Storm speed rises steadily from 5–6 m/s at the start to 8.5–10 m/s at 90 s, with no sudden jumps.
- **Why:** "The storm is a wall that chases the runner and speeds up over the course of the run. Early on, it is a threat on the horizon. By the end, it is right on your heels."
- **Check:** Play a run without bursting. The storm gets closer and closer and is right on your heels by the end.

## 5. The opening teaches without words

- **Call:** No tutorial screen, text box or prompt ever appears, and within the first 10 s the storm visibly closes in, so the player understands that the storm is coming and they cannot stop.
- **Why:** "By the ten-second mark, they should understand that the storm is coming and they cannot stop."
- **Check:** Play the first 10 seconds. No text appears, and you understand the storm is coming.

## 6. The first debris comes alone

- **Call:** The runner starts in the middle lane, and the first piece of debris sits alone in that lane about 3 s into the run, with both other lanes clear.
- **Why:** "They start running, see the storm behind them, meet a piece of debris they have to steer around"
- **Check:** Start a run and touch nothing. At about 3 s you run into a single piece of debris in your lane, with nothing in the other lanes.

## 7. The burst is there when you need it

- **Call:** The burst (Up arrow, or swipe up on a phone) is ready from the first frame, and the player finds it when they need it, the first time the storm gets close.
- **Why:** "...and find the burst when they need it."
- **Check:** In a first run, the player finds the burst when the storm gets close.

## 8. The burst is a decision, not a spam button

- **Call:** The burst throws the runner 6–10 m forward, then needs a 4–6 s cooldown shown by a visible refill, and presses during the refill do nothing.
- **Why:** "It should feel powerful but not spammable. Each burst should be a decision, not something you press every second."
- **Check:** Burst, then press again right away. Nothing happens until the refill is full.

## 9. Debris blocks one lane at a time and gets denser

- **Call:** Each piece of debris (a tree, sign or stretch of broken fencing) blocks one lane, there is always at least one open lane, and spacing tightens from 25–35 m at the start to 12–18 m at 90 s.
- **Why:** "In the path are hazards, mainly fallen debris such as trees, signs and broken fencing."
- **Check:** Play a full run. There is always an open lane, and debris comes faster near the end.

## 10. A hit costs ground, and the storm doesn't wait

- **Call:** Hitting debris slows the runner to half speed for 0.75–1.25 s, and the storm keeps its pace, so it gets closer.
- **Why:** "Hitting one costs the runner ground, and the storm gets closer." / "It never lets up, but when it catches you, you know it was your mistake and not the game cheating."
- **Check:** Hit a piece of debris on purpose. The runner slows, the wall gets closer, and it doesn't drop back afterwards.

## 11. Reaching the shelter wins; the score is metres run

- **Call:** The shelter comes at 90 s, reaching it ends the run as a win, and the score is 1 point per metre run.
- **Why:** "You win by surviving to the shelter at the end of the run, about 90 seconds in." / "A score, probably distance run, gives a reason to replay a run you have already won."
- **Check:** Survive 90 s and reach the shelter. The run ends as a win and shows your score.

## 12. Getting caught ends the run; restart is instant

- **Call:** When the storm reaches the runner the run ends, the score shows, and one press or tap starts a new run straight away, with no menus and no reloading.
- **Why:** "Restarting should be instant, with no menus in the way and no reloading." / "Getting caught should sting, not frustrate."
- **Check:** Get caught, then press any key. A new run starts straight away.

## Conflicts between Dev's ranges and these calls

1. **The storm falls back in the opening (call 5).** With every mix of the ranges, the storm is slower than the runner for the whole first 10 s (the fastest storm is about 6.4 m/s at 10 s; the slowest runner is 7 m/s). The gap grows by about 8–38 m instead of shrinking. At middle values it goes from 25 m to about 48 m.
2. **A run that never bursts still escapes (call 4).** With no hits and no bursts, the gap at 90 s is the starting gap + 90 × (runner speed − the storm's average speed). At middle values that is about +81 m. The call only holds when the runner is at the slow end (7–7.7 m/s) and the storm is at the fast end of both its ranges. This also undercuts "two hits late in the run should be deadly": one hit costs only about 3–6 m.
3. **The wall is hard to keep on screen (call 3).** At middle values the gap peaks at about 100 m around 60 s, before any bursts. Bursting whenever ready adds about 95–230 m more over a run. A phone screen can't show a wall that far back and still show the debris ahead clearly.

Starting the storm at or above runner speed would fix all three, but then bursts carry the whole run, so these numbers need to be tuned together in DESIGN_LOG.md.
