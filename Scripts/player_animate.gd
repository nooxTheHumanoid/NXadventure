extends AnimatedSprite2D

class_name PlayerAnimaterSprite

var charanim = "none"
var Censured_Taunt = true

func char_state(State: String):
	charanim = State

func trigger_animation(velocity: Vector2,direction: int, player_mode: Player.PlayerMode):
	var animation_prefix = Player.PlayerMode.keys()[player_mode].to_snake_case()
	if not get_parent().is_on_floor():
		play("%s_Jump" % animation_prefix)
		
	elif sign(velocity.x) != sign(direction) && velocity.x != 0 && direction != 0:
		
		scale.x = direction	
	else:
		if player_mode == Player.PlayerMode.regular:
			if scale.x == 1 && sign(velocity.x) == -1:
				scale.x = -1
			elif scale.x == -1 && sign(velocity.x) == 1:
				scale.x = 1
		else:
			scale.x = 1		
		
		if velocity.x !=0:
			play("%s_Walk" % animation_prefix)
		elif charanim == "taunt":
			play("Taunt")
		elif charanim == "duck":
			play("%s_Duck" % animation_prefix)
		else:	
			play("%s_Idle" % animation_prefix)
