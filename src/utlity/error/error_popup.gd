#class_name ErrorPopup
extends AcceptDialog


func _init() -> void:
	hide()


func _ready() -> void:
	if get_tree().root.always_on_top:
		always_on_top = true
		move_to_foreground()


func set_title_elements(elements: Array[String] = []) -> void:
	# Add the software title so the user know that the error come from us.
	elements.push_front(
		EasySettings.get_setting("application/config/name_localized").get(
			OS.get_locale_language(),
			EasySettings.get_setting("application/config/name")
		)
	)
	
	title = " - ".join(elements)
