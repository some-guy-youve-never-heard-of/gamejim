shader_type canvas_item;
uniform vec3 light_color = vec3(1,0,0);
uniform sampler2D mask;

void fragment() {
	vec4 c = texture(mask, SCREEN_UV);
	COLOR.a = length(vec3(c.r*light_color.x, c.g*light_color.y, c.b*light_color.z));
	//COLOR.a = texture(mask, SCREEN_UV).r;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
