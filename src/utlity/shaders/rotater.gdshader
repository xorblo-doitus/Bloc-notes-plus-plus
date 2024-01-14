shader_type canvas_item;

uniform float rotation_clockwise = 0;


vec2 rotateUV(vec2 uv, vec2 pivot, float rotation_counter_clockwise) {
	float cosine = cos(rotation_counter_clockwise);
	float sine = sin(rotation_counter_clockwise);
	uv -= pivot;
	return vec2(
		cosine * uv.x - sine * uv.y,
		cosine * uv.y + sine * uv.x 
	) + pivot;
}

void vertex() {
	UV = rotateUV(UV, vec2(0.5, 0.5), -rotation_clockwise);
}

//void fragment() {
	//if( 0.0 < UV.x && UV.x < 1.0 && 0.0 < UV.y && UV.y < 1.0) {
		//COLOR = vec4(UV.x, UV.y, 0, 1);
	//}
//}
