# Storm Runner: Design Log

The 12 design calls from `design_calls.md`, each with a note on how it was built. All numbers live in `scripts/tuning.gd`; times are in ticks (60 ticks = 1 s). Checked headless by `tests/checks.gd` (14 checks, all PASS) and through the Godot MCP at 30 and 60 fps caps (`parity/`).

Files: `scenes/main.tscn` (all nodes), `scripts/main.gd` (rules and loop), `scripts/tuning.gd` (numbers), `scripts/ground.gd` (lane markers), `scripts/burst_icon.gd` (burst icon), `shaders/vignette.gdshader` (darkening edges).

---

**DC-01 · runner · Never stops**
The runner is already running on the first frame and keeps one steady speed that no input can stop or change, apart from the burst.

Status: built

Build note
Built in: `main.gd` step() adds PLAYER_SPEED × delta to player_d every tick from tick 1. No input changes it; only the burst and hits do.
Values used: 8 m/s (Dev 7–9). Score climbs 8 points a second.
Steady-speed check: in _physics_process; distance is summed per tick.
See it in the build: steer around everything for 10 s without bursting. The score reads 80 at 10 s (checks.gd: 80.00).

**DC-02 · controls · Three lanes, one move per input**
3 fixed lanes; each Left/Right press or swipe moves exactly one lane in a snap, with no drifting in between.

Status: built (swipes not yet tried on a real phone)

Build note
Built in: `main.gd` _unhandled_input queues one action per key press (echo ignored, so holding moves one lane) or per swipe; step() applies it next tick; _change_lane() snaps.
Values used: 3 lanes, 150 px apart; snap 5 ticks (0.083 s); swipe threshold 40 px.
Steady-speed check: the snap counts ticks in _physics_process.
See it in the build: press Left twice fast from the middle: the runner lands in the left lane, and the second press does nothing at the edge. Hold Right: one lane only.

**DC-03 · storm · Always on screen**
The storm wall is on screen behind the runner at all times; closeness is shown by the wall and darkening edges. No bar or number.

Status: built

Build note
Built in: `main.tscn` Storm/Wall and Vignette/Rect (`vignette.gdshader`); `main.gd` _update_view() places the wall and sets the darkening.
Values used: starting gap 25 m (Dev 20–30); portrait 540×960 view shows 72 m behind the runner; edges start darkening below 15 m and are fully dark at 0 m. If the gap ever exceeded the view, the wall's edge is held 24 px inside the bottom.
Steady-speed check: the gap is updated per tick; the view only draws it.
See it in the build: play a full run. The wall never leaves the screen (largest gap in a strong run: 65.8 m, inside 72 m).

**DC-04 · storm · Speeds up; dodging alone doesn't escape it**
The storm speeds up smoothly and catches a run that dodges everything but never bursts.

Status: built

