extends Area2D

class_name EnemyMafia

enum AIstate{
	Offensive, #randomly switches between Aggressive and Defensive
	Aggressive, #Always approaches the player
	Defensive #Always runs away from the player
}

@export var horizontal_speed = 30
@export var vertical_speed = 100
@export var damage = 2
@export var health = 4
@export var AI_State = AIstate.Offensive
@export var recoverytime = 1.5
@export var auto_act = false
@export var show_healthbar = true
@export var boss = false
@export var summoner = false
@export var dodgetime = 1.5
@export_group("Goons")
@export var goons : PackedScene # the guys that get summoned
@export var spawntime = 15.0
@export var goon_count = 2 # how many to spawn at once
@export var goonHP = 4
@export var goonBashDMG = 2
@export var goon_speed = 30
@export var goon_Auto_act = true
@export var goon_show_HP = true
@export_group("")
@export_group("Level Change")
@export var Change_level = false
@export_file var Level
@export var HPRequirement = 35.0
@export_group("")

@onready var ray_cast = $RayCast2D as RayCast2D
@onready var wall_detector = $WallDetect as RayCast2D
@onready var wall_detector2 = $WallDetect2 as RayCast2D
@onready var animations = $AnimatedSprite2D as AnimatedSprite2D
@onready var detector = $Detection as Area2D
@onready var health_bar = $HealthBar
@onready var hat = $Hat
@onready var hair = $Hair
@onready var misc = $Misc

var recovered = true
var dead = false
var playerdetected = null
var rerolltime = randi_range(1, 10)
var reroll = true
var random = 0
var tempspeed = 0
var dodging = false

func _ready() -> void:
	health_bar.visible = true
	global.enemies += 1
	if show_healthbar == false:
		health_bar.visible = false
	if playerdetected == null and auto_act == true: #makes the detection circle bigger so it colides with the player
		detector.scale.x = 1000
		detector.scale.y = 1000
	health_bar.init_health(health)
	if boss == false:
		cosmeticRandom()

func _process(delta):
	if boss: #checks if the enemy is a boss
		hair.visible = false
		hat.visible = false
		misc.visible = false
			
	if Change_level && health <= HPRequirement:
		ChangeLevel()
	
	if health >= 0 && playerdetected != null && not dead:
		animations.play("Walk")
		position.x -= delta * horizontal_speed
		
		if (wall_detector.is_colliding() && horizontal_speed > 0) or (wall_detector2.is_colliding() && horizontal_speed < 0):
			horizontal_speed = horizontal_speed * -1
			recovered = false
			get_tree().create_timer(recoverytime).timeout.connect(recover)
			
	if !ray_cast.is_colliding():
		position.y += delta * vertical_speed
		
	
	if health >=0 && playerdetected != null && not dead:
		if playerdetected.position.x < global_position.x:
			animations.flip_h = true
			hair.flip_h = true
			hat.flip_h = true
			misc.flip_h = true
		else:
			animations.flip_h = false
			hair.flip_h = false
			hat.flip_h = false
			misc.flip_h = false
		
	if health >=0 && playerdetected != null && recovered && dodging == false && not dead:
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
		hair.visible = false
		hat.visible = false
		misc.visible = false
		
		horizontal_speed = 0
		vertical_speed = 0
		animations.play("Death")
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position, 2)
		death_tween.tween_callback(func (): queue_free())
	
func detectedPlayer(player):
	playerdetected = player

func recover():
	recovered = true

func rerolling():
	reroll = true
	
func stopdodge():
	dodging = false

func cosmeticRandom():
	#the thing that randomizes the cosmetics
	var hatstyle = randi_range(1,3)
	var hairstyle = randi_range(1,4)
	var miscitems = randi_range(1,3)
	
	if hatstyle == 1:
		hat.visible = false
	if hatstyle == 2:
		hat.visible = true
		hat.play("cap")
	if hatstyle == 3:
		hat.visible = true
		hat.play("fedora")
	
	if hairstyle == 1:
		hair.visible = false
	if hairstyle == 2:
		hair.visible = true
		hair.play("old")
	if hairstyle == 3:
		hair.visible = true
		hair.play("Ginger")
	if hairstyle == 4:
		hair.visible = true
		hair.play("regular")
		
	if miscitems == 1:
		misc.visible = false
	if miscitems == 2:
		misc.visible = true
		misc.play("Headphones")
	if miscitems == 3:
		misc.visible = true
		misc.play("sunglasses")

func Summoning():
	if summoner && not dead:
		for x in goon_count:
			var enemy = goons.instantiate()
			enemy.position = position
			enemy.auto_act = goon_Auto_act
			enemy.health = goonHP
			enemy.damage = goonBashDMG
			enemy.horizontal_speed = goon_speed
			enemy.show_healthbar = goon_show_HP
			get_parent().add_child(enemy)
			
func ChangeLevel():
	get_tree().change_scene_to_file(Level)
