class_name Connection
extends RefCounted


## The signal to wich the callback is connected
var connected_to: Signal
## The callable that is called by the signal emission.
var callback: Callable
@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
var flags: ConnectFlags = 0


@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
func _init(_connected_to: Signal, _callback: Callable, auto_connect: bool = false, _flags: ConnectFlags = 0) -> void:
	connected_to = _connected_to
	callback = _callback
	
	if auto_connect:
		create()


## Create the signal connection
func create() -> void:
	connected_to.connect(callback, flags)


## Remove the signal connection
func destroy() -> void:
	connected_to.disconnect(callback)


static func destroy_all(connections: Array[Connection]) -> void:
	while connections:
		connections.pop_back().destroy()
