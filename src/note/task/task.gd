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


## Return true if the name is valid
static func check_name(_name: String) -> ErrorHelper:
	if not _name.is_valid_identifier():
		return ErrorHelper.new().set_title(
			TranslationServer.tr("ERROR_INVALID_IDENTIFIER")
		).set_description(
			TranslationServer.tr("ERROR_INVALID_IDENTIFIER_DESC").format({
				"identifier": _name,
			})
		)
	
	return null


func _is_equal(other: Variant) -> bool:
	return (
		super(other)
		and other.time_limit == title
		and other.done == description
	)
