shader_type spatial;
render_mode blend_mix,depth_draw_always,cull_disabled,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float proximity_fade_distance;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform sampler2D texture_refraction;
uniform float refraction : hint_range(-16,16);
uniform vec4 refraction_texture_channel;
uniform sampler2D texture_normal : hint_normal;
uniform float normal_scale : hint_range(-16,16);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

// mis parametros
uniform float wave_speed : hint_range(0.01, 0.5);

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}




void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	
//	micodigo
	NORMALMAP = texture(texture_normal,vec2(base_uv.x + TIME * wave_speed, base_uv.y) * 1.2).rgb * texture(texture_normal,vec2(base_uv.x + TIME * -wave_speed, base_uv.y)).rgb;
//	NORMALMAP = texture(texture_normal,base_uv).rgb; //original
	
	
	
	
	NORMALMAP_DEPTH = normal_scale;
	vec3 unpacked_normal = NORMALMAP;
	unpacked_normal.xy = unpacked_normal.xy * 2.0 - 1.0;
	unpacked_normal.z = sqrt(max(0.0, 1.0 - dot(unpacked_normal.xy, unpacked_normal.xy)));
	vec3 ref_normal = normalize( mix(NORMAL,TANGENT * unpacked_normal.x + BINORMAL * unpacked_normal.y + NORMAL * unpacked_normal.z,NORMALMAP_DEPTH) );
	vec2 ref_ofs = SCREEN_UV - ref_normal.xy * dot(texture(texture_refraction,base_uv),refraction_texture_channel) * refraction;
	float ref_amount = 1.0 - albedo.a * albedo_tex.a;
	EMISSION += textureLod(SCREEN_TEXTURE,ref_ofs,ROUGHNESS * 8.0).rgb * ref_amount;
	ALBEDO *= 1.0 - ref_amount;
	//ALPHA = 1.0;
	ALPHA = 0.8;
	float depth_tex = textureLod(DEPTH_TEXTURE,SCREEN_UV,0.0).r;
	vec4 world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV*2.0-1.0,depth_tex*2.0-1.0,1.0);
	world_pos.xyz/=world_pos.w;
	ALPHA*=clamp(1.0-smoothstep(world_pos.z+proximity_fade_distance,world_pos.z,VERTEX.z),0.0,1.0);
}
