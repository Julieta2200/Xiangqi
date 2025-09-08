// A simple shader to draw an outline around a sprite's non-transparent pixels.
shader_type canvas_item;

// The color of the outline. You can change this in the Inspector.
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0); // Default Yellow

// The width of the outline. You can adjust this in the Inspector.
uniform float outline_width : hint_range(0.0, 10.0) = 1.5;

void fragment() {
    // Get the size of a single pixel in UV coordinates.
    vec2 pixel_size = 1.0 / vec2(textureSize(TEXTURE, 0));
    float max_alpha = 0.0;

    // Check the alpha value of the 8 pixels surrounding the current one.
    // This is often called a "kernel".
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            // Calculate the UV coordinate of the neighboring pixel.
            vec2 neighbor_uv = UV + vec2(float(x), float(y)) * pixel_size * outline_width;

            // Get the neighbor's alpha and find the maximum alpha in the neighborhood.
            float neighbor_alpha = texture(TEXTURE, neighbor_uv).a;
            max_alpha = max(max_alpha, neighbor_alpha);
        }
    }

    // Get the color of the current pixel from the original texture.
    vec4 original_color = texture(TEXTURE, UV);

    // The magic happens here!
    // We mix the original color with the outline color.
    // The mix amount is based on the highest alpha found in the neighbors,
    // but ONLY if the current pixel is transparent (original_color.a is close to 0).
    // This draws the outline color in the transparent area just outside the sprite.
    COLOR = mix(original_color, outline_color, max_alpha * (1.0 - original_color.a));
}
