extends Calculus
class_name Variable

## Permet à l'utilisateur d'entrer un nom de variable 
## qui servira de référence pour d'autres calculs.
var name: String = ""


func _init():
	pass # Replace with function body.



func _is_equal(other: Variant) -> bool:
	return (
		super(other)
		and other.name == name
	)
