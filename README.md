# Storm Runner

Godot 4.7 project. Design: `design_calls.md` (prompt: `prompt.md`). Game: `scenes/main.tscn` + `scripts/main.gd`, every number in `scripts/tuning.gd`, build notes in `DESIGN_LOG.md` (prompts: `prompts/loop.md`, `prompts/game.md`).

**Play:** open in Godot 4.7 and press F5. Left/Right change lane, Up bursts (swipes on touch). Any key restarts.

**Checks:** `godot --headless --path . -s res://tests/checks.gd` (14 design-call checks, all PASS).

## Game loop

- **Update rate: 60 ticks per second** (`physics/common/physics_ticks_per_second = 60`). The 30 and 60 in QA's sheet are screen caps (`max_fps`), not update rates. At a 60 cap the game runs 1 tick per frame; at a 30 cap, 2 ticks per frame. Either way it's 60 ticks a second, so distances match. 60 divides evenly into both caps (no stutter) and gives 17 ms input steps for the lane snap.
- **Movement lives in `_physics_process(delta)` only.** Nothing that moves is in `_process()`.
- **Speeds (placeholders, middle of Dev's ranges, until DESIGN_LOG.md fixes them):**

| Stand-in | Design call | Value | Dev's range |
|---|---|---|---|
| Player speed | DC1, the runner never stops | 8 m/s, steady | 7–9 m/s |
| Storm speed | DC4, the storm speeds up smoothly | 8.5 → 10 m/s over 90 s (start OUTSIDE Dev's range, see DESIGN_LOG DC-04) | 5–6 → 8.5–10 m/s |
| Starting gap | DC3, the storm is always on screen | 25 m | 20–30 m |

Scale: 10 world units per metre. (The loop stage used 5.5 → 9.25 m/s and 16 units per metre.)

## Parity check (run through the Godot MCP, vsync disabled)

| fps_cap | physics_ticks_per_second | duration_s | player_distance | storm_distance | diff_pct | result |
|---|---|---|---|---|---|---|
| 60 | 60 | 10 | 740.00 | 858.33 | 0 | baseline |
| 30 | 60 | 10 | 740.00 | 858.33 | 0.00 | PASS |

Raw readouts: `parity/readout_fps60.txt`, `parity/readout_fps30.txt`. Full game, no input. Frames in 10 s were 586 at the 60 cap and 296 at the 30 cap, 0 errors in the output, so the cap took effect while the distances stayed identical. Wall clock at tick 600 was 10.03 s and 9.90 s on a fast Mac, so the tick rate held. This still needs checking on Tomás's laptop.

To rerun: put an `override.cfg` with `application/run/max_fps` and `display/window/vsync/vsync_mode=0` in the project folder, run the project, and read the `PARITY` line printed at tick 600. Or run `godot --path . --max-fps 30 --disable-vsync -- --parity-quit`.

## Hand-in note

- **Prompt excerpt:** "All movement goes in _physics_process(delta), using delta. Nothing that moves goes in _process() … At exactly tick 600 (10 s of run time), print one line: ticks, run time, player_distance, storm_distance, and the wall-clock seconds."
- **Asked, kept, changed, rejected:** I asked for a 60-tick loop with DC1/DC4 speeds and a parity readout. I kept the fixed-tick design and placeholder numbers in one file. I changed the readout to also print frames per run, to prove the cap took effect, and ran the caps via `override.cfg` because the MCP's `run_project` can't pass `--max-fps`. I rejected `--fixed-fps` and any frame-counted movement.
