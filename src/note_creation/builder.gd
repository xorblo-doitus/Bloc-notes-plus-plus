class_name Builder
extends RefCounted


## Un object s'interfaçant entre les entrées utilisateur et les notes.
##
## Permet de créer une [Note] au fur et à mesure, attribut par attribut,
## tout en laissant la possibilité de changer le type final de la [Note].



signal attribute_changed(attribute: String, new_value: Variant)


class NO_VALUE_FOR_ATTRIBUTE: pass


### Texte principal de la [Note] et celui qui est affiché dans la liste de note
#var title: String = ""
### Texte descriptif plus étoffé que le titre
#var description: String = ""
### Des données, comme un texte ou un nombre...utiles pour la note
### [br] key: [String] value: [Variant]
#var other_data: Dictionary = {}


## The type of object to be created.
var type: Object = Note
## The attributes values of the future new object.
## Please do not edit this dictionary directly, but instead use
## [method set_attribute] to trigger [signal attribute_changed]
var attributes: Dictionary = {}


func _init(object: Object = null) -> void:
	if object != null:
		edit_object(object)


func set_attribute(attribute: String, new_value: Variant) -> void:
	var already_existing = attributes.get(attribute, NO_VALUE_FOR_ATTRIBUTE)
	if typeof(already_existing) == typeof(new_value) and already_existing == new_value:
		return
	
	attributes[attribute] = new_value
	attribute_changed.emit(attribute, new_value)


func build() -> Object:
	var infos: BuildingInfo = BuildingInfo.get_most_precise(type)
	var new: Object = infos.instantiating_function.call() if infos.type == type else type.new()
	
	apply_to_existing(new)
	
	return new


func edit_object(object: Object, use_object_current_config: bool = true) -> void:
	type = object.get_script()
	
	if use_object_current_config:
		var best_infos: BuildingInfo = BuildingInfo.get_most_precise(type)
		
		attributes.clear()
		attributes.merge(object.get_meta(&"_builder_unused_attributes", {}))
		
		for infos in best_infos.get_consecutive_infos():
			for attribute in infos.attributes_to_edit:
				attributes[attribute] = object.get(attribute)


func apply_to_existing(object: Object) -> void:
	var unused_attributes: Dictionary = {}
	
	for attribute in attributes:
		if attribute in object:
			object.set(attribute, attributes[attribute])
		else:
			unused_attributes[attribute] = attributes[attribute]
	
	object.set_meta(&"_builder_unused_attributes", unused_attributes)
