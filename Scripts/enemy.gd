extends Area2D

class_name Enemy

enum deathmode{ #death animations
	stomped,
	falling
}
enum AImode{ 
	Walking, #only walks left and right
	Shotgun # can fire bullets
}
enum AIstate{
	Offensive, #randomly switches between Aggressive and Defensive
	Aggressive, #Always approaches the player
	Defensive #Always runs away from the player
}

@export var horizontal_speed = 30
@export var vertical_speed = 100
@export var damage = 21
@export var health = 1
@export var Death_Anim = deathmode.stomped
@export var AI_mode = AImode.Walking
@export var AI_State = AIstate.Offensive
@export var recoverytime = 1.5
@export var auto_act = false
@export var show_healthbar = false
@onready var ray_cast = $RayCast2D as RayCast2D
@onready var wall_detector = $WallDetect as RayCast2D
@onready var wall_detector2 = $WallDetect2 as RayCast2D
@onready var animations = $AnimatedSprite2D as AnimatedSprite2D
@onready var detector = $Detection as Area2D
@onready var health_bar = $HealthBar

var recovered = true
var dead = false
var playerdetected = null
var rerolltime = randi_range(1, 10)
var reroll = true
var random = 0
var tempspeed = 0

func _ready() -> void:
	health_bar.visible = true
	global.enemies += 1 #Counts the enemy
	if show_healthbar == false:
		health_bar.visible = false
	if playerdetected == null and auto_act == true: #makes the detection circle bigger so it colides with the player
		detector.scale.x = 1000
		detector.scale.y = 1000
	health_bar.init_health(health)

func _process(delta):
	if health >= 0 && playerdetected != null && not dead:
		animations.play("Walk")
		position.x -= delta * horizontal_speed
		
		if (wall_detector.is_colliding() && horizontal_speed > 0) or (wall_detector2.is_colliding() && horizontal_speed < 0):
			horizontal_speed = horizontal_speed * -1
			recovered = false
			get_tree().create_timer(recoverytime).timeout.connect(recover)
			
	if !ray_cast.is_colliding(): #give the gravity
		position.y += delta * vertical_speed
	
	if health >=0 && playerdetected != null && AI_mode != AImode.Walking && not dead:
		if playerdetected.position.x < global_position.x:
			animations.flip_h = true
		else:
			animations.flip_h = false
		
	if health >=0 && playerdetected != null && AI_mode == AImode.Shotgun && recovered && not dead:
		if reroll:
			random = randi_range(1, 2)
			reroll = false
			get_tree().create_timer(rerolltime).timeout.connect(rerolling)
		
		#AI movement states
		if AI_State == AIstate.Aggressive:
			if (playerdetected.position.x < global_position.x && horizontal_speed < 0) or (playerdetected.position.x > global_position.x && horizontal_speed > 0):
				horizontal_speed = horizontal_speed * -1
		elif AI_State == AIstate.Defensive:
			if (playerdetected.position.x < global_position.x && horizontal_speed > 0) or (playerdetected.position.x > global_position.x && horizontal_speed < 0):
				horizontal_speed = horizontal_speed * -1
		elif AI_State == AIstate.Offensive and random == 1:
			rerolltime = randi_range(1, 10)
			if (playerdetected.position.x < global_position.x && horizontal_speed > 0) or (playerdetected.position.x > global_position.x && horizontal_speed < 0):
				horizontal_speed = horizontal_speed * -1
		elif AI_State == AIstate.Offensive and random == 2:
			rerolltime = randi_range(1, 10)
			if (playerdetected.position.x < global_position.x && horizontal_speed < 0) or (playerdetected.position.x > global_position.x && horizontal_speed > 0):
				horizontal_speed = horizontal_speed * -1
			
		
	
	if health <= 0:
		if not dead:
			animations.flip_h = false
			global.kills += 1 
			global.tempkills += 1
			global.enemies -=1
			dead = true
			die()

func hurtEnemy(PlayerDamage):
	if not dead: #This should prevent crashing
		health -= PlayerDamage
		health_bar.set_health(health)

func die():
	if Death_Anim == deathmode.stomped:
		horizontal_speed = 0
		vertical_speed = 0
		animations.play("Death")
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position, .75)
		death_tween.tween_callback(func (): queue_free())
	if Death_Anim == deathmode.falling:
		horizontal_speed = 0
		vertical_speed = 0
		animations.play("Death")
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position + Vector2(0, -48), .5)
		death_tween.chain().tween_property(self,"position", position + Vector2(0,256),1)
		death_tween.tween_callback(func (): queue_free())
	
func detectedPlayer(player):
	playerdetected = player

func recover():
	recovered = true

func rerolling():
	reroll = true
