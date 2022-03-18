tool
extends ResourceFormatLoader
class_name CustomResFormatLoader

# Preload to avoid problems with project.godot
const CustomResClass = preload("res://addons/custom_resource/resource_class.gd")

func get_recognized_extensions() -> PoolStringArray:
	return PoolStringArray(["txt"])


func get_resource_type(path: String) -> String:
	var ext = path.get_extension().to_lower()
	if ext == "txt":
		return "Resource"
	
	return ""


func handles_type(typename: String) -> bool:
	return ClassDB.is_parent_class(typename, "Resource")


func load(path: String, original_path: String):
	var file := File.new()
	
	var err:int
	
	var res := CustomResClass.new()
	
	err = file.open(path, File.READ)
	if err != OK:
		push_error("For some reason, loading custom resource failed with error code: %s"%err)
		return res
	
	res.text = file.get_as_text()
	return res

