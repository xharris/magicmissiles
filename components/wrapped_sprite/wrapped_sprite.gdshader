shader_type canvas_item;

uniform vec2 offset;

void fragment(){
	vec2 newuv = SCREEN_UV * (TEXTURE_PIXEL_SIZE / SCREEN_PIXEL_SIZE) / vec2(5);
    newuv += (offset / vec2(5)) * TEXTURE_PIXEL_SIZE;
	COLOR = texture(TEXTURE, newuv);
}