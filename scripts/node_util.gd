extends Node
class_name NodeUtil

static var _log = Logs.new("node_util")

static func reconnect(sig: Signal, method: Callable):
    if not sig.is_connected(method):
        sig.connect(method)

static func reconnect_str(node: Object, sig_name: String, method: Callable):
    if node.has_signal(sig_name) and not node.is_connected(sig_name, method):
        node.connect(sig_name, method)
        

        
static func disable(node: Node):
    node.process_mode = Node.PROCESS_MODE_DISABLED
    if node is CanvasItem:
        node.visible = false
    
static func enable(node: Node):
    node.process_mode = Node.PROCESS_MODE_INHERIT
    if node is CanvasItem:
        node.visible = true

static func is_enabled(node: Node):
    if node.process_mode == Node.PROCESS_MODE_DISABLED:
        return false
    if node is Node2D:
        return node.visible
    return true

static func remove(node: Node, skip_free:bool = false):
    var parent = node.get_parent()
    if parent:
        _remove_child_deferred.call_deferred(parent, node)
    if not skip_free:
        node.queue_free()

static func _remove_child_deferred(parent:Node, child:Node):
    if child.get_parent() == parent:
        parent.remove_child(child)

static func clear_children(node: Node):
    for child in node.get_children():
        node.remove_child(child)

static func reparent2(node: Node, parent: Node):
    if not parent:
        _log.warn("parent is null, child: %s" % [node])
        return
    if node.get_parent():
        node.reparent(parent)
    else:
        parent.add_child(node)
