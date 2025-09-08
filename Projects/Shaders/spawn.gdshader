shader_type canvas_item;

// This uniform variable will control the transition.
// A value of 0.0 means the image is fully red.
// A value of 1.0 means the image has its original colors.
uniform float progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	// Get the original color and alpha from the texture at the current pixel.
	vec4 original_color = texture(TEXTURE, UV);

	// Define the red color. We use the original_color.a to preserve transparency.
	vec4 red_color = vec4(1.0, 0.0, 0.0, original_color.a);

	// The mix() function blends two colors together.
	// Based on the 'progress' value, it will output a color somewhere
	// between red_color and original_color.
	COLOR = mix(red_color, original_color, progress);
}
