shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform float size = 16.0;
uniform float camera_zoom = 1.0;

void fragment() {
    // pixelate screen coordinates (TODO not working)
    float scaled_size = size * camera_zoom;
    vec2 pixelated_coord = FRAGCOORD.xy - mod(FRAGCOORD.xy, scaled_size);
    pixelated_coord += scaled_size * 0.5;
    COLOR = texture(SCREEN_TEXTURE, pixelated_coord * SCREEN_PIXEL_SIZE / TEXTURE_PIXEL_SIZE);
}