// Edge-Detection Shader Pass 1
// Here we simply pass the vertex normals to the albedo
// so we can access it through the SCREEN_TEXTURE in our Shader Pass 2
// LICENSE: MIT

shader_type spatial;
render_mode unshaded,blend_mix,depth_draw_opaque,cull_back,diffuse_toon,specular_disabled,shadows_disabled;
//uniform sampler2D depth_texture : hint_depth_texture;
varying vec3 world_normal;

void vertex() {
	world_normal = NORMAL;
}

void fragment() {
	//depth is apparently only accessible on one pass
/*	float depth = texture(depth_texture,SCREEN_UV).r;
	#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
	vec3 ndc = vec3(SCREEN_UV, depth) * 2.0 - 1.0;
	#else
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	#endif
	  vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
  view.xyz /= view.w;
  float linear_depth = -view.z;*/

  //ALBEDO.rgb = mix(vec3(.5+.5*sin(5.*linear_depth)), world_normal.rgb, .5);
ALBEDO.rgb = world_normal.rgb;
}
