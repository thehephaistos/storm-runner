# Storm Runner: Design Calls

Twelve decisions about how Storm Runner plays, taken from Hana Kobayashi's one-page pitch (submitted 2026-10-28). Every call can be checked by playing the game, with no access to the code.

Each call has:

- **Call:** the decision, in one sentence.
- **Why:** the line of the pitch it serves.
- **Check:** one test a reviewer can run by playing.
- **Numbers:** Dev Malhotra's proposed ranges behind the call. They stay open until they are fixed in DESIGN_LOG.md.

Players can't see metres or m/s, so the checks use what is on screen: the wall, the screen edges, the burst icon, a count of seconds, and the score, which counts 1 point per metre (call 11).

## 1. The runner never stops

- **Call:** The runner is already running on the first frame and keeps one steady speed that no input can stop or change, apart from the burst.
- **Why:** "The runner moves forward on their own and never stops. The player does not control speed."
- **Check:** Start a run and steer around everything for 10 s without bursting. The runner was moving on the first frame, and the score climbs at one steady rate, 7–9 points a second, however you steer.
- **Numbers:** runner speed 7–9 m/s.

## 2. Three lanes, one move per input, one hand

- **Call:** The path has 3 fixed lanes, and each press of Left or Right on a keyboard, or each swipe left or right on a phone, moves the runner exactly one lane in a snap, with no drifting in between.
- **Why:** "Input has to be one key or one thumb so the game plays the same on a laptop keyboard and on a phone." / "the runner should feel light and quick, like they are skimming the ground"
- **Check:** Press Right twice as fast as you can. The runner lands in the next lane before your second press, then in the one after. Hold Right down and the runner moves only one lane. Swipes on a phone give the same result.
- **Numbers:** Dev's table has no snap time. It gets set in DESIGN_LOG.md.

## 3. The storm is always on screen

- **Call:** The storm wall is on screen behind the runner at all times, and how close it is is shown by the wall itself plus screen edges that darken as it gets close. There is no bar or number.
- **Why:** "The player should always see how close it is."
- **Check:** Play a full run. The wall never leaves the screen, and the edges get darker as it gets closer.
- **Numbers:** starting gap 20–30 m.

## 4. The storm speeds up, and dodging alone doesn't escape it

- **Call:** The storm speeds up smoothly over the whole run, with no sudden jumps, until a run that dodges every piece of debris but never bursts is caught before the shelter.
- **Why:** "The storm is a wall that chases the runner and speeds up over the course of the run." / "Dodging debris and choosing when to burst are the whole skill of the game."
- **Check:** Dodge everything and never burst. The wall creeps up the back of the screen with no sudden jumps and catches you before 90 s.
- **Numbers:** storm speed 5–6 m/s at the start, rising steadily to 8.5–10 m/s at 90 s.

## 5. The opening teaches without words

- **Call:** No tutorial screen, text box or "press X" pop-up ever appears, and during the first 10 s the wall visibly gains on the runner even when the player dodges everything.
- **Why:** "No tutorial screen, no text boxes, no 'press X to dash' pop-up." / "By the ten-second mark, they should understand that the storm is coming and they cannot stop."
- **Check:** Play the first 10 s, dodging everything and not bursting. No text appears, and at 10 s the wall fills more of the back of the screen than it did on the first frame.
- **Numbers:** starting gap 20–30 m; storm speed at the start 5–6 m/s (see conflict 1).

## 6. The first debris comes alone

- **Call:** The runner starts in the middle lane, and the first piece of debris sits alone in that lane about 3 s into the run, with both other lanes clear.
- **Why:** "They start running, see the storm behind them, meet a piece of debris they have to steer around"
- **Check:** Start a run and touch nothing. At about 3 s you run into a single piece of debris in your lane, with nothing in the other lanes.
- **Numbers:** debris spacing at the start 25–35 m.

## 7. The burst shows itself when you first need it

- **Call:** The burst (Up arrow, or swipe up on a phone) works from the first frame, and its icon, marked with an up arrow, pulses the first time in each run that the screen edges start to darken.
- **Why:** "...and find the burst when they need it."
- **Check:** Press Up the moment a run starts and the runner bursts. Then hit debris on purpose until the edges start to darken. The burst icon pulses at that moment.
- **Numbers:** none.

