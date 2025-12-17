shader_type canvas_item;

// SETTINGS
uniform vec4 rain_color : source_color = vec4(0.8, 0.9, 1.0, 1.0);
uniform float outline_thickness : hint_range(0.0, 10.0) = 1.0;
uniform float speed : hint_range(0.0, 5.0) = 1.0; 
uniform float density : hint_range(0.0, 1.0) = 0.5;

// CONTROLS
// 0.0 = Strictly top flat surfaces only
// 1.0 = Wraps around shoulders/curves
uniform float top_spread : hint_range(0.0, 1.0) = 0.6; 

uniform sampler2D noise_texture : repeat_enable;

void fragment() {
    vec4 sprite_color = texture(TEXTURE, UV);
    float alpha = sprite_color.a;
    vec2 size = TEXTURE_PIXEL_SIZE;
    
    // --- 1. DIRECTIONAL EDGE DETECTION ---
    // We only look for pixels that are "below" us in different ways.
    // Ideally, we are a transparent pixel sitting above an opaque one.
    
    // Check directly down (Positive Y)
    float down = texture(TEXTURE, UV + vec2(0.0, outline_thickness) * size).a;
    
    // Check diagonals (Down-Left and Down-Right) for shoulders
    float down_left = texture(TEXTURE, UV + vec2(-outline_thickness, outline_thickness) * size).a;
    float down_right = texture(TEXTURE, UV + vec2(outline_thickness, outline_thickness) * size).a;
    
    // Combine them based on spread
    // If spread is 0, we only care about 'down'. If spread is 1, diagonals matter fully.
    float max_a = down;
    max_a = max(max_a, down_left * top_spread);
    max_a = max(max_a, down_right * top_spread);
    
    // We strictly ignore 'up' neighbors, so no rain appears on feet/bottom.
    
    // Calculate the edge intensity (Outside - Inside)
    float edge = max_a - alpha;
    
    // Clamp edge to clean up artifacts
    edge = clamp(edge, 0.0, 1.0);
    
    // --- 2. RAIN SIMULATION (Same as before) ---
    vec2 noise_uv = UV;
    noise_uv.y -= TIME * speed; 
    noise_uv.x *= 0.5; 
    
    float rain_val = texture(noise_texture, noise_uv).r;
    float droplet = step(1.0 - density, rain_val);
    
    // --- 3. COMBINE ---
    vec4 final_rain = rain_color;
    final_rain.a = edge * droplet;
    
    COLOR = mix(sprite_color, final_rain, final_rain.a);
}