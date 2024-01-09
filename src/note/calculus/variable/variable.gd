class_name Variable
extends Calculus


## Permet à l'utilisateur d'entrer un nom de variable 
## qui servira de référence pour d'autres calculs.
var name: String = ""


## Stores a reference to all alive variables
static var all: Array[Variable] = []


static func get_all_var_for_calculus() -> Dictionary:
	var result: Dictionary = {}
	
	for variable in all:
		result[variable.name] = variable.get_value()
	
	return result


static func _static_init() -> void:
	Calculus.variable_getters.append(Variable.get_all_var_for_calculus)


func _init(_title: String = "", _description: = ""):
	all.append(self)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			all.erase(self)


func _is_equal(other: Variant) -> bool:
	return (
		super(other)
		and other.name == name
	)
