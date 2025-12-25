shader_type canvas_item;

// --- Uniforms (Settings you can change in the Inspector) ---
uniform vec4 color_deep : source_color = vec4(0.0, 0.1, 0.4, 1.0); // Dark blue
uniform vec4 color_shallow : source_color = vec4(0.0, 0.6, 0.8, 1.0); // Light blue
uniform sampler2D noise_texture : repeat_enable; // The noise image
uniform float speed : hint_range(0.0, 1.0) = 0.1;
uniform float wave_strength : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    // 1. Time-based movement
    // We create two "waves" moving in slightly different directions
    vec2 move_1 = vec2(TIME * speed, TIME * speed * 0.5);
    vec2 move_2 = vec2(TIME * speed * -0.4, TIME * speed * 1.2);

    // 2. Sample the noise texture twice
    // We use the UV (coordinates) + movement to scroll the texture
    float noise_1 = texture(noise_texture, UV + move_1).r;
    float noise_2 = texture(noise_texture, UV + move_2).r;

    // 3. Combine the noise layers
    // This creates an organic, non-repetitive pattern
    float wave_combined = noise_1 * noise_2;

    // 4. Create the distortion effect
    // We mix the two water colors based on the combined noise value
    vec4 water_color = mix(color_deep, color_shallow, wave_combined + wave_strength);

    // 5. Output the color
    COLOR = water_color;
    
    // Optional: Preserve transparency of the original sprite edges if needed
    // COLOR.a *= texture(TEXTURE, UV).a; 
}