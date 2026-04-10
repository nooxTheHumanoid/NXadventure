extends EnemyMafia

@onready var gun = $gun/Gun

func die():
	super.die() #references EnemyMafia
	set_collision_layer_value(3,false)
	set_collision_mask_value(1,false)
	gun.visible = false

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		super.detectedPlayer(body)
	

func _on_mafia_spawn_time_timeout() -> void:
	super.Summoning()
