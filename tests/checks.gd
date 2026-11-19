## Headless checks of the design calls' rules, stepping the game tick by tick.
## Run: godot --headless --path . -s res://tests/checks.gd
extends SceneTree

const T := preload("res://scripts/tuning.gd")
var g
var fails := 0


func ok(name: String, cond: bool, info := "") -> void:
	print(("PASS " if cond else "FAIL ") + name + ("  (" + info + ")" if info != "" else ""))
	if not cond:
		fails += 1


func clear_ahead(l: int, m: float) -> bool:
	for it in g.debris:
		if it["lane"] == l and not it["hit"] and it["d"] > g.player_d - 2.5 and it["d"] < g.player_d + m:
			return false
	return true


## A simple autopilot: dodge debris ahead, burst when ready and the lane is clear.
func pilot(bursts: bool) -> void:
	if not clear_ahead(g.lane, 9.0):
		for l in [g.lane - 1, g.lane + 1, g.lane - 2, g.lane + 2]:
			if l >= 0 and l < T.LANE_COUNT and clear_ahead(l, 9.0):
				for i in range(absi(l - g.lane)):
					g._queue.append("left" if l < g.lane else "right")
				return
	elif bursts and g.cooldown == 0 and clear_ahead(g.lane, 16.0):
		g._queue.append("burst")


func hits() -> int:
	var n := 0
	for it in g.debris:
		if it["hit"]:
			n += 1
	return n


func _initialize() -> void:
	g = load("res://scenes/main.tscn").instantiate()
	root.add_child(g)
	_run.call_deferred()


func _run() -> void:
	g.set_physics_process(false)
	var dt := 1.0 / 60.0

	# DC1: steering around everything, the score climbs 8 points a second.
	g.reset_run()
	for i in range(600):
		pilot(false)
		g.step(dt)
	ok("DC1 steady speed", hits() == 0 and absf(g.player_d - 80.0) < 0.001, "score %.2f after 10 s, %d hits" % [g.player_d, hits()])
	# DC5: the wall gained on the runner in the first 10 s with no hits and no bursts.
	ok("DC5 wall gains in the opening", g.gap() < T.STARTING_GAP_M, "gap %.1f m -> %.1f m" % [T.STARTING_GAP_M, g.gap()])

	# DC2: one press, one lane, settled within the snap.
	g.reset_run()
	g._queue.append("left")
	for i in range(T.LANE_SNAP_TICKS + 1):
		g.step(dt)
	ok("DC2 one press moves one lane", g.lane == 0 and is_equal_approx(g.player.position.x, g.lane_x(0)), "lane %d after %d ticks" % [g.lane, T.LANE_SNAP_TICKS + 1])

	# DC6: the first debris is alone in the middle lane about 3 s in.
	var first = g.debris[0]
	var alone := true
	for it in g.debris.slice(1):
		if absf(it["d"] - first["d"]) < 10.0:
			alone = false
	ok("DC6 first debris alone", first["lane"] == 1 and alone, "%.0f m = %.1f s" % [first["d"], first["d"] / T.PLAYER_SPEED_MPS])

	# DC10: touch nothing: the first debris is hit near 3 s and halves the speed.
	g.reset_run()
	while g.slow_left == 0 and g.ticks < 600:
		g.step(dt)
	var hit_tick: int = g.ticks
	var d0: float = g.player_d
	g.step(dt)
	ok("DC10 hit halves the speed", absf((g.player_d - d0) - T.PLAYER_SPEED_MPS * 0.5 * dt) < 0.0001, "hit at %.2f s" % (hit_tick / 60.0))

	# DC7 + DC8: burst works on the first tick, then presses do nothing until the refill.
	g.reset_run()
	g._queue.append("burst")
	for i in range(T.BURST_TICKS):
		g.step(dt)
	var leap: float = g.player_d
	g._queue.append("burst")
	g.step(dt)
	ok("DC7 burst works from the first tick", leap > T.BURST_DISTANCE_M, "score %.1f after the dash" % leap)
	ok("DC8 press during refill does nothing", g.burst_left == 0 and g.cooldown > 0, "refill %d ticks = %.0f s" % [T.BURST_COOLDOWN_TICKS, T.BURST_COOLDOWN_TICKS / 60.0])

	# DC4 + DC7 pulse + DC10 wall never drops back: dodge everything, never burst.
	g.reset_run()
	var gap_grew := false
	var last_gap: float = g.gap()
	var pulse_before_caught := false
	while g.state == g.State.RUNNING:
		pilot(false)
		g.step(dt)
		if g.gap() > last_gap + 0.0001:
			gap_grew = true
		last_gap = g.gap()
		if g.pulse_left > 0:
			pulse_before_caught = true
	ok("DC4 no bursts gets caught before 90 s", g.state == g.State.CAUGHT and g.ticks < T.RUN_TICKS, "caught at %.1f s" % (g.ticks / 60.0))
	ok("DC7 icon pulses in a normal run", pulse_before_caught)
	ok("DC10 wall never drops back without a burst", not gap_grew)

	# DC12: the end screen holds for the lock, then one press restarts at tick 0.
	g._queue.append("any")
	g.step(dt)
	var held: bool = g.state == g.State.CAUGHT
	for i in range(T.RESTART_LOCK_TICKS):
		g.step(dt)
	g._queue.append("any")
	g.step(dt)
	ok("DC12 one press restarts", held and g.state == g.State.RUNNING and g.ticks == 0)

	# DC9: never all three lanes blocked at one distance.
	var by_d := {}
	for it in g.debris:
		by_d[snappedf(it["d"], 0.01)] = by_d.get(snappedf(it["d"], 0.01), 0) + 1
	ok("DC9 never three lanes blocked", by_d.values().max() < T.LANE_COUNT)

	# DC11 + DC3: dodge and burst whenever it's safe: reach the shelter; the wall stayed in view.
	g.reset_run()
	var max_gap := 0.0
	while g.state == g.State.RUNNING:
		pilot(true)
		g.step(dt)
		max_gap = maxf(max_gap, g.gap())
	ok("DC11 a good run reaches the shelter at 90 s", g.state == g.State.SAFE and g.ticks == T.RUN_TICKS, "score %d, %d hits" % [int(g.player_d), hits()])
	ok("DC3 wall stays on screen", max_gap * T.WORLD_UNITS_PER_METRE <= T.VIEW_HEIGHT_PX - T.CAMERA_AHEAD_PX, "largest gap %.1f m" % max_gap)

	print("CHECKS %s: %d failed" % ["PASS" if fails == 0 else "FAIL", fails])
	quit(1 if fails > 0 else 0)
