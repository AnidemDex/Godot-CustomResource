tool
extends Resource
class_name CustomRes

export(String, MULTILINE) var text = "" setget set_text

func set_text(value:String) -> void:
	text = value
	emit_changed()
