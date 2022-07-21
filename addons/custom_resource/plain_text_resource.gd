tool
extends Resource
class_name PlainTextResource

# This is our resource, I'll expose the text property
# That property is just an string, we don't need anything special here.

export(String, MULTILINE) var text = "" setget set_text

# Q: Wait, I need a setter?
# A: Yes, you MUST tell the editor that you changed the resource somehow
#    If you forgot to do it, the resource will not be saved. Godot things.
func set_text(value:String) -> void:
	text = value
	emit_changed()
