extends Node2D

@onready var bullet_area: Area2D = $Area2D
@onready var detector = $Area2D/Detector

var damagetoenemy: float = 1
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

func handle_enemy_collision(player: Player):
	if player == null:
		return
	
	if player.health >= 0:
		player.gethitdmg = damagetoenemy
		player.died()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		handle_enemy_collision(body)
		
