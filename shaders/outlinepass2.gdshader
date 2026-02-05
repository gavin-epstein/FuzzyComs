// Edge-Detection Shader Pass 2
// Here's our fully lit and shaded model,
// but through the SCREEN_TEXTURE, we also have the world normals
// of all the visible parts of our model that the first pass gives us.
// LICENSE: MIT

shader_type spatial;
render_mode blend_mix,depth_prepass_alpha,cull_back,diffuse_lambert;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color;
uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D pencilnoise:source_color;
uniform sampler2D roughness_texture:source_color;
uniform float wobbly_lines = 1;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float edge_strength : hint_range(0,1) = 1.0;
uniform float edge_thresh: hint_range(0,1)=.2;
uniform float edge_size = 1.;
uniform float texture_scale=1;
uniform vec4 edge_color : source_color = vec4(0.5, 0.5, 0.5, 1.0);



float difference(vec3 c1, vec3 c2){
	vec3 diff = abs(c2-c1);
	return max(diff.r,max(diff.g , diff.b));
}

// transform a pixel coordinate to screen UV
vec2 pixel_to_screen_uv(vec2 viewport_size, vec2 pixel) {
	return vec2(pixel.x / viewport_size.x, pixel.y / viewport_size.y);
}

void fragment() {
	vec4 albedo_tex = texture(texture_albedo, UV);
	vec2 iuv = vec2(SCREEN_UV.x * VIEWPORT_SIZE.x, SCREEN_UV.y * VIEWPORT_SIZE.y);
	float depth = texture(depth_texture,SCREEN_UV).r;
	#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
	vec3 ndc = vec3(SCREEN_UV, depth) * 2.0 - 1.0;
	#else
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	#endif
	 vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
 	 view.xyz /= view.w;
  	float linear_depth = -view.z;
	float depth_edge_size = edge_size/linear_depth;
	//ALBEDO = vec3(fract(depth_edge_size));/*
	ALBEDO = albedo.rgb * texture(texture_albedo, UV*texture_scale).rgb;
	float noise = (texture(pencilnoise,UV*5.).r-.5)*depth_edge_size*wobbly_lines;
	for(float i=depth_edge_size; i>0.; i--){
		vec3 neighbour_left = texture(screen_texture, pixel_to_screen_uv(VIEWPORT_SIZE, iuv + vec2(-.5*i+noise, 0))).rgb;
		vec3 neighbour_right = texture(screen_texture, pixel_to_screen_uv(VIEWPORT_SIZE, iuv + vec2(.5*i+noise, 0))).rgb;
		vec3 neighbour_top = texture(screen_texture, pixel_to_screen_uv(VIEWPORT_SIZE, iuv + vec2(0, -.5*i+noise))).rgb;
		vec3 neighbour_bottom = texture(screen_texture, pixel_to_screen_uv(VIEWPORT_SIZE, iuv + vec2(0,.5*i+noise))).rgb;
		float diff = .5*(difference(neighbour_left,neighbour_right)+difference(neighbour_top,neighbour_bottom));
		if (diff > edge_thresh) {
		ALBEDO = mix(ALBEDO, edge_color.rgb, diff*edge_strength);
		}
	}
	
	
	// compare normals: if they differ, we draw an edge
	// by mixing in the edge_color, by edge_strength amount
	// feel free to try other ways to mix, such as multiply for more textured objects.
	
	

	
	METALLIC = metallic;
	ROUGHNESS = roughness * texture(roughness_texture, UV*texture_scale).r;
	SPECULAR = specular;
}
