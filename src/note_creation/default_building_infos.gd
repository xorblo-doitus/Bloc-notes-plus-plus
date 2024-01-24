class_name DefaultBuildingInfos
extends Object


static func _static_init():
	create_defaults()


static func create_defaults():
	BuildingInfo.new(Note).auto_setup_from_JSONablization_info().build()
	BuildingInfo.new(Variable).auto_setup_from_JSONablization_info().build()
