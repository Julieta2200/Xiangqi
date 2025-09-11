shader_type canvas_item;

// A uniform variable to control the transition progress from 0.0 to 1.0.
uniform float progress : hint_range(0.0, 1.0);

void fragment() {
	// Get the original color of the pixel from the texture.
	vec4 tex_color = texture(TEXTURE, UV);

	// Define a solid red color, but use the texture's original alpha.
	// This ensures transparent parts of the image don't become solid red squares.
	vec4 red = vec4(1.0, 0.0, 0.0, tex_color.a);

	// Mix (interpolate) between red and the original texture color based on 'progress'.
	// When progress is 0, the color is red. When progress is 1, it's the texture color.
	vec4 final_color = mix(red, tex_color, progress);

	// Calculate the reveal effect.
	// UV.y is 0 at the top and 1 at the bottom. We want to reveal from bottom to top,
	// so we use (1.0 - UV.y), which is 0 at the bottom and 1 at the top.
	// The step() function will return 0.0 if the pixel is above the progress line,
	// and 1.0 if it's at or below it, effectively making it visible.
	float reveal_mask = step(1.0 - UV.y, progress);

	// Apply the reveal mask to the alpha channel of our final color.
	// This makes pixels above the progress line transparent.
	final_color.a *= reveal_mask;

	// Set the final pixel color.
	COLOR = final_color;
}
