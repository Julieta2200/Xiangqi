shader_type canvas_item;

// Uniforms to control the glow from the Inspector
uniform vec4 glow_color : source_color = vec4(1.0, 0.75, 0.0, 1.0);
uniform vec4 main_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // New: Controls the sprite's color
uniform float glow_intensity : hint_range(0.0, 5.0) = 1.0;
uniform float glow_spread : hint_range(0.0, 5.0) = 1.0;

void fragment() {
	// TEXTURE_PIXEL_SIZE gives us the size of one pixel in UV coordinates.
	// This is essential for sampling neighboring pixels correctly.
	vec2 px = TEXTURE_PIXEL_SIZE;

	// We'll accumulate the alpha from surrounding pixels in this variable.
	float total_alpha = 0.0;

	// --- Create the blur for the glow ---
	// Sample pixels in a cross pattern around the current pixel.
	// This is a simple and performant way to create a blur effect.
	// The 'glow_spread' uniform controls how far out we sample, changing the glow's size.
	total_alpha += texture(TEXTURE, UV + vec2(0.0, -2.0 * px.y * glow_spread)).a;
	total_alpha += texture(TEXTURE, UV + vec2(0.0, -1.0 * px.y * glow_spread)).a;
	total_alpha += texture(TEXTURE, UV + vec2(0.0, 1.0 * px.y * glow_spread)).a;
	total_alpha += texture(TEXTURE, UV + vec2(0.0, 2.0 * px.y * glow_spread)).a;

	total_alpha += texture(TEXTURE, UV + vec2(-2.0 * px.x * glow_spread, 0.0)).a;
	total_alpha += texture(TEXTURE, UV + vec2(-1.0 * px.x * glow_spread, 0.0)).a;
	total_alpha += texture(TEXTURE, UV + vec2(1.0 * px.x * glow_spread, 0.0)).a;
	total_alpha += texture(TEXTURE, UV + vec2(2.0 * px.x * glow_spread, 0.0)).a;

	// Average the alpha from the 8 samples we took. This is our blurred shape.
	float blurred_alpha = total_alpha / 8.0;

	// --- Combine the original sprite and the glow ---
	// Get the original color and alpha of the sprite at the current pixel.
	vec4 original_color = texture(TEXTURE, UV);

	// New: Tint the original sprite's color with our new main_color uniform.
	vec3 tinted_sprite_rgb = original_color.rgb * main_color.rgb;

	// Calculate the glow color. This is based on our blurred shape and the desired intensity.
	vec3 glow = glow_color.rgb * blurred_alpha * glow_intensity;

	// The final color is the tinted sprite's color drawn ON TOP of the glow.
	// We use `mix` to blend them. Where the original sprite is visible (original_color.a > 0), we show its color.
	// Where it's transparent, we show the glow.
	vec3 final_rgb = mix(glow, tinted_sprite_rgb, original_color.a);

	// The final alpha should be the maximum of the original sprite's alpha and the glow's alpha.
	// This ensures both the solid crack and its fuzzy glow aura are visible.
	float final_alpha = max(original_color.a, blurred_alpha);

	COLOR = vec4(final_rgb, final_alpha);
}
