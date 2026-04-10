extends CharacterBody2D

class_name Player

enum PlayerMode {
	regular,
	nohands
}

var SPEED = 100.0
const JUMP_VELOCITY = -400.0
var ExtraSpeed = 1
var is_dead = false

@onready var char_area: Area2D = $Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shotty: Node2D = $Shotty
@onready var sound: AudioStreamPlayer2D = $Taunt
@onready var health_bar = $HealthBar
@onready var defence_bar = $DefenceBar
@onready var HPNumb = $HPNumber
@onready var tauntSong = $Taunt
@onready var levelmusic = $LevelMusic

@export var Coyote_Time: float = 0.3 #I want em to feel floaty when you use em. Maybe over exaturate the coyote time?

@export_file var Current_scene
@export var LevelSong : AudioStreamMP3
@export_group("Debug mode")
@export var able_to_switch_mode: bool = false
@export_group("")

@export_group("Player things")
@export var Player_Mode = PlayerMode.regular
@export var Show_Health = true
@export var Show_defence = true
@export var Gain_defense = true
@export_group("")

@export_group("Stomping Enemies")
@export var min_stomp_deg = 35
@export var max_stomp_deg = 145
@export var stomp_y_vel = -150
@export var random_stomp_x_vel = 1200
@export_group("")

@export_group("Camera Sync")
@export var camera_sync: Camera2D
@export var should_camera_sync: bool = true
@export_group("")

@export_group("Vitals")
@export var MaxHealth = 21
@export var health = 21
@export var defence = 0.0
@export var CanHeal_viaTaunt = false
@export var HealthFromTaunting = 0.01
@export var HealWaitFromTaunt = 0.5
@export_group("")

@export_group("Damage")
@export var Stomp_DMG = 5.0
@export var bullet_DMG = 1.0
@export_group("")

var IwantDuckOrTaunt = "none"
var taunting: bool = false
var Jump_Availabe: bool = true #Coyote time (Good for platformers)
var gethitdmg : float = 0.0
var healCD = false
var pausemovement = false

func _ready():
	global.enemies = 0
	global.tempkills = defence/5
	levelmusic.stream = LevelSong
	if global.Music_Enabled:
		levelmusic.playing = true
	pausemovement = false
	if Show_Health:
		health_bar.visible = true
	else:
		health_bar.visible = false
	if Show_defence:
		defence_bar.visible = true
	else:
		defence_bar.visible = false
	if health >= MaxHealth:
		MaxHealth = health
	if Current_scene == null:
		Current_scene = get_parent().get_scene_file_path()
	health_bar.init_health(MaxHealth)

func _process(_delta):
	if Gain_defense:
		defence = global.tempkills*5
	if defence >= 101:
		defence = 100
		
	if health >= MaxHealth:
		health = MaxHealth
		
	if health >= 0 && not is_dead:
		if global_position.x > camera_sync.global_position.x && should_camera_sync == true:
			camera_sync.global_position.x = global_position.x
		if global_position.x < camera_sync.global_position.x && should_camera_sync == true:
			camera_sync.global_position.x = global_position.x
		if global_position.y > camera_sync.global_position.y && should_camera_sync == true:
			camera_sync.global_position.y = global_position.y
		if global_position.y < camera_sync.global_position.y && should_camera_sync == true:
			camera_sync.global_position.y = global_position.y
	
	if get_global_mouse_position().x < global_position.x && Player_Mode == PlayerMode.nohands and taunting == false:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	if IwantDuckOrTaunt == "taunt":
		if CanHeal_viaTaunt == true && healCD == false:
			healCD = true
			get_tree().create_timer(HealWaitFromTaunt).timeout.connect(healplayer)
		
		


