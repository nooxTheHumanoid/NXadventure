extends Button
@export_file var path

func _on_pressed() -> void:
	if path == null:
		return
	get_tree().change_scene_to_file(path)
