extends Node2D

@onready var sprite = $Gun
@onready var muzzle: Marker2D = $Marker2D
@onready var gunrange = $"../DetectionGun"
@onready var detectionrange = $"../Detection"
@onready var lasersightRay = $lasersightcast
@onready var lasersight = $Laser
@onready var SoundFire = $Fire
@onready var SoundAlert = $"../Alert"
@onready var SoundWarn = $"../Warn"

@export var currentDMG = 7
@export var firingCD = 7
@export var mag = 1
@export var reloadtime = 0.001
var canfire = false
var reloading = false
var player = null
var maxammo = mag
var alreadysaid = false

func _ready() -> void:
	get_tree().create_timer(0.01).timeout.connect(sizecheck)
	sprite.play("default")
	lasersight.visible = false
	alreadysaid = false
	

func _process(_delta: float) -> void:
	if player != null:
		look_at(player.global_position)
		rotation_degrees = wrap(rotation_degrees, 0 , 360)
		if rotation_degrees > 90 and rotation_degrees < 270:
			sprite.scale.y = -1
		else:
			sprite.scale.y = 1
			

func _physics_process(_delta: float) -> void:
	if player != null && player.health >= 0:
		
		if lasersightRay.is_colliding():
			var collisionPoint = lasersightRay.get_collision_point()
			var local_collPoint = to_local(collisionPoint)
			lasersight.points[1] = local_collPoint
		else:
			lasersight.points[1] = Vector2(2000,0)
		
		if canfire && mag >= 1 && not reloading:
			mag -= 1
			if global.SFX_Enabled:
				SoundFire.play()
			canfire = false
			player.gethitdmg = currentDMG
			player.died()
			if mag >= 1:
				get_tree().create_timer(firingCD).timeout.connect(resetfire)
		if mag <= 0 && not reloading:
			reloading = true
			get_tree().create_timer(reloadtime).timeout.connect(reloadingFinish)
			get_tree().create_timer(firingCD).timeout.connect(resetfire)
			
	if player != null && player.health <= 0:
		lasersight.visible = false


func resetfire():
	if sprite.visible:
		canfire = true
		
func reloadingFinish():
	reloading = false
	mag = maxammo
	
func warn():
	if visible == true:
		if global.SFX_Enabled:
			SoundWarn.play()

func _on_detection_gun_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && player == null:
		get_tree().create_timer(firingCD).timeout.connect(resetfire)
		player = body
		lasersight.visible = true
		if alreadysaid == false && visible:
			alreadysaid = true
			if global.SFX_Enabled:
				SoundAlert.play()
			get_tree().create_timer(6).timeout.connect(warn)


func sizecheck():
	gunrange.scale.x = detectionrange.scale.x
	gunrange.scale.y = detectionrange.scale.y
