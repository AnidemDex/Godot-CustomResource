tool
extends Resource
class_name JSONResource

var _data:Dictionary = {}

func _init() -> void:
	_data = {}


func _get_recursive(property:String, d:Dictionary):
	if property in d:
		return d.get(property)
	
	var p := property.split("/", false, 1)
	for p_idx in p.size():
		d = d.get(p[p_idx], {})
		if p_idx+1 >= p.size():
			break
		return _get_recursive(p[p_idx + 1], d) 


func _set_recursive(property:String, value, d:Dictionary) -> void:
	if property.ends_with("/"):
		return
	
	if not property:
		return
	
	var p_names:Array = property.split("/")
	var p_idx:int = 0
	var d_pointer:Dictionary = d
	while p_idx < p_names.size():
		var p_name:String = p_names[p_idx]
		
		if not d_pointer.has(p_name):
			d_pointer[p_name] = {}
		
		if p_idx == p_names.size() - 1:
			d_pointer[p_name] = value
			break
		
		d_pointer = d_pointer[p_name]
		p_idx += 1


func _get(property: String):
	if not (property in ClassDB.class_get_property_list("Resource")):
		return _get_recursive(property, _data)


func _set(property: String, value) -> bool:
	# Avoid setting built-in properties
	if not (property in ClassDB.class_get_property_list("Resource")):
		_set_recursive(property, value, _data)
		return true
	
	return false


func get_data() -> Dictionary:
	return _data.duplicate(true)


func set_data(value:Dictionary) -> void:
	_data = value
	emit_changed()
	property_list_changed_notify()


func _get_property_list() -> Array:
	var p := []
	p.append({"name":"_data", "type":TYPE_DICTIONARY, "usage":PROPERTY_USAGE_NOEDITOR})
	
	p = _create_property_list(_data, p)
	return p


func _create_property_list(from:Dictionary, _p:Array, prefix:String = "") -> Array:
	for key in from:
		var property := {"name":prefix+str(key), "type":typeof(from[key]), "usage":PROPERTY_USAGE_EDITOR|PROPERTY_USAGE_SCRIPT_VARIABLE}
		
		if typeof(from[key]) == TYPE_DICTIONARY:
			_create_property_list(from[key], _p, key+"/")
		else:
			_p.append(property)
	return _p
