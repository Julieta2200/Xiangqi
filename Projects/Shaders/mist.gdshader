shader_type canvas_item;

// Uniforms allow you to tweak the shader's properties from the Godot editor.
uniform vec4 mist_color : source_color = vec4(0.8, 0.85, 0.9, 0.6);
uniform float scroll_speed : hint_range(0.0, 0.5) = 0.03;
uniform float density : hint_range(0.0, 1.0) = 0.5; // Controls the amount of mist. Higher is denser.
uniform float softness : hint_range(0.01, 1.0) = 0.5; // Controls the edge feathering, higher is softer
uniform float scale : hint_range(1.0, 30.0) = 8.0;
uniform float border_softness : hint_range(0.01, 0.5) = 0.25; // Controls the fade at the sprite's borders


// --- 2D Simplex Noise ---
// The following functions are a standard implementation of 2D Simplex Noise.
// It produces a high-quality, organic-looking procedural noise.
vec3 mod289_v3(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289_v2(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289_v3(((x*34.0)+1.0)*x); }

float snoise(vec2 v) {
    const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                        0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                       -0.577350269189626,  // -1.0 + 2.0 * C.x
                        0.024390243902439); // 1.0 / 41.0
    vec2 i  = floor(v + dot(v, C.yy) );
    vec2 x0 = v -   i + dot(i, C.xx);
    vec2 i1;
    i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;
    i = mod289_v2(i);
    vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));
    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
    m = m*m;
    m = m*m;
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;
    m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}
// --- End of Simplex Noise ---


// The fragment shader is executed for every pixel of the sprite.
void fragment() {
    // Scale the UV coordinates to "zoom" the noise pattern in or out.
    vec2 scaled_uv = UV * scale;

    // --- Scrolling Motion ---
    // We create two scrolling layers moving in slightly different directions and speeds.
    // This makes the mist look more natural and less like a simple scrolling texture.
    // TIME is a built-in Godot variable that contains the total elapsed time.
    vec2 motion1 = vec2(TIME * scroll_speed, TIME * scroll_speed * 0.7);
    vec2 motion2 = vec2(TIME * -scroll_speed * 0.5, TIME * scroll_speed * 0.9);

    // --- Noise Generation ---
    // Generate two layers of noise. Using multiple layers (often called "octaves")
    // adds detail and complexity to the final effect.
    // Simplex noise returns a value between -1.0 and 1.0, so we remap it to the 0.0 to 1.0 range.
    float noise1 = (snoise(scaled_uv + motion1) + 1.0) * 0.5;
    // The second layer is scaled differently to create finer details.
    float noise2 = (snoise(scaled_uv * 2.1 + motion2) + 1.0) * 0.5;

    // Combine the noise layers. We are weighting them to control their influence.
    float combined_noise = (noise1 * 0.6) + (noise2 * 0.4);

    // --- Border Fade Calculation ---
    // This creates a soft fade at the sprite's edges to avoid a hard cutoff.
    // `dist_from_edge` will be 0.0 in the center and 0.5 at the border.
    float dist_from_edge_x = abs(UV.x - 0.5);
    float dist_from_edge_y = abs(UV.y - 0.5);

    // We fade as we approach the max distance of 0.5. The fade starts at (0.5 - border_softness).
    float fade_x = 1.0 - smoothstep(0.5 - border_softness, 0.5, dist_from_edge_x);
    float fade_y = 1.0 - smoothstep(0.5 - border_softness, 0.5, dist_from_edge_y);
    float border_fade = fade_x * fade_y;

    // --- Final Color Calculation ---
    // Invert density to create an intuitive threshold. Higher density = more mist.
    float threshold = 1.0 - density;

    // Use smoothstep to create a feathered edge for the mist noise itself.
    float alpha = smoothstep(threshold - softness / 2.0, threshold + softness / 2.0, combined_noise);

    // Set the final pixel color to the chosen mist_color.
    COLOR = mist_color;
    // The final alpha is a combination of the noise, the mist color's alpha, AND the new border fade.
    COLOR.a *= alpha * border_fade;
}
