shader_type canvas_item;
uniform vec3 light_color = vec3(1,0,0);
uniform sampler2D mask;
uniform float force_visible = 0.0;

void fragment() {
	vec4 c = texture(mask, SCREEN_UV);
	COLOR.a = max(force_visible, length(vec3(c.r*light_color.x, c.g*light_color.y, c.b*light_color.z)));
}

//void light() {
//}
