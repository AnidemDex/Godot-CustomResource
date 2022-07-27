tool
extends EditorPlugin

# Q: Why is this file empty Dex?
# A: I'm not being paying enough to fill this script

# jk, is not necessary

# 22/07/26 update: Now is necessary

const PlainTextClass = preload("res://addons/custom_resource/plain_text_resource.gd")
const PlainTextClassImporter = preload("res://addons/custom_resource/plain_text_resource_importer.gd")

var plain_text_importer:PlainTextClassImporter = PlainTextClassImporter.new()

func _enter_tree() -> void:
	add_import_plugin(plain_text_importer)


func _exit_tree() -> void:
	remove_import_plugin(plain_text_importer)
