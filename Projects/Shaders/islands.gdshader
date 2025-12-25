shader_type canvas_item;

// --- Settings ---
group_uniforms Gradient_Colors;
uniform vec4 gradient_start : source_color = vec4(0.0, 0.8, 1.0, 0.8); // Cyan, close to shore
uniform vec4 gradient_end : source_color = vec4(1.0, 1.0, 1.0, 0.4); // White transparent, far out
group_uniforms;

group_uniforms Outline_Settings;
uniform float thickness : hint_range(0.0, 20.0) = 5.0; // Maximum distance
uniform float gradient_sharpness : hint_range(0.1, 5.0) = 1.0; // Controls how fast the gradient fades
uniform int precision : hint_range(4, 16) = 8; // Higher = smoother gradient but slower
group_uniforms;

group_uniforms Animation;
uniform float speed : hint_range(0.0, 5.0) = 2.0; // How fast waves pulse
uniform float variance : hint_range(0.0, 1.0) = 0.3; // How much thickness changes
group_uniforms;


void fragment() {
    vec2 size = TEXTURE_PIXEL_SIZE;
    float current_alpha = texture(TEXTURE, UV).a;

    // If we are already on the island, just draw the island and exit.
    if (current_alpha > 0.9) {
        COLOR = texture(TEXTURE, UV);
    }
    else {
        // --- The Gradient Logic ---

        // 1. Calculate animated thickness
        float wave_mod = sin(TIME * speed) * variance;
        float current_max_width = thickness * (1.0 + wave_mod);

        // 2. Determine "How close am I to the shore?"
        // We take multiple samples moving outwards.
        // The average alpha of these samples tells us our proximity density.
        float accumulated_alpha = 0.0;

        // Iterate in 8 directions (N, S, E, W, NE, NW, SE, SW) for smoother results
        vec2 directions[8] = { vec2(0, -1), vec2(0, 1), vec2(-1, 0), vec2(1, 0), vec2(1, 1), vec2(-1, 1), vec2(1, -1), vec2(-1, -1) };

        // We check at different distances up to the max width
        for(int i = 1; i <= precision; i++) {
            float sample_distance = (float(i) / float(precision)) * current_max_width;

            for(int j = 0; j < 8; j++) {
                 accumulated_alpha += texture(TEXTURE, UV + directions[j] * size * sample_distance).a;
            }
        }

        // 3. Normalize the result
        // The maximum possible accumulated value is precision * 8 directions.
        float proximity_factor = accumulated_alpha / float(precision * 8);

        // Apply sharpness curve (pow makes the falloff nonlinear)
        proximity_factor = pow(proximity_factor, gradient_sharpness);

        // Clamp to ensure it stays between 0 and 1
        proximity_factor = clamp(proximity_factor, 0.0, 1.0);

        // 4. Create the gradient color
        // If factor is 1.0 (very close), use start color. If 0.0 (far), use end color.
        vec4 final_outline_color = mix(gradient_end, gradient_start, proximity_factor);

        // 5. Apply final color based on proximity
        // Use smoothstep to cut off the very outer edge cleanly
        float outline_mask = smoothstep(0.0, 0.1, proximity_factor);
        COLOR = mix(vec4(0.0), final_outline_color, outline_mask);
    }
}