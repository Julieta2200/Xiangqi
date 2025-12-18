shader_type canvas_item;

// Captures the screen behind this node
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
// Controls the blur strength (0.0 is no blur, 5.0 is very blurry)
uniform float blur_amount : hint_range(0.0, 5.0);

void fragment() {
	// textureLod samples a mipmap level. Higher LOD = Blurriness.
	vec4 color = textureLod(screen_texture, SCREEN_UV, blur_amount);
	COLOR = color;
}