shader_type canvas_item;

// The color of the border. You can change this in the Inspector.
uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// How thick the border line should be.
uniform float border_width : hint_range(0.0, 10.0) = 1.0;

// The alpha difference needed to trigger the border.
// Lower values are more sensitive and can detect softer edges.
uniform float threshold : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    // Get the size of a single pixel in the texture's UV space.
    vec2 pixel_size = 1.0 / TEXTURE_PIXEL_SIZE;

    // Sample the alpha (transparency) of the current pixel and its neighbors.
    float center_alpha = texture(TEXTURE, UV).a;
    float up_alpha     = texture(TEXTURE, UV + vec2(0.0, pixel_size.y * border_width)).a;
    float down_alpha   = texture(TEXTURE, UV - vec2(0.0, pixel_size.y * border_width)).a;
    float left_alpha   = texture(TEXTURE, UV - vec2(pixel_size.x * border_width, 0.0)).a;
    float right_alpha  = texture(TEXTURE, UV + vec2(pixel_size.x * border_width, 0.0)).a;

    // Calculate the total difference in alpha between the center and its neighbors.
    // A large value indicates a sharp change, i.e., an edge.
    float alpha_gradient = abs(up_alpha - center_alpha) + abs(down_alpha - center_alpha) + abs(left_alpha - center_alpha) + abs(right_alpha - center_alpha);

    // Use the step() function to create a hard edge.
    // If the gradient is greater than the threshold, the result is 1.0 (draw border).
    // Otherwise, the result is 0.0 (transparent).
    float border = step(threshold, alpha_gradient);

    // Set the final pixel color to the border color.
    COLOR = border_color;
    // Set the final alpha based on our border calculation.
    COLOR.a = border;
}