extends Node

# Settings
var SFX_Enabled = true
var Music_Enabled = true
# track all kills
var kills = 0
# for defence
var tempkills = 0
# for arena mode
var Wave = 0
var maxenemies = 5
var enemies = 0
func _process(_delta: float) -> void:
	if Wave == 1:
		maxenemies = 5
	if kills >= 10 and kills < 30:
		Wave = 2
		maxenemies = 7
	if kills >= 30 and kills < 50:
		Wave = 3
		maxenemies = 8
	if kills >= 50 and kills < 100:
		Wave = 4
		maxenemies = 10
	if kills >= 100:
		Wave = 5
		maxenemies = 14
