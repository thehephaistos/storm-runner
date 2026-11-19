## The burst icon: an up arrow inside a ring that refills over the cooldown,
## and pulses when the main script sets pulse_ticks.
extends Control

var charge := 1.0
var pulse_ticks := 0


func _draw() -> void:
	var c := size * 0.5
	var r := minf(size.x, size.y) * 0.5
	if pulse_ticks > 0:
		r *= 1.0 + 0.4 * absf(sin(pulse_ticks * 0.2))
	var is_full := charge >= 1.0
	var col := Color(1, 0.85, 0.3) if is_full else Color(0.6, 0.6, 0.6)
	draw_circle(c, r, Color(0, 0, 0, 0.45))
	if charge > 0.01:
		draw_arc(c, r - 4.0, -PI / 2.0, -PI / 2.0 + TAU * charge, 48, col, 6.0)
	var a := r * 0.45
	draw_colored_polygon(PackedVector2Array([c + Vector2(0, -a), c + Vector2(a, a * 0.6), c + Vector2(-a, a * 0.6)]), col)
