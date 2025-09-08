shader_type canvas_item;
render_mode unshaded;

// Uniforms are parameters you can control from the Godot Inspector or via script.
group_uniforms DissolveEffect;
uniform float dissolve_progress : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform vec4 ash_color : source_color = vec4(0.1, 0.1, 0.1, 1.0);
uniform vec4 ember_color : source_color = vec4(1.0, 0.5, 0.1, 1.0);
uniform float ember_width : hint_range(0.0, 0.2) = 0.05;

group_uniforms NoiseAndPiling;
uniform sampler2D noise_texture : source_color,filter_linear_mipmap,repeat_enable;
uniform float noise_scale = 1.0;
// Y position in pixels (relative to sprite origin) where ashes pile up.
uniform float ground_level : hint_range(-500.0, 500.0) = 50.0;
// How much the pile spreads horizontally, in pixels.
uniform float pile_spread = 20.0;

// VARYING is used to pass data from the vertex shader to the fragment shader.
varying float noise_val;
varying float fall_amount;

void vertex() {
	// Get the world position of the vertex to keep the noise pattern stable.
	vec2 world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	// Sample noise based on the world position. We scale it down because pixel coordinates are large.
	noise_val = texture(noise_texture, world_pos * noise_scale * 0.01).r;

	// Calculate how much this vertex should fall (0.0 = not at all, 1.0 = fully fallen).
	// The multiplication makes the transition faster and more defined.
	fall_amount = clamp((dissolve_progress - noise_val) * 5.0, 0.0, 1.0);

	// The target position for the ash pile.
	vec2 ash_pile_position = VERTEX;
	ash_pile_position.y = ground_level;
	ash_pile_position.x += (noise_val - 0.5) * pile_spread;

	// Move the vertex towards the ash pile position based on the fall_amount.
	VERTEX = mix(VERTEX, ash_pile_position, fall_amount);
}

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
    // Discard any transparent parts of the original sprite texture.
    if (original_color.a < 0.1) {
        discard;
    }

	if (fall_amount > 0.0) {
		// If the vertex has started to fall, color it as ash.
		COLOR = ash_color;
		// Fade in the ash particles as they fall.
		COLOR.a *= fall_amount;
	} else {
		// This part has not fallen yet. Check if it should be discarded or colored as an ember.
		float dissolve_edge = 1.0 - smoothstep(dissolve_progress - ember_width, dissolve_progress, noise_val);

		if (dissolve_edge > 0.0) {
			// This is the glowing ember edge. Mix the original color with the ember color.
			COLOR = mix(original_color, ember_color, dissolve_edge);
		} else {
			// If it's not falling and not an ember, it's either untouched or should be gone.
			if (noise_val < dissolve_progress) {
				discard; // Discard to create the "hole".
			} else {
				COLOR = original_color; // Show the original, untouched sprite.
			}
		}
	}
}