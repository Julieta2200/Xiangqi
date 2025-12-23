shader_type canvas_item;

// The noise pattern that determines the shape of the fog
uniform sampler2D noise_texture; // Assign a NoiseTexture2D here

// Controls the animation: 0.0 is normal, 1.0 is fully gone
uniform float progress : hint_range(0.0, 1.0) = 0.0;

// The color of the fog/smoke
uniform vec4 smoke_color : source_color = vec4(0.6, 0.6, 0.6, 1.0);

// How "thick" the smoke edge is
uniform float smoke_density : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    // Get the base color of the sprite
    vec4 sprite_color = texture(TEXTURE, UV);

    // Sample the noise texture
    // We add 'progress' to UV.y to make the smoke feel like it's rising slightly
    float noise_value = texture(noise_texture, UV + vec2(0.0, progress * -0.5)).r;

    // Calculate the visibility based on progress and noise
    // We modify progress slightly so the effect starts immediately and finishes cleanly
    float current_threshold = progress * (1.0 + smoke_density * 2.0) - smoke_density;

    // Create the "smoke edge" logic
    if (noise_value < current_threshold) {
        // Pixel is fully dissolved
        COLOR = vec4(0.0);
    }
    else if (noise_value < current_threshold + smoke_density) {
        // Pixel is in the "transition" phase (turning into smoke)
        // Interpolate between the sprite color and the smoke color
        float factor = (noise_value - current_threshold) / smoke_density;

        // Optional: Distort alpha to make it look wispy
        vec4 misty_color = mix(smoke_color, sprite_color, factor);
        misty_color.a *= sprite_color.a; // Maintain original transparency shape
        COLOR = misty_color;
    }
    else {
        // Pixel is untouched
        COLOR = sprite_color;
    }
}