extends Node

var _logs = Logs.new("save")#, Logs.Level.DEBUG)

func _get_save_path(scene):
    var hash: String
    if scene is Node:
        hash = str(scene.scene_file_path.hash())
    if scene is PackedScene:
        hash = str(scene.resource_path.hash())
    return "user://%s.save" % [hash]

func save_scene(scene: Node):
    var res_path = _get_save_path(scene)
    _logs.info("save %s (%s)" % [scene.name, ProjectSettings.globalize_path(res_path)])
    var nodes = []
    for node in scene.find_children("*"):
        if node is Node2D and node.is_in_group(Groups.SAVE_ME):
            var node_data = {
                "global_transform": node.global_transform,
                "scene_file_path": node.scene_file_path
            }
            if node.has_method("save"):
                # get node custom save data
                var more_data: Dictionary = node.call("save")
                _logs.error(not more_data, "save() should return a dictionary (%s)" % [node])
                node_data.merge(more_data, true)
            nodes.append(node_data)
    var f = FileAccess.open(res_path, FileAccess.WRITE)
    var data = {
        "nodes": nodes
    }
    f.store_var(data)
    f.close()
    _logs.debug("save %s" % [data])
    
func load_scene(scene: PackedScene):
    get_tree().change_scene_to_packed(scene)
    var path = _get_save_path(scene)
    var f = FileAccess.open(path, FileAccess.READ)
    var data = f.get_var() if f else null
    if data is Dictionary:
        # clear nodes that can be saved
        for node in get_tree().get_nodes_in_group(Groups.SAVE_ME):
            NodeUtil.remove(node)
        # load saved nodes
        for node_data: Dictionary in data.get("nodes"):
            var node_scene: PackedScene = load(node_data.get("scene_file_path"))
            var node: Node2D = node_scene.instantiate()
            node.global_transform = node_data.get("global_transform")
            Events.entity_created.emit(node)
