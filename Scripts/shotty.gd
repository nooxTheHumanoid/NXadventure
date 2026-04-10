extends Node2D

const BULLET = preload('res://things/Slug.tscn')

@onready var muzzle: Marker2D = $Marker2D
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var firesound = $Fire

var canfire = false
var State = "none"
var firecd: float = 0.5
var actualfire = false
var currentDMG = 0

func dmgnumber(dmg):
	currentDMG = dmg

func state_char_anim(StateAnim: String):
	State = StateAnim

func modenotifforguns(player_guns: Player.PlayerMode):
	if player_guns == Player.PlayerMode.nohands && State == "none":
		visible = true
		position.y = 8.0
	elif player_guns == Player.PlayerMode.nohands && State == "duck":
		visible = true
		position.y = 11.0
	elif player_guns == Player.PlayerMode.nohands && State == "taunt":
		visible = false
		canfire = false
		position.y = 8.0
	else:
		visible = false
		canfire = false
		position.y = 8.0

func FiredcooldownOff():
	canfire = true
	actualfire=false

func _physics_process(_delta: float) -> void:
	if actualfire == false && visible == true:
		canfire = true
	
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0 , 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
		position.x = 0.25
	else:
		scale.y = 1
		position.x = 0.0
	
	
	if Input.is_action_just_pressed("shoot") and canfire and visible == true:
		canfire = false
		actualfire = true
		if global.SFX_Enabled:
			firesound.play()
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation
		bullet_instance.damagVal(currentDMG)
		animator.fireshotty()
		get_tree().create_timer(firecd).timeout.connect(FiredcooldownOff)
