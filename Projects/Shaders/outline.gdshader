// An animated shader to draw a pulsating, wavy outline.
shader_type canvas_item;

// The color of the outline. Make it a bright yellow or gold!
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);

// The base width of the outline.
uniform float outline_width : hint_range(0.0, 10.0) = 2.0;

// -- New parameters for the energy effect --

// How fast the energy aura pulses.
uniform float pulse_speed : hint_range(0.0, 20.0) = 8.0;

// The frequency or "waviness" of the energy. Higher means more waves.
uniform float wave_frequency : hint_range(0.0, 50.0) = 20.0;

// The strength or amplitude of the waves.
uniform float wave_strength : hint_range(0.0, 10.0) = 1.5;


void fragment() {
    // Get the size of a single pixel in UV coordinates.
    vec2 pixel_size = 1.0 / vec2(textureSize(TEXTURE, 0));
    float max_alpha = 0.0;

    // Create a pulsating effect using a sine wave based on time.
    // This will oscillate between 0.0 and 1.0.
    float pulse = (sin(TIME * pulse_speed) + 1.0) / 2.0;

    // Calculate a dynamic width that grows and shrinks with the pulse.
    float dynamic_width = outline_width * (1.0 + pulse * 0.5);

    // Check the alpha value of the surrounding pixels.
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            if (x == 0 && y == 0) continue; // Skip the center pixel

            // This is the core of the wavy effect.
            // We create a distortion offset that changes over time and with position (UV).
            float angle = TIME * pulse_speed * 0.7 + UV.y * wave_frequency;
            vec2 distortion = vec2(sin(angle), cos(angle)) * pixel_size * wave_strength * pulse;

            // Calculate the neighbor's UV, applying the outline width and the distortion.
            vec2 neighbor_uv = UV + vec2(float(x), float(y)) * pixel_size * dynamic_width + distortion;

            // Get the neighbor's alpha and find the maximum alpha in the neighborhood.
            float neighbor_alpha = texture(TEXTURE, neighbor_uv).a;
            max_alpha = max(max_alpha, neighbor_alpha);
        }
    }

    // Get the color of the current pixel from the original texture.
    vec4 original_color = texture(TEXTURE, UV);

    // Calculate where the outline should be drawn.
    float outline_factor = max_alpha * (1.0 - original_color.a);

    // Make the outline fade in and out slightly with the pulse for a flicker effect.
    outline_factor *= (0.6 + pulse * 0.4);

    // Mix the original color with the bright outline color.
    COLOR = mix(original_color, outline_color, outline_factor);
}

