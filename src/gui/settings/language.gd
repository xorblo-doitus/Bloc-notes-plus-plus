extends OptionButton


const ID_TO_LOCALE = {
	0: "fr",
	1: "en",
}


func _on_item_selected(index: int) -> void:
	var locale: String = ID_TO_LOCALE.get(index, "fr")
	EasySettings.set_setting("internationalization/locale/current_locale", locale, false)
	TranslationServer.set_locale(locale)


func _on_visibility_changed() -> void:
	if visible:
		select(ID_TO_LOCALE.find_key(EasySettings.get_setting("internationalization/locale/current_locale")))
