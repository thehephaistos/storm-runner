# Prompt: steady-speed game loop

Given to Claude Code, started in this repo with the Godot MCP connected.

```
Build Storm Runner's game loop in this Godot 4.7 project. It needs a stand-in player
and a stand-in storm that cover the same distance at 30 and 60 fps.

Tick rate
- The game updates at 60 ticks per second. This is already set in project.godot
  (physics/common/physics_ticks_per_second=60). Don't change it, and don't use
  --fixed-fps or anything else that ties game steps to drawn frames.

Where the movement code lives
- All movement goes in _physics_process(delta), using delta. Nothing that moves
  goes in _process(), and nothing counts drawn frames.
- Run time is the sum of physics deltas since the run started, not wall-clock time.

Stand-ins (plain shapes in scenes/main.tscn, no art)
- The player and the storm move along one axis only: up the screen (−y). Lanes
  will sit left and right on x later. Distance = how far a node has moved along
  that axis since the run started, read from its position in Godot world units.
- Player, design call 1: running at full speed from the first tick and holding one
  steady speed. Placeholder 8 m/s (Dev's range 7–9).
- Storm, design call 4: starts behind the player and speeds up smoothly, with no
  jumps, from 5.5 m/s to 9.25 m/s over 90 s, then holds. These are the middle of
  Dev's ranges 5–6 and 8.5–10. Starting gap 25 m (call 3, range 20–30).
- Put every number in one place, clearly marked as a placeholder until DESIGN_LOG.md
  fixes it, with one constant for world units per metre. Don't try to fix the
  conflicts listed in design_calls.md here.
- A Camera2D follows the player.

Parity check output (for Owen's QA sheet)
- At exactly tick 600 (10 s of run time), print one line:
  ticks, run time, player_distance, storm_distance, and the wall-clock seconds
  since the run started. If the wall-clock time is well over 10 s, the machine
  didn't hold 60 ticks per second.

Don't build lanes, input, debris, the burst, the score or a HUD. Those come later.

Check it yourself before you finish
- Use the Godot MCP to run the project twice, with vsync disabled: once with
  --max-fps 60 and once with --max-fps 30. Report both lines and the parity gap:
  |distance at 30 − distance at 60| ÷ distance at 60 × 100, for the player and
  the storm. It must be 2% or less, and should be 0.
- Save this prompt as prompts/loop.md, then commit and push.
```
