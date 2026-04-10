extends Button

func _on_pressed() -> void:
	var folder_path = OS.get_executable_path().get_base_dir()
	folder_path = folder_path + "/Custom"
	OS.shell_open(folder_path)
