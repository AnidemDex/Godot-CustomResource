tool
extends EditorImportPlugin

# No class_name here bud'
# Why? Because this script should be registered by the plugin

# tool because we need to use it in editor

# Here we're going to work with custom importers
# Importers are these tools that helps you to create custom resources
# using a file as base. The main file is not modified, and the resource
# is saved to .import/ folder instead.

# Ideally, this should be the method that you use to manipulate custom
# resources becasue:
# 1. It doesn't modify the original file
# 2. An optimized resource is created and used instead when you point to
#    that file on load()
# 3. Changes made to the original file are re-imported and all things that
#    needs to be regenerated will be notified to do so.
# 4. It doesn't interfere with other's importers. If your plugin works with
#    that special extension and other plugin does that too, you let the user
#    decide how the file should be imported.

# Let's make one for the PlainTextResource

# And sure, don't forget to take a look on official docs:
# https://docs.godotengine.org/en/3.4/tutorials/plugins/editor/import_plugins.html

const PlainTextClass = preload("res://addons/custom_resource/plain_text_resource.gd")

# This is an unique name identifier, is used to tell godot who tf imported
# the file.
func get_importer_name() -> String:
	return "plain.text"


# This is the name displayed in editor when you go to Import tab
func get_visible_name() -> String:
	return "Plain Text"


# Do I really need to explain this one?
func get_recognized_extensions() -> Array:
	return ["txt"]


# Ok, this is a tricky one. 
# This is the extension that Editor will use when save the file to .import/
# folder. Some especial files has special extensions bundled
# (image files can use .stex, materials can use .material and so on).
# There can be many valid extensions for your custom resource, so you need to
# tell the editor what extension will be used in the import.
# A generic one that is valid for all resources is "res", and use "scn" if
# you're importing an scene.
func get_save_extension() -> String:
	return "res"

# TODO
func get_resource_type() -> String:
	return "Resource"


# This is supposed to be defined at the start of the script
# But in favour of this guide, is defined here.

# Plain text doesn't need special importation options tbh, but
# we will make some just in name of science.
enum Presets { DEFAULT, EMPTY_FILE }

# Import options are the options defined in the Import tab given a selected
# preset.
# This function MUST BE implemented, because it'll be called by editor even
# if you don't have import options defined.
func get_import_options(preset: int) -> Array:
	# Options are basically an array of dictionaries, where each
	# dictionary defines a name and a default_value at least.
	# You can also define:
	#   - property_hint (from PropertyHint constants)
	#   - hint_string
	#   - usage (from PropertyUsageFlags constants
	# See _get_property_list() documentation for more information
	var options:Array = []
	var option_strip = {"name":"ignore_file_content", "default_value": false}
	var option_cat = {"name":"show_a_cat_instead", "default_value":false}
	
	options.append(option_strip)
	options.append(option_cat)
	
	match preset:
		Presets.DEFAULT:
			option_strip["default_value"] = false
			option_cat["default_value"] = false
		
		Presets.EMPTY_FILE:
			option_strip["default_value"] = true
		
	return options


func get_preset_count() -> int:
	return Presets.size()


func get_preset_name(preset: int) -> String:
	match preset:
		Presets.DEFAULT:
			return "Default"
		Presets.EMPTY_FILE:
			return "Empty File"
		_:
			return "Unknow"

# This is useful when you want to hide a certain option given a set of options.
func get_option_visibility(option: String, options: Dictionary) -> bool:
	if option == "show_a_cat_instead":
		# Hides "show_a_cat_instead" if "ignore_file_content" is false
		return options.get("ignore_file_content", false)
	
	return true


# This is where magic happens.
# Read the file, parse it and save the imported resource in save_path.
# Notice that save_path is passed without the extension.
func import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array, gen_files: Array) -> int:
	var file := File.new()
	
	var err:int
	
	err = file.open(source_file, File.READ)
	if err != OK:
		push_error("For some reason, loading custom resource failed with error code: %s"%err)
		# You has to return the error constant
		return err
	
	var text:String = file.get_as_text()
	var filename:String = "{filename}.{extension}".format({"filename":save_path, "extension":get_save_extension()})
	
	text = file.get_as_text()
	file.close()
	
	prints(options, text)
	if options["ignore_file_content"]:
		text = ""
	
	if options.get("show_a_cat_instead", false) == true:
		text = "ฅ^•ﻌ•^ฅ"
	
	var res := PlainTextClass.new()
	res.set("test", text)
	
	return ResourceSaver.save(filename, res)
