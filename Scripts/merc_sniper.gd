extends Enemy

@onready var gun = $gun/Gun
@onready var lasersight = $gun/Laser

func die():
	super.die()
	set_collision_layer_value(3,false)
	set_collision_mask_value(1,false)
	gun.visible = false
	lasersight.visible = false

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		super.detectedPlayer(body)
	
