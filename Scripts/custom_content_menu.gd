extends Node2D

const CONTENT_BUTTON = preload("res://things/CustomButton.tscn")

@onready var grid = $Control/GridContainer

func _ready() -> void:
	var folder_path = OS.get_executable_path().get_base_dir()
	folder_path = folder_path + "/Custom"
	print(folder_path)
	get_content(folder_path)

func get_content(path) -> void:
	var dir = DirAccess.open(path) #access files
	if dir:
		dir.list_dir_begin() #starts the list
		var file_name = dir.get_next()
		while file_name != "": #find everything that is in the map
			if file_name.ends_with(".remap"): 
				file_name = file_name.replace(".remap", "") #removes .remap because sometimes godot adds .remap
			print("Found file: " + file_name)
			create_button('%s/%s' % [dir.get_current_dir(), file_name],file_name) #creates a button of the custom thing
			file_name = dir.get_next()
		dir.list_dir_end() #ends the list
	else:
		print("An error occurred when trying to access the path.")
		
func create_button(content_path: String, content_name: String) -> void:
	var btn = CONTENT_BUTTON.instantiate()
	btn.text = content_name
	btn.custom_content_path = content_path
	grid.add_child(btn)
