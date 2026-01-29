extends Node2D

const color = Color(0.8, 0.8, 0.8, 0.1)

@onready var player: Actor = %Player
@onready var camera: Camera2D = %CameraFocusManager
@onready var viewport: Viewport = get_viewport()
@onready var spawn_cam_focus: SpawnCameraFocus = %SpawnCameraFocus

@export var grid_size: Vector2 = Vector2(32, 32)
@export var origin_thickness: int = 6

func _ready() -> void:
    Events.entity_created.connect(_on_entity_created)
    spawn_cam_focus.animation_finished.connect(_on_spawn_cam_animation_finished)
    
    player.control.can_move = false
    player.control.can_aim = false
    spawn_cam_focus.finish_to = player.camera

func _on_spawn_cam_animation_finished():
    player.control.can_move = true
    player.control.can_aim = true
    
func _on_entity_created(entity: Node2D):
    add_child(entity)

func _process(delta):
    queue_redraw()

func _draw():
    # draw grid
    var vp_size = viewport.size
    var cam_pos = Vector2.ZERO # camera.position
    var zoom = Vector2.ONE # camera.zoom
    var vp_right = vp_size.x * zoom.x
    var vp_bottom = vp_size.y * zoom.y
    
    var leftmost = -vp_right + cam_pos.x
    var topmost = -vp_bottom + cam_pos.y
    
    var left = ceil(leftmost / grid_size.x) * grid_size.x
    var bottommost = vp_bottom + cam_pos.y
    for x in range(0, vp_size.x / zoom.x + 1):
        draw_line(Vector2(left, topmost), Vector2(left, bottommost), color, origin_thickness if left == 0 else 1)
        left += grid_size.x

    var top = ceil(topmost / grid_size.y) * grid_size.y
    var rightmost = vp_right + cam_pos.x
    for y in range(0, vp_size.y / zoom.y + 1):
        draw_line(Vector2(leftmost, top), Vector2(rightmost, top), color, origin_thickness if top == 0 else 1)
        top += grid_size.y
