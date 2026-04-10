extends Node2D

@onready var detector = $Area2D/Detector

var damagetoenemy: int = 1
var bulletlifetime: int = 5
const SPEED: int = 300

func _ready():
	get_tree().create_timer(bulletlifetime).timeout.connect(bulletgone)

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
	if detector.is_colliding():
		bulletgone()
	

func damagVal(dmg):
	damagetoenemy = dmg
	
func bulletgone():
	queue_free()

func handle_enemy_collision(enemy: Enemy):
	if enemy == null:
		return
	
	if enemy.health >= 0:
		enemy.hurtEnemy(damagetoenemy)
		
func handle_enemy_collision2(enemy: EnemyMafia):
	if enemy == null:
		return
	
	if enemy.health >= 0:
		enemy.hurtEnemy(damagetoenemy)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Enemy:
		handle_enemy_collision(area)
	if area is EnemyMafia:
		handle_enemy_collision2(area)
