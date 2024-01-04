class_name Connection
extends RefCounted


## The signal to wich the callback is connected
var connected_to: Signal
## The callable that is called by the signal emission.
var callback: Callable


func _init(_connected_to: Signal, _callback: Callable, auto_connect: bool = false) -> void:
	connected_to = _connected_to
	callback = _callback
	
	if auto_connect:
		create()


## Create the signal connection
func create() -> void:
	connected_to.connect(callback)


## Remove the signal connection
func destroy() -> void:
	connected_to.disconnect(callback)
