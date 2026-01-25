class Await:
    signal all_done
    signal signal_done
    var count = 0
    
    func _signal_done():
        count -= 1
        if count <= 0:
            all_done.emit()
    
    func use(sig: Signal):
        count += 1
        sig.connect(_signal_done)
        
    static func all(signals: Array[Signal]):
        var a = Await.new()
        for sig in signals:
            a.use(sig)
        if a.count > 0:
            await a.all_done
            
