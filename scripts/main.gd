## Storm Runner's game loop.
## Everything that moves is stepped in _physics_process at the fixed tick rate
## (physics/common/physics_ticks_per_second = 60), never per drawn frame, so the
## player and the storm cover the same distance at any frame-rate cap.
extends Node2D

const Tuning := preload("res://scripts/tuning.gd")

## Tick at which the parity line for Owen's QA sheet prints (10 s at 60 ticks/s).
const PARITY_TICK := 600

@onready var player: Node2D = $Player
@onready var storm: Node2D = $Storm

var run_time := 0.0  # sum of physics deltas since the run started
var ticks := 0  # physics ticks since the run started
var player_distance_m := 0.0
var storm_distance_m := 0.0
var _player_start_y := 0.0
var _storm_start_y := 0.0
var _wall_clock_start_usec := 0
var _frames_at_start := 0


func _ready() -> void:
	# Run direction is up the screen (-y); the storm starts behind (below) the player.
	storm.position.y = player.position.y + Tuning.STARTING_GAP_M * Tuning.WORLD_UNITS_PER_METRE
	_player_start_y = player.position.y
	_storm_start_y = storm.position.y
	_wall_clock_start_usec = Time.get_ticks_usec()
	_frames_at_start = Engine.get_process_frames()


func _physics_process(delta: float) -> void:
	# Storm speed at the middle of this tick, which is exact for a steady ramp.
	var storm_speed := storm_speed_at(run_time + delta * 0.5)
	player_distance_m += Tuning.PLAYER_SPEED_MPS * delta
	storm_distance_m += storm_speed * delta
	run_time += delta
	ticks += 1
	player.position.y = _player_start_y - player_distance_m * Tuning.WORLD_UNITS_PER_METRE
	storm.position.y = _storm_start_y - storm_distance_m * Tuning.WORLD_UNITS_PER_METRE
	if ticks == PARITY_TICK:
		_print_parity_line()


static func storm_speed_at(t: float) -> float:
	var ramp := clampf(t / Tuning.STORM_RAMP_SECONDS, 0.0, 1.0)
	return lerpf(Tuning.STORM_START_SPEED_MPS, Tuning.STORM_END_SPEED_MPS, ramp)


func _print_parity_line() -> void:
	# Distances are read from the nodes' positions, in world units, as the QA sheet asks.
	var player_units := _player_start_y - player.position.y
	var storm_units := _storm_start_y - storm.position.y
	var wall_clock_s := (Time.get_ticks_usec() - _wall_clock_start_usec) / 1000000.0
	print("PARITY fps_cap=%d physics_ticks_per_second=%d ticks=%d run_time_s=%.3f player_distance=%.2f storm_distance=%.2f wall_clock_s=%.2f frames=%d" % [
		Engine.max_fps, Engine.physics_ticks_per_second, ticks, run_time,
		player_units, storm_units, wall_clock_s, Engine.get_process_frames() - _frames_at_start])
	if "--parity-quit" in OS.get_cmdline_user_args():
		get_tree().quit()
