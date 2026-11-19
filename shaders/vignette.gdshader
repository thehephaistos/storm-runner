shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec2 d = abs(UV - 0.5) * 2.0;
	float edge = max(d.x, d.y);
	COLOR = vec4(0.06, 0.03, 0.12, smoothstep(0.45, 1.0, edge) * strength * 0.9);
}
