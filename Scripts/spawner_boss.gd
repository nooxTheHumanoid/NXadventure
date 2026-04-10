extends Node2D

@onready var sprite = $Sprite2D

func _process(delta: float) -> void:
	sprite.rotation += 10 * delta

@export var enemy_scene : PackedScene
var bossspawned = false
func _on_timer_timeout() -> void: 
	if global.enemies < global.maxenemies && not bossspawned:
		if global.Wave == 5:
			bossspawned = true
			var enemy = enemy_scene.instantiate()
			enemy.position = position
			enemy.auto_act = true
			enemy.health = 70
			enemy.damage = 2
			enemy.horizontal_speed = 70
			enemy.show_healthbar = true
			get_parent().add_child(enemy)
			
