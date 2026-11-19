## Scrolling lane markers, so the player can see the runner moving.
extends Node2D

const T := preload("res://scripts/tuning.gd")
var cam_y := 0.0


func _draw() -> void:
	var step := 4.0 * T.WORLD_UNITS_PER_METRE
	var y := floorf((cam_y - 600.0) / step) * step
	while y < cam_y + 600.0:
		for x in [T.VIEW_CENTER_X - T.LANE_SPACING_PX * 0.5, T.VIEW_CENTER_X + T.LANE_SPACING_PX * 0.5]:
			draw_line(Vector2(x, y), Vector2(x, y + step * 0.5), Color(1, 1, 1, 0.15), 3.0)
		y += step
