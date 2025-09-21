shader_type canvas_item;

uniform float blur_size : hint_range(0.0, 20.0) = 4.0;
uniform float shadow_opacity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * blur_size;
	vec4 sum = vec4(0.0);
	float weight = 0.0;

	// 9-tap Gaussian blur kernel
	for (int x = -1; x <= 1; x++) {
		for (int y = -1; y <= 1; y++) {
			float w = 1.0;
			if (x == 0 && y == 0) w = 4.0;
			else if (x == 0 || y == 0) w = 2.0;
			vec2 offset = vec2(float(x), float(y)) * size;
			sum += texture(TEXTURE, UV + offset) * w;
			weight += w;
		}
	}
	sum /= weight;
	// Output black with blurred alpha for shadow effect, modulated by shadow_opacity
	COLOR = vec4(0.0, 0.0, 0.0, sum.a * shadow_opacity);
}