func _physics_process(delta: float) -> void:
		
	
	if not is_on_floor():
		if Jump_Availabe:
			get_tree().create_timer(Coyote_Time).timeout.connect(Coyote_Timeout)
		
		velocity += get_gravity() * delta
	else:	
		Jump_Availabe = true

	
	if Input.is_action_pressed("jump") and Jump_Availabe and taunting == false:
		velocity.y = JUMP_VELOCITY
		Jump_Availabe = false

	var direction := Input.get_axis("left", "right")
	if Input.is_action_pressed("sprint"):
		ExtraSpeed = 2.0
	else:
		ExtraSpeed = 1.0
	
	if Input.is_action_just_pressed("change action"):
		if able_to_switch_mode == true:
			if Player_Mode == PlayerMode.regular:
				Player_Mode = PlayerMode.nohands
			else:
				Player_Mode = PlayerMode.regular	
	
	
	if Input.is_action_pressed("down") and is_on_floor() and taunting == false:
		IwantDuckOrTaunt = "duck"
		ExtraSpeed = 0
	elif Input.is_action_just_pressed("taunt") and is_on_floor() and taunting == false:
		IwantDuckOrTaunt= "taunt"
		taunting = true
	elif taunting == false:
		IwantDuckOrTaunt = "none"
	elif Input.is_action_just_pressed("taunt") and is_on_floor() and taunting == true:
		IwantDuckOrTaunt = "none"
		taunting = false
		
	
	if direction && IwantDuckOrTaunt == "none" && pausemovement == false:
		velocity.x = direction * SPEED * ExtraSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if IwantDuckOrTaunt != "taunt":
		if levelmusic.stream_paused == true:
			if global.Music_Enabled:
				tauntSong.playing = false
				levelmusic.stream_paused = false
	else:
		if tauntSong.playing == false:
			if global.Music_Enabled:
				tauntSong.playing = true
				levelmusic.stream_paused = true
	
	sprite.char_state(IwantDuckOrTaunt)
	sprite.trigger_animation(velocity,direction,Player_Mode)
	shotty.modenotifforguns(Player_Mode)
	shotty.state_char_anim(IwantDuckOrTaunt)
	shotty.dmgnumber(bullet_DMG)
	move_and_slide()


func Coyote_Timeout():
	Jump_Availabe = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Enemy:
		handle_enemy_collision(area)
	if area is EnemyMafia:
		handle_enemy_collision2(area)
		
func handle_enemy_collision(enemy: Enemy):
	if enemy == null && is_dead == false:
		return
	
	var angle_of_collison = rad_to_deg(position.angle_to_point(enemy.position))
	
	if angle_of_collison > min_stomp_deg && max_stomp_deg > angle_of_collison:
		enemy.hurtEnemy(Stomp_DMG)
		enemy_stomped()
	else:
		gethitdmg = enemy.damage
		died()
		
func handle_enemy_collision2(enemy: EnemyMafia):
	if enemy == null && is_dead == false:
		return
	
	var angle_of_collison = rad_to_deg(position.angle_to_point(enemy.position))
	
	if angle_of_collison > min_stomp_deg && max_stomp_deg > angle_of_collison:
		enemy.hurtEnemy(Stomp_DMG/2) #because mafia is stronger in this game
		enemy_stomped()
	else:
		gethitdmg = enemy.damage
		died()
		
func enemy_stomped():
	velocity.y = stomp_y_vel
	if Player_Mode == PlayerMode.nohands:
		pausemovement = true
		velocity.x = randi_range(-random_stomp_x_vel,random_stomp_x_vel)
		get_tree().create_timer(0.05).timeout.connect(unpause)

func unpause():
	pausemovement = false

func healplayer():
	healCD = false
	if IwantDuckOrTaunt == "taunt" && not is_dead:
		health += HealthFromTaunting
		health_bar.set_health(health)

func died():
	health -= gethitdmg-(gethitdmg*(defence*0.01))
	global.tempkills = 0
	health_bar.set_health(health) 
	if health <= 0:
		is_dead = true
		defence_bar.queue_free()
		sprite.play("Death")
		char_area.set_collision_layer_value(1,false)
		char_area.set_collision_mask_value(3,false)
		set_collision_layer_value(1,false)
		set_collision_mask_value(3,false)
		set_physics_process(false)
		
		Player_Mode = PlayerMode.regular
		shotty.modenotifforguns(Player_Mode)
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position + Vector2(0, -48), .5)
		death_tween.chain().tween_property(self,"position", position + Vector2(0,256),1)
		death_tween.tween_callback(func (): get_tree().change_scene_to_file(Current_scene))
