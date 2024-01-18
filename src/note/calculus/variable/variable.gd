class_name Variable
extends Calculus


signal name_changed()


## Permet à l'utilisateur d'entrer un nom de variable 
## qui servira de référence pour d'autres calculs.
var name: String = "":
	set(new):
		if new == name:
			return
		
		name = new
		name_changed.emit()


## Stores a weak reference to all alive variables
static var all: Array[WeakRef] = []

static var _dont_include_in_variables: Array[Variable] = []

static func get_all_var_for_calculus() -> Dictionary:
	var result: Dictionary = {}
	
	for weak_ref in all:
		var variable: Variable = weak_ref.get_ref()
		if variable in _dont_include_in_variables:
			continue
		result[variable.name] = variable.get_value()
	
	return result


static func _static_init() -> void:
	Calculus.variable_getters.append(Variable.get_all_var_for_calculus)


func _init(_title: String = "", _description: = ""):
	super(_title, _description)
	
	all.append(weakref(self))


func set_name(_name: String) -> Variable:
	name = _name
	return self


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


func get_value() -> Variant:
	_dont_include_in_variables.push_back(self)
	
	var result: Variant = super()
	
	_dont_include_in_variables.erase(self)
	
	return result
