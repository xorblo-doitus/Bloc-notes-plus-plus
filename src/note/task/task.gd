class_name Task
extends Note


signal done_toggled(new: bool)


## Wether or not the task is done.
## Revertable.
var done: bool = false:
	set(new):
		if new == done:
			return
		
		done = new
		done_toggled.emit(new)


func set_done(new: bool) -> Task:
	done = new
	return self


func _is_equal(other: Variant) -> bool:
	return (
		super(other)
		and other.time_limit == title
		and other.done == description
	)
