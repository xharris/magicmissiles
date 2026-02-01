extends Node2D
class_name TransferContainer
  
signal added(ctx: ContextNode)

@export var replenish_after: float = -1
@export var capacity: int = -1
var _nodes: Array[ContextNode] = []
var nodes: Array[ContextNode]:
    set(v):
        _nodes.assign(v)
    get:
        return _nodes.filter(func(n:ContextNode): return is_instance_valid(n.node))
var is_full:
    get:
        return capacity > -1 and (nodes.size() + _replenish_count + _transfer_count) >= capacity
## Can send/receive nodes
var enabled: bool = true

var _log = Logs.new("transfer_container")#, Logs.Level.DEBUG)
var _replenish_list: Array[ContextNode]
var _replenish_t: float
var _replenish_count: int
var _transfer_count: int

func clear():
    pass # TODO    

func has(ctx: ContextNode) -> bool:
    return nodes.any(func(n:ContextNode): return n.node.get_instance_id() == ctx.node.get_instance_id())

## Returns true if succesful
func add(ctx: ContextNode) -> bool:
    var already_added = has(ctx)
    if is_full or not enabled or already_added:
        _log.debug("cannot add: %s" % [{
            "is_full": is_full,
            "enabled": enabled,
            "already_added": already_added
        }])
        return false
    _log.debug("add %s to %s" % [ctx, get_path()])
    # reparent to me
    if not is_ancestor_of(ctx.node):
        if ctx.node.get_parent():
            _log.debug("reparent to me")
            ctx.node.reparent(self)
        else:
            _log.debug("add as child")
            add_child(ctx.node)
    ctx.node.global_position = global_position
    _nodes.append(ctx)
    added.emit(ctx)
    return true

## Detach node from container
func remove(ctx: ContextNode, new_parent: Node2D = null):
    if not has(ctx):
        return
    _log.debug("remove %s" % [ctx])
    if new_parent:
        ctx.node.reparent(new_parent)
    else:
        remove_child(ctx.node)
    _replenish_list.append(ctx)
    _nodes.erase(ctx)

func transfer(to: TransferContainer, config: TransferConfig):
    if nodes.is_empty() or to.is_full or to == self or not enabled:
        _log.debug("no transfer: %s" % {
            "me_empty": nodes.is_empty(),
            "to_is_full": to.is_full,
            "is_me": to == self,
            "enabled": enabled,
            "to": to.get_path(),
        })
        return
    var ctx = nodes.pick_random()
    remove(ctx)
    # create transfer
    _log.debug("transfer %s to %s" % [ctx, to.get_path()])
    _replenish_list.append(ctx)
    var transf = Transfer.create(self, to, config, ctx)
    _transfer_count += 1
    to._transfer_count += 1
    transf.done.connect(_transfer_done.bind(transf))

func _process(delta: float) -> void:
    # create copy if it gets replenished
    if replenish_after > -1 and _replenish_count == 0 and _transfer_count == 0 and not _replenish_list.is_empty():
        _log.debug("replenish after %d sec" % [replenish_after])
        var timer = Timer.new()
        timer.wait_time = replenish_after
        var dupe = _replenish_list.pop_front().duplicate(true)
        timer.timeout.connect(_replenish_timeout.bind(dupe), CONNECT_ONE_SHOT)
        _replenish_count += 1
        timer.autostart = true
        add_child(timer)

func _ready() -> void:
    for child in get_children():
        var ctx = ContextNode.use(child)
        add(ctx)

func _replenish_timeout(ctx: ContextNode):
    _replenish_count -= 1
    add(ctx)

func _transfer_done(transf: Transfer):
    _transfer_count -= 1
    transf.to._transfer_count -= 1
    if not transf.to.add(transf.ctx):
        NodeUtil.remove(transf)
