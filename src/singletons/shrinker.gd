extends Node
#class_name Skrinker


func _ready() -> void:
	for control: Control in get_tree().get_nodes_in_group(&"shrink"):
		bind(control)
		
	get_tree().node_added.connect(_on_node_added)
	get_tree().node_removed.connect(_on_node_removed)


func _on_node_added(node: Node) -> void:
	if node.is_in_group(&"shrink"):
		if node is Control:
			bind(node)
		else:
			assert(false, "A non-Control node is in `shrink` group.")


func _on_node_removed(node: Node) -> void:
	if node.is_in_group(&"shrink"):
		if node is Control:
			unbind(node)
		else:
			assert(false, "A non-Control node is in `shrink` group.")


func bind(control: Control) -> void:
	control.resized.connect(shrink.bind(control))


func unbind(control: Control) -> void:
	# Works even if it's not really the same callable due to binding.
	control.resized.disconnect(shrink)


func shrink(control: Control) -> void:
	control.size = Vector2.ZERO
