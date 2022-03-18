tool
extends ResourceFormatSaver
class_name CustomResFormatSaver

# Preload to avoid problems with project.godot
const CustomResClass = preload("res://addons/custom_resource/resource_class.gd")

func get_recognized_extensions(resource: Resource) -> PoolStringArray:
	return PoolStringArray(["txt"])


func recognize(resource: Resource) -> bool:
	# Cast instead of using "is" keyword in case is a subclass
	resource = resource as CustomResClass
	
	if resource:
		return true
	
	return false


func save(path: String, resource: Resource, flags: int) -> int:
	var err:int
	var file:File = File.new()
	err = file.open(path, File.WRITE)
	
	if err != OK:
		printerr('Can\'t write file: "%s"! code: %d.' % [path, err])
		return err
	
	file.store_string(resource.get("text"))
	file.close()
	return OK
