shader_type canvas_item;
//render_mode screen_texture;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform float size = 16.0;
uniform float camera_zoom = 1.0;

void fragment() {
    vec2 viewport_size = vec2(textureSize(SCREEN_TEXTURE, 0));

    float scaled_size = max(size / camera_zoom, 1.0);

    vec2 pixelated_coord =
        floor(SCREEN_UV * viewport_size / scaled_size) * scaled_size;

    vec2 pixelated_uv = pixelated_coord / viewport_size;

    COLOR = texture(SCREEN_TEXTURE, pixelated_uv);
}
