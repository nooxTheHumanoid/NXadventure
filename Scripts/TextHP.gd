extends Label

var health = 0

func set_health(currentHP, maxhp):
	health = currentHP
	text = str(health) + "/" + str(maxhp)
	
	if health <= 0:
		queue_free()
