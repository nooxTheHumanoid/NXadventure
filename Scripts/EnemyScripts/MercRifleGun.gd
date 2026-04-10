extends Node2D

@onready var sprite = $Gun
@onready var muzzle: Marker2D = $Marker2D
@onready var gunrange = $"../DetectionGun"
@onready var detectionrange = $"../Detection"
@onready var firesound = $Fire

@export var currentDMG : float = 0.5
@export var firingCD = 0.3
@export var mag = 10
@export var reloadtime = 4
var canfire = false
var reloading = false
var player = null
var maxammo = mag

const BULLET = preload('res://things/bullet.tscn')
func _ready() -> void:
	get_tree().create_timer(0.01).timeout.connect(sizecheck)
	sprite.play("default")
	

func _process(_delta: float) -> void:
	if player != null:
		look_at(player.global_position)
		rotation_degrees = wrap(rotation_degrees, 0 , 360)
		if rotation_degrees > 90 and rotation_degrees < 270:
			position = Vector2(5,0)
			sprite.flip_v = true
		else:
			position = Vector2(-5,9)
			sprite.flip_h = false
			sprite.flip_v = false
			

func _physics_process(_delta: float) -> void:
	if player != null && player.health >= 0:
		if canfire && mag >= 1 && not reloading:
			mag -= 1
			canfire = false
			if global.SFX_Enabled:
				firesound.play()
			var bullet_instance = BULLET.instantiate()
			get_tree().root.add_child(bullet_instance)
			bullet_instance.global_position = muzzle.global_position
			bullet_instance.rotation = rotation
			bullet_instance.damagVal(currentDMG)
			if mag >= 1:
				get_tree().create_timer(firingCD).timeout.connect(resetfire)
		if mag <= 0 && not reloading:
			reloading = true
			get_tree().create_timer(reloadtime).timeout.connect(reloadingFinish)
			get_tree().create_timer(firingCD).timeout.connect(resetfire)
		
func resetfire():
	if sprite.visible:
		canfire = true
		
func reloadingFinish():
	reloading = false
	mag = maxammo

func _on_detection_gun_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && player == null:
		get_tree().create_timer(firingCD).timeout.connect(resetfire)
		player = body

func sizecheck():
	gunrange.scale.x = detectionrange.scale.x
	gunrange.scale.y = detectionrange.scale.y
