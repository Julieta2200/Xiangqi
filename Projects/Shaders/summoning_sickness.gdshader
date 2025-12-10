shader_type canvas_item;

// Ranges from 0.0 (0%) to 1.0 (100%)
// 0.0 = Original Color, 1.0 = Pitch Black
uniform float darker_percent : hint_range(0.0, 1.0) = 0.0;

// Ranges from 0.0 (0%) to 1.0 (100%)
// 0.0 = Fully Opaque, 1.0 = Fully Invisible
uniform float transparency_percent : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	// Get the initial color of the pixel at this UV coordinate
	vec4 pixel_color = texture(TEXTURE, UV);
	
	// Apply Darkness
	// We multiply the RGB values by (1 - darker_percent)
	// Example: If darker_percent is 0.2 (20%), we multiply by 0.8 to keep 80% brightness
	pixel_color.rgb *= (1.0 - darker_percent);
	
	// Apply Transparency
	// We multiply the Alpha channel by (1 - transparency_percent)
	pixel_color.a *= (1.0 - transparency_percent);
	
	// Output the final color, multiplying by the node's Modulate (COLOR) 
	// to ensure the Sprite's "Modulate" property still works if you use it.
	COLOR = pixel_color * COLOR;
}