Build note
Built in: `main.gd` storm_speed_at(), sampled at the middle of each tick.
Values used: 8.5 m/s at the start (**OUTSIDE** Dev's 5–6: needed so the wall gains in the opening, DC-05, and never drops back after a hit, DC-10) rising steadily to 10 m/s at 90 s (Dev 8.5–10).
Steady-speed check: speed is a function of run time = ticks × 1/60.
See it in the build: dodge everything and never burst. You're caught at about 32 s (checks.gd: 32.5 s).

**DC-05 · opening · Teaches without words**
No tutorial, text box or "press X" pop-up; the wall visibly gains in the first 10 s even when you dodge everything.

Status: built

Build note
Built in: nothing shows text during play except the score number. The storm start speed above the runner's does the teaching.
Values used: gap 25 m → 19.2 m at 10 s with clean play.
Steady-speed check: per tick, as DC-04.
See it in the build: dodge everything for 10 s without bursting; the wall fills more of the back of the screen.

**DC-06 · opening · The first debris comes alone**
The runner starts in the middle lane; the first debris sits alone in that lane about 3 s in.

Status: built

Build note
Built in: `main.gd` _build_debris() places the first piece by hand before the seeded layout.
Values used: 24 m (3.0 s at 8 m/s), middle lane, next piece about 30 m later.
Steady-speed check: debris is fixed in metres; reaching it depends only on ticks.
See it in the build: touch nothing. You hit one piece at about 3 s (checks.gd: 2.77 s, the front edge).

**DC-07 · core_move · The burst shows itself**
Up or swipe up bursts from the first frame; the up-arrow icon pulses the first time the edges start to darken.

Status: built

Build note
Built in: `burst_icon.gd` draws the arrow, refill ring and pulse; `main.tscn` places the icon just below the runner so it follows every lane change (moved there after playing, see below); `main.gd` sets pulse_left once per run when the gap first drops below 15 m.
Values used: icon 76 px wide, 36 px below the runner; pulse grows it up to 40% for 90 ticks (1.5 s).
Steady-speed check: the pulse counts ticks.
See it in the build: press Up at once and the runner bursts. Play on without bursting; before you're caught the edges darken and the icon pulses.

**DC-08 · core_move · Burst cooldown**
A burst leaps the score about 6–10 points and the wall drops back; the icon refills over 4–6 s; presses before it's full do nothing.

Status: built

Build note
Built in: `main.gd` step(): the dash adds its distance over BURST_TICKS; cooldown counts down per tick. A hit ends a dash.
Values used: 8 m over 10 ticks (Dev 6–10; score leaps about 9.3 including normal running); refill 300 ticks = 5 s (Dev 4–6).
Steady-speed check: dash and refill count ticks.
See it in the build: burst, then keep pressing Up. Nothing happens until the ring is full again 5 s later.

**DC-09 · hazards · Debris layout**
Each piece blocks one lane, all three lanes are never blocked, and pieces come closer together.

Status: built

Build note
Built in: `main.gd` _build_debris() with a fixed seed, so every run and every machine gets the same course. Late in the run some rows have two pieces (one lane always open).
Values used: spacing 30 m → 15 m (Dev 25–35 → 12–18) ± 3 m, i.e. about every 3.75 s early and 1.9 s late; seed 2026; pair chance up to 35%.
Steady-speed check: layout is built once per run, not per frame.
See it in the build: play a full run; you never meet three lanes blocked, and debris comes faster near the end.

**DC-10 · hazards · A hit costs ground; the storm doesn't wait**
A hit slows the runner to half speed briefly, and the storm keeps its pace.

Status: built

Build note
Built in: `main.gd` _check_hits() (swept, so a dash can't skip through a piece) sets slow_left; the storm never reads it.
Values used: half speed for 45 ticks = 0.75 s (Dev 0.75–1.25), costing 3 m.
Steady-speed check: the slowdown counts ticks.
See it in the build: hit a piece on purpose. The runner flashes red and slows, and the wall gets closer and never drops back unless you burst.

**DC-11 · win · Shelter at 90 s; better runs score more**
A run that survives 90 s reaches the shelter and wins; the score is metres run.

Status: built

Build note
Built in: `main.gd` ends the run as SAFE at tick 5400; the shelter appears 3 s before, approaching at runner speed; the end screen shows SHELTER and the score.
Values used: 5400 ticks = 90 s; 1 point per metre. A clean run with bursts scored 863.
Steady-speed check: the win is a tick count, not a clock.
See it in the build: win twice, once taking hits and once clean. Both end at 90 s; the clean run scores higher.

**DC-12 · lose · Caught and instant restart**
When the storm reaches the runner the run ends, the score shows, and one press or tap starts a new run straight away.

Status: built

Build note
Built in: `main.gd` _end() shows CAUGHT and the score; any key, click or tap after the lock calls reset_run() in place, with no scene reload.
Values used: 30-tick lock (0.5 s) so a key still held from play can't skip the end screen.
Steady-speed check: the lock counts ticks.
See it in the build: get caught, then press any key. A new run starts at once.

- itch.io build (live): https://oguzk.itch.io/storm-runner (uploaded 2026-11-20)
- Played one full run in the browser on itch.io until the storm caught me (CAUGHT screen). The game loaded and ran in the page, and the burst icon was easy to see under the runner. The portrait game shows as a narrow strip with black bars in the 1280 × 720 box. Visibility is Restricted with a password, which is shared with reviewers privately and not stored here.

---

## Changed after playing

- Lane changes felt quick and clear. I changed nothing.
- I didn't see the burst icon. It sat in the bottom-right corner on top of the storm wall, while my eyes stayed on the runner near the top. Changed: the icon now sits just below the runner and moves with it, and its pulse grows twice as much (up to 40%).
- Spotted in a screenshot while fixing the icon: the score at the top center covered the debris coming toward the runner. Changed: the score moved to the top-left corner.
- Played again after the change: the burst icon under the runner was easy to see, and the run felt much better.
