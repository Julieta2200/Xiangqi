shader_type canvas_item;

// --- Main Parameters ---
uniform float crack_progress : hint_range(0.0, 1.0) = 0.5;
uniform vec4 crack_color : source_color = vec4(0.1, 0.1, 0.1, 1.0);
uniform float crack_width : hint_range(0.0, 0.05) = 0.01;
// Controls the jaggedness of the main crack's path.
uniform float distortion : hint_range(0.0, 0.5) = 0.15;
// Controls the number and size of branches. Higher value = more, smaller branches.
uniform float branch_complexity : hint_range(1.0, 10.0) = 5.0;


// --- Helper functions for noise generation ---

// Classic 2D random function
vec2 random(vec2 st) {
    st = vec2(dot(st, vec2(127.1, 311.7)),
              dot(st, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(st) * 43758.5453123);
}

// Simple Perlin-like 2D noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);

    float a = dot(random(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0));
    float b = dot(random(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0));
    float c = dot(random(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0));
    float d = dot(random(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0));

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractional Brownian Motion (fBm) to layer noise for more detail
float fbm(vec2 uv) {
    float value = 0.0;
    float amplitude = 0.5;
    
    // 4 layers (octaves) of noise
    for (int i = 0; i < 4; i++) {
        value += amplitude * noise(uv);
        uv *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}


// --- Main shader logic ---

void fragment() {
    vec2 uv = UV;

    // 1. Create a distorted, noisy line for the crack path.
    // We use Fractional Brownian Motion (fbm) for a more detailed, rocky noise.
    // By taking the absolute value, we create a "valley" or "crease" in the noise.
    // The main trunk is formed by stretching the noise vertically.
    vec2 main_uv = vec2(uv.x, uv.y * 0.5); // Stretch UVs to make a longer, primary crack
    float crack_noise = abs(fbm(main_uv * branch_complexity));
    
    // 2. Add distortion to make the main path less straight.
    // This uses a lower-frequency noise to warp the overall path of the crack.
    float path_distortion = noise(vec2(uv.y * 2.0, 0.0)) * distortion;
    
    // 3. Define the crack shape.
    // We start with the crease from step 1, then apply the path distortion from step 2.
    // We also make the crack fade out towards the horizontal edges.
    float edge_fade = smoothstep(0.0, 0.5, abs(uv.x - 0.5));
    float crack_shape = crack_noise / (0.01 + path_distortion + edge_fade);

    // 4. Animate the crack growing from top to bottom.
    // We create a mask that is only "on" for pixels below the progress line.
    float growth_mask = 1.0 - smoothstep(crack_progress - 0.1, crack_progress, uv.y);
    
    // 5. Define the final crack line.
    // We use smoothstep to turn the noisy shape into a hard line with a specific width.
    // This is where the crack gets its final thickness.
    float crack_line = smoothstep(crack_width, 0.0, crack_shape);

    // 6. Final color calculation.
    float crack_alpha = crack_line * growth_mask;

    COLOR = crack_color;
    COLOR.a = crack_alpha;
}
