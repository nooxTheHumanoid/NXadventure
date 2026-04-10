extends Sprite2D

@export_file var levelEnd

@onready var sprite = $"."

func _process(delta: float) -> void:
	sprite.rotation += 5 * delta

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		call_deferred("change_level")

func change_level():
	get_tree().change_scene_to_file(levelEnd)
