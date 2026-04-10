extends Enemy



func die():
	super.die()
	set_collision_layer_value(3,false)
	set_collision_mask_value(1,false)

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		super.detectedPlayer(true)
