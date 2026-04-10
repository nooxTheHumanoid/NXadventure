extends TextureButton
@export_file var custom_content_path

func _on_pressed() -> void:
	if custom_content_path == null:
		return
	get_tree().change_scene_to_file(custom_content_path)
