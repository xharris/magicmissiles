extends Node
class_name NodeUtil

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

static func remove(node: Node):
    var parent = node.get_parent()
    parent.remove_child(node)
    node.queue_free()

static func clear_children(node: Node):
    for child in node.get_children():
        node.remove_child(child)

static func reparent2(node: Node, parent: Node):
    if node.get_parent():
        node.reparent(parent)
    else:
        parent.add_child(node)
