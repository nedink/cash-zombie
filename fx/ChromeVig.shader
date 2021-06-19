shader_type canvas_item;
//render_mode unshaded, cull_disabled;

uniform float light : hint_range(0, 1);
uniform float extend : hint_range(0, 1);
uniform vec2 offset;

void fragment() {
	vec2 uv = UV;
	vec3 chroma;
	vec2 amount = offset * 0.0005;

	// cache screen
	vec3 og_color = textureLod( SCREEN_TEXTURE, SCREEN_UV, 0.).rgb;

	// cache screen witch chroma (r/b shifted by ammount)
	chroma.r = textureLod( SCREEN_TEXTURE, SCREEN_UV + vec2(amount.x, amount.y), 0.0).r;
	chroma.g = og_color.g;
	chroma.b = textureLod( SCREEN_TEXTURE, SCREEN_UV - vec2(amount.x, amount.y), 0.0).b;

	// generate gradient from center to the corners
	uv *=  1.0 - uv.yx;
	float vig = uv.x*uv.y * 20.0;
	vig = pow(vig, extend);
	vig = 1.0 - vig;

	// mix chroma with original image by the gradient (more on corners, less in center)
	vec3 chroma_vig = mix(og_color, chroma, vig * 2.);
	
	
	
	// mix chroma with vignette (darker version of chroma image)
	COLOR = vec4(mix(chroma, chroma * vec3(light), vig), 1f);
//	COLOR = vec4(chroma, 1f);
}


//void fragment() {
//	vec4 bg = texture(SCREEN_TEXTURE, SCREEN_UV);
//	float avg = (bg.r + bg.g +  bg.b) / 3f;
//	COLOR = vec4(avg, avg, avg, 1f);
//}