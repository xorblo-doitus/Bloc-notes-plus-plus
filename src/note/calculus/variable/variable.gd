class_name Variable
extends Calculus


## Permet à l'utilisateur d'entrer un nom de variable 
## qui servira de référence pour d'autres calculs.
var name: String = ""


## Stores a weak reference to all alive variables
static var all: Array[WeakRef] = []


static func get_all_var_for_calculus() -> Dictionary:
	var result: Dictionary = {}
	
	for weak_ref in all:
		var variable: Variable = weak_ref.get_ref()
		result[variable.name] = variable.get_value()
	
	return result


static func _static_init() -> void:
	Calculus.variable_getters.append(Variable.get_all_var_for_calculus)


func _init(_title: String = "", _description: = ""):
	all.append(weakref(self))


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			for i in len(all):
				if all[i].get_ref() == self:
					all.remove_at(i)
					break


func _is_equal(other: Variant) -> bool:
	return (
		super(other)
		and other.name == name
	)


## Prevent stack overflow
var _value_cache: float
func get_value() -> float:
	#_value_cache
	
	var result: float = super()
	
	return result