## 8. The burst is a decision, not a spam button

- **Call:** A burst throws the runner forward so the score leaps about 6–10 points and the wall visibly drops back, then the burst icon empties and refills over 4–6 s, and presses before it is full do nothing.
- **Why:** "It should feel powerful but not spammable. Each burst should be a decision, not something you press every second."
- **Check:** Burst, then keep pressing Up. The score leaps about 6–10 points at the burst, and nothing else happens until the icon is full again, about 4–6 s later.
- **Numbers:** burst distance 6–10 m; cooldown 4–6 s.

## 9. Debris blocks one lane at a time and gets denser

- **Call:** Each piece of debris (a tree, a sign or a stretch of broken fencing) blocks exactly one lane, no stretch of the path ever has all three lanes blocked, and the pieces come closer together as the run goes on.
- **Why:** "In the path are hazards, mainly fallen debris such as trees, signs and broken fencing." / "when it catches you, you know it was your mistake and not the game cheating."
- **Check:** Play a full run. You never meet all three lanes blocked, and debris that came about every 3–5 s at the start comes about every 1.5–2.5 s near the end.
- **Numbers:** debris spacing 25–35 m at the start, 12–18 m at 90 s.

## 10. A hit costs ground, and the storm doesn't wait

- **Call:** Hitting debris slows the runner to half speed for 0.75–1.25 s, and the storm keeps its pace, so it gets closer.
- **Why:** "Hitting one costs the runner ground, and the storm gets closer." / "It never lets up, but when it catches you, you know it was your mistake and not the game cheating."
- **Check:** Hit a piece of debris on purpose. The runner slows, the wall gets closer, and it doesn't drop back afterwards.
- **Numbers:** ground lost on a hit: 0.75–1.25 s at half speed.

## 11. Every run that survives 90 s reaches the shelter, and better runs score more

- **Call:** A run that survives 90 s reaches the shelter and ends as a win, and the score is the metres run, so a win with fewer hits and well-timed bursts scores higher than a messier win.
- **Why:** "You win by surviving to the shelter at the end of the run, about 90 seconds in." / "A score, probably distance run, gives a reason to replay a run you have already won." If the shelter sat at a fixed distance, every win would score the same, so the shelter comes at a fixed time instead.
- **Check:** Win twice, once taking several hits and once running clean and bursting whenever ready. Both runs reach the shelter at about 90 s, and the clean run shows the higher score.
- **Numbers:** run length 90 s; score 1 point per metre.

## 12. Getting caught ends the run; restart is instant

- **Call:** When the storm reaches the runner the run ends, the score shows, and one press or tap starts a new run straight away, with no menus and no reloading.
- **Why:** "Restarting should be instant, with no menus in the way and no reloading." / "Getting caught should sting, not frustrate."
- **Check:** Get caught, then press any key. A new run starts straight away.
- **Numbers:** none.

## Conflicts between Dev's ranges and these calls

1. **The storm falls back in the opening (call 5).** With every mix of the ranges, the storm is slower than the runner for the whole first 10 s (the fastest storm is about 6.4 m/s at 10 s; the slowest runner is 7 m/s). The gap grows by about 8–38 m instead of shrinking. At middle values it goes from 25 m to about 48 m.
2. **A run that never bursts still escapes (call 4).** With no hits and no bursts, the gap at 90 s is the starting gap + 90 × (runner speed − the storm's average speed). At middle values that is about +81 m. The call only holds when the runner is at the slow end (7–7.7 m/s) and the storm is at the fast end of both its ranges. This also undercuts "two hits late in the run should be deadly": one hit costs only about 3–6 m.
3. **The wall is hard to keep on screen (call 3).** At middle values the gap peaks at about 100 m around 60 s, before any bursts. Bursting whenever ready adds about 95–230 m more over a run. A phone screen can't show a wall that far back and still show the debris ahead clearly.

Starting the storm at or above runner speed would fix all three, but then bursts carry the whole run, so these numbers need to be tuned together in DESIGN_LOG.md.
