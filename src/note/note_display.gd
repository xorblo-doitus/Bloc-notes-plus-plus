extends Panel


signal title_changed(new: String, old: String)


## Texte principal de la note et celui qui est affiché dans la liste de note.
var title: String = "":
	set(new):
		title = new
		%Title.text = new
		print("setter called")

## Texte descriptif plus étoffé que le titre.
var description: String = "":
	set(new):
		description = new


func _on_title_text_changed(new, _old):
	# We use the old text of this NoteDisplay just in case it was changed while edited by user.
	var old: String = title
	title = new
	title_changed.emit(new, old)


