shader_type canvas_item;
uniform sampler2D light_texture : source_color;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec3 color;

void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV);
	COLOR.a = texture(light_texture, UV).r;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
