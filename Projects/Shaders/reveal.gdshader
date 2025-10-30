shader_type canvas_item;

uniform float reveal_progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    float alpha = step(1.0 - reveal_progress, UV.y);

    COLOR = vec4(color.rgb, color.a * alpha);
}
