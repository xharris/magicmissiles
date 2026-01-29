shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    COLOR = vec4(244.0/255.0, 67.0/255.0, 54.0/255.0, 1); // = textureLod(screen_texture, SCREEN_UV, 0.0);
}