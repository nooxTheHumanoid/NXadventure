extends Control

@onready var label = $Label
@onready var wavelabel = $Waves
@onready var enemycount = $count

func _ready() -> void:
	global.kills = 0
	global.Wave = 1
	global.maxenemies = 5
	wavelabel.text = "Danger Level: " + str(global.Wave)

func _process(_delta: float) -> void:
	label.text = "Kills: " + str(global.kills)
	wavelabel.text = "Danger Level: " + str(global.Wave)
	enemycount.text = str(global.enemies) + "/" + str(global.maxenemies)
