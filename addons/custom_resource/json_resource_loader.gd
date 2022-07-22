tool
extends ResourceFormatLoader
class_name JSONResourceLoader

const _JSONResource = preload("res://addons/custom_resource/json_resource.gd")

func get_recognized_extensions() -> PoolStringArray:
	return PoolStringArray(["json"])


func get_resource_type(path: String) -> String:
	var ext = path.get_extension().to_lower()
	if ext == "json":
		return "Resource"
	
	return ""


func handles_type(typename: String) -> bool:
	# I'll give you a hand for custom resources... use this snipet and that's it ;)
	return ClassDB.is_parent_class(typename, "Resource")


func load(path: String, original_path: String):
	var file := File.new()
	
	var err:int
	
	err = file.open(path, File.READ)
	if err != OK:
		push_error("For some reason, loading JSON resource failed with error code: %s"%err)
		return err
	
	var json_data := JSON.parse(file.get_as_text())
	
	if json_data.error:
		push_error("Failed parsing JSON file: [%s at line %s]" % [json_data.error_string, json_data.error_line])
		return json_data.error
	
	var res := _JSONResource.new()
	res.set_data(json_data.result)
	
	file.close()
	# Everything went well, and you parsed your file data into your resource. Life is good, return it
	return res
