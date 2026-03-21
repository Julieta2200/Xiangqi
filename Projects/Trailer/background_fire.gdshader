shader_type canvas_item;

// Flicker speed and intensity
uniform float flicker_speed : hint_range(0.5, 10.0) = 4.0;
uniform float flicker_intensity : hint_range(0.0, 1.0) = 0.45;
// How far heat distortion reaches above fire (UV units)
uniform float heat_reach : hint_range(0.0, 0.15) = 0.06;
// Strength of the wavy heat distortion
uniform float heat_distort : hint_range(0.0, 0.03) = 0.008;
// How far flames lick upward from the fire pixels
uniform float flame_height : hint_range(0.0, 0.12) = 0.05;

// Value noise for organic flickering
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float vnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(
		mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x),
		mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x),
		f.y
	);
}

// Two-octave noise for richer texture
float fnoise(vec2 p) {
	return vnoise(p) * 0.65 + vnoise(p * 2.3 + vec2(5.2, 1.3)) * 0.35;
}

bool is_fire(vec4 c) {
	return c.r > 0.60 && c.g < 0.58 && c.b < 0.25 && c.a > 0.5;
}

void fragment() {
	vec4 base = texture(TEXTURE, UV);

	// --- 1. Flickering fire pixels ---
	if (is_fire(base)) {
		// Noise seeded by position + time gives each fire pixel independent flicker
		float n = fnoise(vec2(UV.x * 6.0 + TIME * flicker_speed,
							  UV.y * 6.0 + TIME * flicker_speed * 0.7));

		// Flicker brightness: oscillates between dim and bright
		float bright = 1.0 - flicker_intensity + n * flicker_intensity * 2.0;

		// Hotter flicker pushes color toward yellow-orange
		vec4 fire = base;
		fire.r = clamp(base.r * bright, 0.0, 1.0);
		fire.g = clamp(base.g * bright + n * 0.18, 0.0, 1.0);
		fire.b = clamp(base.b * bright, 0.0, 1.0);

		COLOR = fire;
		return;
	}

	// --- 2. Flame tips: lick upward from fire pixels below ---
	// Sample source below this pixel; if it's fire, draw a fading flame tip
	float lick_n = fnoise(vec2(UV.x * 9.0 + TIME * 3.5, TIME * 2.0));
	float lick_offset = flame_height * (0.5 + lick_n * 0.5); // vary per column
	vec2 below_uv = vec2(UV.x + (lick_n - 0.5) * 0.01, UV.y + lick_offset);

	if (below_uv.y <= 1.0) {
		vec4 below = texture(TEXTURE, below_uv);
		if (is_fire(below)) {
			// Fade to nothing at the tip
			float dist = lick_offset / flame_height;
			float fade = pow(1.0 - dist, 2.0) * lick_n;

			// Flame tips shift toward orange-yellow
			vec4 tip = below;
			tip.g = clamp(below.g + 0.2, 0.0, 1.0);
			COLOR = mix(base, tip, fade * 0.75);
			return;
		}
	}

	// --- 3. Heat distortion above fire pixels ---
	// Check if there is fire within `heat_reach` below this pixel
	vec2 heat_check_uv = vec2(UV.x, UV.y + heat_reach);
	if (heat_check_uv.y <= 1.0) {
		vec4 heat_src = texture(TEXTURE, heat_check_uv);
		if (is_fire(heat_src)) {
			float proximity = 1.0 - (heat_check_uv.y - UV.y) / heat_reach;
			float wave = vnoise(vec2(UV.x * 12.0 + TIME * 2.5, UV.y * 6.0 - TIME * 1.5));
			float dx = (wave * 2.0 - 1.0) * heat_distort * proximity;
			COLOR = texture(TEXTURE, UV + vec2(dx, 0.0));
			return;
		}
	}

	COLOR = base;
}
