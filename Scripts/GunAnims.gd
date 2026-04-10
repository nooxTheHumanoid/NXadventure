extends AnimatedSprite2D

class_name ShottyAnimator

func _ready() -> void:
	play("default")

func fireshotty():
	play("Fire")
