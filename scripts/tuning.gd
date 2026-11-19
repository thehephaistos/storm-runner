## Every gameplay number in one place. Times are in ticks (60 ticks = 1 s).
## Values outside Dev Malhotra's ranges are marked OUTSIDE, with the reason.
extends RefCounted

const WORLD_UNITS_PER_METRE := 10.0

# View (portrait). The runner sits 240 px below the top, so 72 m behind it is on screen.
const VIEW_CENTER_X := 270.0
const VIEW_HEIGHT_PX := 960.0
const CAMERA_AHEAD_PX := 240.0
const WALL_MIN_VISIBLE_PX := 24.0

# DC1 runner. Dev 7-9 m/s.
const PLAYER_SPEED_MPS := 8.0

# DC2 lanes.
const LANE_COUNT := 3
const LANE_SPACING_PX := 150.0
const LANE_SNAP_TICKS := 5  # 0.083 s
const SWIPE_MIN_PX := 40.0

# DC4 storm. Start is OUTSIDE Dev's 5-6 m/s: DC5 and DC10 need the storm at or
# above runner speed from the first tick (conflicts 1, 2 and 4). End is inside 8.5-10.
const STORM_START_SPEED_MPS := 8.5
const STORM_END_SPEED_MPS := 10.0
const STORM_RAMP_SECONDS := 90.0
const STARTING_GAP_M := 25.0  # DC3, Dev 20-30

# DC3 / DC7 edges darken below this gap; the burst icon pulses the first time.
const DARKEN_START_GAP_M := 15.0
const PULSE_TICKS := 90  # 1.5 s

# DC8 burst. Dev 6-10 m, cooldown 4-6 s.
const BURST_DISTANCE_M := 8.0
const BURST_TICKS := 10  # the dash lasts 0.17 s
const BURST_COOLDOWN_TICKS := 300  # 5 s

# DC9 debris. Dev spacing 25-35 m at the start, 12-18 m at 90 s.
const FIRST_DEBRIS_M := 24.0  # about 3 s at 8 m/s
const DEBRIS_SPACING_START_M := 30.0
const DEBRIS_SPACING_END_M := 15.0
const DEBRIS_SPACING_JITTER_M := 3.0
const DEBRIS_PAIR_CHANCE_END := 0.35
const DEBRIS_DEPTH_M := 2.0
const RUNNER_DEPTH_M := 2.0
const DEBRIS_SEED := 2026
const COURSE_LENGTH_M := 1000.0

# DC10 hit. Dev 0.75-1.25 s at half speed.
const HIT_SLOW_TICKS := 45  # 0.75 s
const HIT_SPEED_FACTOR := 0.5

# DC11 / DC12.
const RUN_TICKS := 5400  # shelter at 90 s
const SHELTER_SHOW_TICKS := 180  # shelter visible for the last 3 s
const RESTART_LOCK_TICKS := 30  # 0.5 s, so a held key can't skip the end screen
