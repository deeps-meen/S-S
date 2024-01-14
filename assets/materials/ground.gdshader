shader_type spatial;
render_mode specular_schlick_ggx, cull_back;

uniform sampler2D tex_color: hint_default_white;
uniform sampler2D tex_form : hint_default_white;
uniform float tile_color: hint_range( 1.0, 16.0, 0.1 ) = 4.0;
uniform float tile_form : hint_range( 1.0, 16.0, 0.1 ) = 2.0;
uniform float form : hint_range( -0.1, 0.1, 0.01 ) = 0.05;
uniform float deep_light : hint_range( 0.0, 0.9, 0.1 ) = 0.1;

//Terrain
void fragment() {
	float form_read = texture(tex_form, UV * tile_form).r;
	float UV_form_x = UV.x * tile_color;
	float UV_form_y = UV.y * tile_color- INV_VIEW_MATRIX[1].y * INV_VIEW_MATRIX[1].z * (clamp(form_read, deep_light, 1.0)) * form;
	vec2 UV_form = vec2(UV_form_x, UV_form_y );
	vec3 tex_color_read = texture(tex_color,UV_form).rgb;

	ALBEDO =  tex_color_read * (clamp(form_read, deep_light, 1.0));
}