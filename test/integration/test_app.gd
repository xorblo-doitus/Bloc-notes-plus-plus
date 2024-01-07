extends GutTest



func test_main_scene() -> void:
	var main_scene = preload("res://src/app/main.tscn").instantiate()
	get_tree().root.add_child(main_scene)
	await Wait.process_frames(5)
	pass_test("OK")
	main_scene.free()
