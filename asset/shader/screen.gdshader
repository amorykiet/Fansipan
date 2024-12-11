shader_type canvas_item;

uniform float outerRadius : hint_range(0.0, 1500.0) = 0.5;
uniform vec2 position = vec2(1.0);


void fragment() {
	float alpha = 1.0;
	vec2 uv = UV.xy;
	uv.x *= 1288.0/4.0;
	uv.y *= 728.0/4.0;
	
	if (distance(uv.xy, position.xy) < outerRadius){
		alpha = 0.0;
	}
	COLOR = vec4(0,0,0,alpha);
}