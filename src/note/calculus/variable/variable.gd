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
static var all_variables: Array[WeakRef] = []

static var _dont_include_in_variables: Array[Variable] = []

static func get_all_var_for_calculus() -> Dictionary:
	var result: Dictionary = {}
	
	for weak_ref in Variable.all_variables:
		var variable: Variable = weak_ref.get_ref()
		if variable in _dont_include_in_variables:
			continue
		result[variable.name] = variable.get_value()
	
	return result


static func _static_init() -> void:
	Calculus.variable_getters.append(Variable.get_all_var_for_calculus)


func _init(_title: String = "", _description: = "") -> void:
	Variable.all_variables.append(weakref(self))
	name_changed.connect(update_all_values)
	value_changed.connect(update_all_values.unbind(2))
	super(_title, _description)
	
	


func set_name(_name: String) -> Variable:
	name = _name
	return self


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			for i in len(Variable.all_variables):
				if Variable.all_variables[i].get_ref() == self:
					Variable.all_variables.remove_at(i)
					Variable.update_all_values.call_deferred()
					break


func _is_equal(other: Variant) -> bool:
	return (
		super(other)
		and other.name == name
	)


## @deprecated See [method Calculus.get_value]
func get_value() -> Variant:
	return value


func calculate(string_expression: String = title) -> Variant:
	_dont_include_in_variables.push_back(self)
	
	var result: Variant = super(string_expression)
	
	_dont_include_in_variables.erase(self)
	
	return result


static var _updating_values: bool = false
static var _re_update_values: bool = false
static func update_all_values() -> void:
	if Variable._updating_values:
		Variable._re_update_values = true
		return
		
	Variable._re_update_values = true
	
	while Variable._re_update_values:
		Variable._re_update_values = false
		for calculus_ref in Calculus.all:
			calculus_ref.get_ref().update_value()
	
	Variable._updating_values = false
