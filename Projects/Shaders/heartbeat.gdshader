shader_type canvas_item;

// Allows you to change these values from the Godot Inspector
uniform vec2 center = vec2(0.5, 0.5); // (0,0) is top-left, (1,1) is bottom-right
uniform float radius : hint_range(0.0, 1.0) = 0.25;
uniform float softness : hint_range(0.0, 1.0) = 0.15;

void fragment() {
    // Get the original color of the pixel from the texture
    vec4 original_color = vec4(0, 0, 0, 0.6);;

    // Calculate the distance of the current pixel (UV) from the center
    float dist = distance(UV, center);

    // Use smoothstep to create a smooth transition.
    // It returns 0 if dist < radius.
    // It returns 1 if dist > radius + softness.
    // It returns a smooth value between 0 and 1 for distances in between.
    float alpha_multiplier = smoothstep(radius, radius + softness, dist);

    // Apply the new alpha value to the original color's alpha
    original_color.a *= alpha_multiplier;

    // Set the final color of the pixel
    COLOR = original_color;
}