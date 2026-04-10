extends Node2D

@onready var sprite = $Sprite2D

func _process(delta: float) -> void:
	sprite.rotation += 5 * delta

@export var enemy_scene : PackedScene
@export var enemy_scene2 : PackedScene
@export var enemy_scene3 : PackedScene
@export var enemy_scene4 : PackedScene
@export var enemy_scene5 : PackedScene
var rand = 0
var actualsniper = 0
func _on_timer_timeout() -> void: 
	if global.enemies < global.maxenemies:
		if global.Wave == 5:
			rand = 5;
		if global.Wave == 4:
			rand = randi_range(1,4);
			actualsniper = randi_range(1,3)
		if global.Wave == 3:
			rand = randi_range(1,3);
			actualsniper = randi_range(1,2)
		elif global.Wave == 2:
			rand = randi_range(1,2);
		elif global.Wave == 1:
			rand = 2;
		var actualspawn = randi_range(1,100);
		if actualspawn >= 33:
			if rand == 1:
				var enemy = enemy_scene.instantiate()
				enemy.position = position
				enemy.auto_act = true
				enemy.health = 4
				enemy.damage = 3
				enemy.AI_mode = enemy.AImode.Shotgun
				enemy.horizontal_speed = 50
				enemy.show_healthbar = true
				enemy.Death_Anim = enemy.deathmode.falling
				get_parent().add_child(enemy)
			elif rand == 2:
				var enemy = enemy_scene2.instantiate()
				enemy.position = position
				enemy.damage = 7
				enemy.auto_act = true
				enemy.show_healthbar = true
				get_parent().add_child(enemy)
			elif rand == 3 and actualsniper != 2:
				var enemy = enemy_scene3.instantiate()
				enemy.position = position
				enemy.auto_act = true
				enemy.health = 1
				enemy.damage = 3
				enemy.AI_mode = enemy.AImode.Shotgun
				enemy.AI_State = enemy.AIstate.Defensive
				enemy.horizontal_speed = 20
				enemy.show_healthbar = true
				enemy.Death_Anim = enemy.deathmode.falling
				get_parent().add_child(enemy)
			elif rand == 4:
				var enemy = enemy_scene4.instantiate()
				enemy.position = position
				enemy.auto_act = true
				enemy.health = 3
				enemy.damage = 2
				enemy.AI_mode = enemy.AImode.Shotgun
				enemy.AI_State = enemy.AIstate.Offensive
				enemy.horizontal_speed = 40
				enemy.show_healthbar = true
				enemy.Death_Anim = enemy.deathmode.falling
				get_parent().add_child(enemy)
			elif rand == 5:
				var enemy = enemy_scene5.instantiate()
				enemy.position = position
				enemy.auto_act = true
				enemy.health = 4
				enemy.damage = 2
				enemy.horizontal_speed = 50
				enemy.show_healthbar = true
				get_parent().add_child(enemy)
