shader_type canvas_item;

// The current animation progress (0.0 to 1.0)
uniform float progress : hint_range(0.0, 1.0) = 0.0;

// The total height of your RichTextLabel in pixels (Set from script)
uniform float target_height = 300.0; 

// How soft the fade edge is (in pixels)
uniform float smoothness = 50.0; 

varying float cur_y_pixel;

void vertex() {
    // Capture the vertical pixel position
    cur_y_pixel = VERTEX.y;
}

void fragment() {
    // 1. Get the text color from the font texture
    vec4 text_color = texture(TEXTURE, UV);
    
    // 2. IMPORTANT: Multiply by COLOR to apply the Node's 'Modulate' property
    text_color *= COLOR;
    
    // 3. Calculate the reveal mask
    float visible_boundary = progress * target_height;
    float reveal_alpha = 1.0 - smoothstep(visible_boundary, visible_boundary + smoothness, cur_y_pixel);
    
    // 4. Apply the reveal alpha on top of the existing alpha
    text_color.a *= reveal_alpha;
    
    // 5. Output final color
    COLOR = text_color;
}