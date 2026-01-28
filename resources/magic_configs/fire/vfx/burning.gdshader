shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform float size = 16.0;

void fragment() {
    // pixelate screen coordinates
    vec2 pixelated_coord = FRAGCOORD.xy - mod(FRAGCOORD.xy, size);
    COLOR = texture(SCREEN_TEXTURE, pixelated_coord * SCREEN_PIXEL_SIZE / TEXTURE_PIXEL_SIZE);
}