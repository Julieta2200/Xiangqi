shader_type canvas_item;

// Reddish tint color
uniform vec4 tint_color : source_color = vec4(1.0, 0.3, 0.3, 1.0);

// Strength of the red tint (0.0–1.0)
uniform float tint_strength : hint_range(0.0, 1.0) = 0.35;

// Pulse speed
uniform float pulse_speed : hint_range(0.0, 20.0) = 3.0;

// Pulse intensity (0.0 = constant tint)
uniform float pulse_amount : hint_range(0.0, 1.0) = 0.2;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);

    // Keep transparent pixels unchanged
    if (original_color.a == 0.0) {
        COLOR = original_color;
    } else {
        // Subtle pulsing effect
        float pulse = (sin(TIME * pulse_speed) + 1.0) * 0.5;

        float final_strength =
            tint_strength * (1.0 - pulse_amount + pulse * pulse_amount);

        // Blend original color with the reddish tint
        vec3 tinted_rgb = mix(
            original_color.rgb,
            tint_color.rgb,
            final_strength
        );

        COLOR = vec4(tinted_rgb, original_color.a);
    }
}
