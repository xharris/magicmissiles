shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform float size = 16.0;
uniform float camera_zoom = 1.0;

void fragment() {
    // pixelate screen coordinates
    vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
    float scaled_size = size / camera_zoom;
    vec2 pixelated_coord = floor(SCREEN_UV * screen_size / scaled_size) * scaled_size;
    vec2 pixelated_uv = pixelated_coord / screen_size;
    COLOR = texture(SCREEN_TEXTURE, pixelated_uv);
}