shader_type canvas_item;
render_mode unshaded, blend_add;

uniform vec4 glow_color : source_color = vec4(1.0, 0.8, 0.3, 1.0);
uniform float glow_strength : hint_range(0.0, 8.0) = 1.0;
uniform float glow_size : hint_range(0.0, 64.0) = 8.0;
uniform int samples : hint_range(1, 32) = 16;


const int MAX_SAMPLES = 32;

void fragment() {
    vec4 base = texture(TEXTURE, UV);

    float acc = 0.0;
    for (int i = 0; i < MAX_SAMPLES; i++) {
        if (i >= samples) break;

        float t = (float(i) + 0.5) / float(samples);
        float angle = t * 6.28318530718;
        vec2 dir = vec2(cos(angle), sin(angle));
        vec2 offset = dir * t * glow_size * TEXTURE_PIXEL_SIZE;

        vec4 s = texture(TEXTURE, UV + offset);
        acc += s.a * (1.0 - t);
    }

    float glow_amount = acc * (glow_strength / float(max(1, samples)));
    vec3 glow_rgb = glow_color.rgb * glow_amount;
    float glow_alpha = clamp(glow_amount * glow_color.a, 0.0, 1.0);

    COLOR = base + vec4(glow_rgb, glow_alpha);
}
