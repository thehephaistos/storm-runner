## Every gameplay number for the loop, in one place.
## PLACEHOLDERS: the middle of Dev Malhotra's ranges (see design_calls.md).
## They stay placeholders until DESIGN_LOG.md fixes them.
extends RefCounted

## Godot world units per metre. The QA sheet reads distances in world units.
const WORLD_UNITS_PER_METRE := 16.0

## Design call 1, the runner never stops. Dev's range 7-9 m/s.
const PLAYER_SPEED_MPS := 8.0

## Design call 4, the storm speeds up smoothly. Dev's ranges: 5-6 m/s at the
## start, 8.5-10 m/s at 90 s.
const STORM_START_SPEED_MPS := 5.5
const STORM_END_SPEED_MPS := 9.25
const STORM_RAMP_SECONDS := 90.0

## Design call 3, starting gap between storm and runner. Dev's range 20-30 m.
const STARTING_GAP_M := 25.0
