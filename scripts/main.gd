## Storm Runner: rules and game loop. All gameplay is stepped in _physics_process
## at 60 ticks/s and counts ticks, never clock time or drawn frames.
extends Node2D

const T := preload("res://scripts/tuning.gd")
const PARITY_TICK := 600
const DEBRIS_COLORS := [Color(0.2, 0.6, 0.25), Color(0.3, 0.5, 0.85), Color(0.6, 0.42, 0.22)]  # tree, sign, fencing
enum State { RUNNING, CAUGHT, SAFE }

@onready var player: Node2D = $Player
@onready var storm: Node2D = $Storm
@onready var shelter: Node2D = $Shelter
@onready var debris_root: Node2D = $Debris
@onready var camera: Camera2D = $Camera2D
@onready var ground: Node2D = $Ground
@onready var vignette: ColorRect = $Vignette/Rect
@onready var score_label: Label = $Hud/Score
@onready var burst_icon: Control = $Hud/BurstIcon
@onready var end_layer: CanvasLayer = $End
@onready var end_label: Label = $End/Label

var state := State.RUNNING
var ticks := 0
var run_time := 0.0
var player_d := 0.0  # metres run, which is also the score
var storm_d := 0.0  # metres, storm front
var lane := 1
var snap_left := 0
var burst_left := 0
var cooldown := 0
var slow_left := 0
var pulse_left := 0
var pulsed := false
var end_lock := 0
var debris: Array = []
var _queue: Array = []
var _snap_from_x := 0.0
var _touch_start := Vector2.ZERO
var _touch_fired := false
var _wall_start_usec := 0
var _frames_at_start := 0


func _ready() -> void:
	for pair in [["move_left", KEY_LEFT], ["move_right", KEY_RIGHT], ["burst", KEY_UP]]:
		if not InputMap.has_action(pair[0]):
			InputMap.add_action(pair[0])
			var ev := InputEventKey.new()
			ev.physical_keycode = pair[1]
			InputMap.action_add_event(pair[0], ev)
	reset_run()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.is_action_pressed("move_left"):
			_queue.append("left")
		elif event.is_action_pressed("move_right"):
			_queue.append("right")
		elif event.is_action_pressed("burst"):
			_queue.append("burst")
		else:
			_queue.append("any")
	elif event is InputEventMouseButton and event.pressed:
		_queue.append("any")
	elif event is InputEventScreenTouch:
		if event.pressed:
			_touch_start = event.position
			_touch_fired = false
		elif not _touch_fired:
			_queue.append("any")
	elif event is InputEventScreenDrag and not _touch_fired:
		var d: Vector2 = event.position - _touch_start
		if d.length() >= T.SWIPE_MIN_PX:
			_touch_fired = true
			if absf(d.x) > absf(d.y):
				_queue.append("right" if d.x > 0.0 else "left")
			elif d.y < 0.0:
				_queue.append("burst")
			else:
				_queue.append("any")


func _physics_process(delta: float) -> void:
	step(delta)


## One tick of the game. Inputs queued since the last tick are applied here.
func step(delta: float) -> void:
	var actions := _queue.duplicate()
	_queue.clear()
	if state != State.RUNNING:
		end_lock = maxi(end_lock - 1, 0)
		if end_lock == 0 and not actions.is_empty():
			reset_run()
		return
	for a in actions:
		match a:
			"left":
				_change_lane(-1)
			"right":
				_change_lane(1)
			"burst":
				if cooldown == 0:
					burst_left = T.BURST_TICKS
					cooldown = T.BURST_COOLDOWN_TICKS
	var speed := T.PLAYER_SPEED_MPS * (T.HIT_SPEED_FACTOR if slow_left > 0 else 1.0)
	if burst_left > 0:
		speed += T.BURST_DISTANCE_M / (T.BURST_TICKS * delta)
	var prev_d := player_d
	player_d += speed * delta
	storm_d += storm_speed_at(run_time + delta * 0.5) * delta
	run_time += delta
	ticks += 1
	burst_left = maxi(burst_left - 1, 0)
	cooldown = maxi(cooldown - 1, 0)
	slow_left = maxi(slow_left - 1, 0)
	snap_left = maxi(snap_left - 1, 0)
	pulse_left = maxi(pulse_left - 1, 0)
	_check_hits(prev_d)
	if not pulsed and gap() < T.DARKEN_START_GAP_M:
		pulsed = true
		pulse_left = T.PULSE_TICKS
	if ticks == PARITY_TICK:
		_print_parity_line()
	if gap() <= 0.0:
		_end(State.CAUGHT)
	elif ticks >= T.RUN_TICKS:
		_end(State.SAFE)
	_update_view()


func gap() -> float:
	return player_d - storm_d


static func storm_speed_at(t: float) -> float:
	var ramp := clampf(t / T.STORM_RAMP_SECONDS, 0.0, 1.0)
	return lerpf(T.STORM_START_SPEED_MPS, T.STORM_END_SPEED_MPS, ramp)


static func lane_x(l: int) -> float:
	return T.VIEW_CENTER_X + (l - 1) * T.LANE_SPACING_PX


func reset_run() -> void:
	state = State.RUNNING
	ticks = 0
	run_time = 0.0
	player_d = 0.0
	storm_d = -T.STARTING_GAP_M
	lane = 1
	snap_left = 0
	burst_left = 0
	cooldown = 0
	slow_left = 0
	pulse_left = 0
	pulsed = false
	end_lock = 0
	_queue.clear()
	_snap_from_x = lane_x(1)
	for item in debris:
		item["node"].queue_free()
	debris = _build_debris()
	end_layer.visible = false
	_wall_start_usec = Time.get_ticks_usec()
	_frames_at_start = Engine.get_process_frames()
	_update_view()


