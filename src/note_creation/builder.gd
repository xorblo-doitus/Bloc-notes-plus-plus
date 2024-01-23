class_name Builder
extends RefCounted


## Un object s'interfaçant entre les entrées utilisateur et les notes.
##
## Permet de créer une [Note] au fur et à mesure, attribut par attribut,
## tout en laissant la possibilité de changer le type final de la [Note].



signal attribute_changed(attribute: String, new_value: Variant)

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


func set_attribute(attribute: String, new_value: Variant) -> void:
	if attributes[attribute] == new_value:
		return
	
	attributes[attribute] = new_value
	attribute_changed.emit(attribute, new_value)


func build() -> Object:
	var infos: BuildingInfo = BuildingInfo.get_most_precise(type)
	var new: Object = infos.instantiating_function.call()
	
	apply_to_existing(new)
	
	return new


func edit_object(object: Object, use_object_current_config: bool = true) -> void:
	type = object.get_script()
	
	if use_object_current_config:
		var infos: BuildingInfo = BuildingInfo.get_most_precise(type)
		
		attributes.clear()
		attributes.merge(object.get_meta(&"_builder_unused_attributes", {}))
		
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