func _change_lane(dir: int) -> void:
	var target := clampi(lane + dir, 0, T.LANE_COUNT - 1)
	if target == lane:
		return
	_snap_from_x = player.position.x
	lane = target
	snap_left = T.LANE_SNAP_TICKS


func _check_hits(prev_d: float) -> void:
	var half := (T.DEBRIS_DEPTH_M + T.RUNNER_DEPTH_M) * 0.5
	for item in debris:
		if item["hit"] or item["lane"] != lane:
			continue
		if player_d >= item["d"] - half and prev_d <= item["d"] + half:
			item["hit"] = true
			item["node"].modulate = Color(1, 1, 1, 0.3)
			slow_left = T.HIT_SLOW_TICKS
			burst_left = 0
			return


func _build_debris() -> Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = T.DEBRIS_SEED
	var course_m := T.PLAYER_SPEED_MPS * T.RUN_TICKS / 60.0
	var out: Array = [_make_debris(T.FIRST_DEBRIS_M, 1, 0)]
	var d := T.FIRST_DEBRIS_M
	while d < T.COURSE_LENGTH_M:
		var f := clampf(d / course_m, 0.0, 1.0)
		d += lerpf(T.DEBRIS_SPACING_START_M, T.DEBRIS_SPACING_END_M, f) + rng.randf_range(-T.DEBRIS_SPACING_JITTER_M, T.DEBRIS_SPACING_JITTER_M)
		var first := rng.randi_range(0, T.LANE_COUNT - 1)
		out.append(_make_debris(d, first, rng.randi_range(0, 2)))
		if rng.randf() < T.DEBRIS_PAIR_CHANCE_END * f:
			var second := (first + rng.randi_range(1, T.LANE_COUNT - 1)) % T.LANE_COUNT
			out.append(_make_debris(d, second, rng.randi_range(0, 2)))
	return out


func _make_debris(d: float, l: int, kind: int) -> Dictionary:
	var r := ColorRect.new()
	var w := T.LANE_SPACING_PX * 0.7
	var h := T.DEBRIS_DEPTH_M * T.WORLD_UNITS_PER_METRE
	r.size = Vector2(w, h)
	r.position = Vector2(lane_x(l) - w * 0.5, -d * T.WORLD_UNITS_PER_METRE - h * 0.5)
	r.color = DEBRIS_COLORS[kind]
	debris_root.add_child(r)
	return {"d": d, "lane": l, "kind": kind, "hit": false, "node": r}


func _end(s: State) -> void:
	state = s
	end_lock = T.RESTART_LOCK_TICKS
	end_label.text = ("SHELTER" if s == State.SAFE else "CAUGHT") + "\n" + str(int(player_d))
	end_layer.visible = true


func _update_view() -> void:
	var wu := T.WORLD_UNITS_PER_METRE
	var py := -player_d * wu
	var k := 1.0 - float(snap_left) / T.LANE_SNAP_TICKS
	player.position = Vector2(lerpf(_snap_from_x, lane_x(lane), k), py)
	player.modulate = Color(1, 0.45, 0.45) if slow_left > 0 else (Color(1.6, 1.6, 1.6) if burst_left > 0 else Color.WHITE)
	camera.position = Vector2(T.VIEW_CENTER_X, py + T.CAMERA_AHEAD_PX)
	# DC3: the wall never leaves the screen; its edge is held at the bottom if it falls further back.
	var bottom := camera.position.y + T.VIEW_HEIGHT_PX * 0.5 - T.WALL_MIN_VISIBLE_PX
	storm.position = Vector2(T.VIEW_CENTER_X, minf(-storm_d * wu, bottom))
	var remaining := T.RUN_TICKS - ticks
	shelter.visible = remaining <= T.SHELTER_SHOW_TICKS
	shelter.position = Vector2(T.VIEW_CENTER_X, -(player_d + remaining / 60.0 * T.PLAYER_SPEED_MPS) * wu)
	vignette.material.set_shader_parameter("strength", clampf(1.0 - gap() / T.DARKEN_START_GAP_M, 0.0, 1.0))
	score_label.text = str(int(player_d))
	burst_icon.charge = 1.0 - float(cooldown) / T.BURST_COOLDOWN_TICKS
	burst_icon.pulse_ticks = pulse_left
	burst_icon.queue_redraw()
	ground.cam_y = camera.position.y
	ground.queue_redraw()


func _print_parity_line() -> void:
	var wall_clock_s := (Time.get_ticks_usec() - _wall_start_usec) / 1000000.0
	print("PARITY fps_cap=%d physics_ticks_per_second=%d ticks=%d run_time_s=%.3f player_distance=%.2f storm_distance=%.2f wall_clock_s=%.2f frames=%d" % [
		Engine.max_fps, Engine.physics_ticks_per_second, ticks, run_time,
		player_d * T.WORLD_UNITS_PER_METRE, (storm_d + T.STARTING_GAP_M) * T.WORLD_UNITS_PER_METRE,
		wall_clock_s, Engine.get_process_frames() - _frames_at_start])
	if "--parity-quit" in OS.get_cmdline_user_args():
		get_tree().quit()
