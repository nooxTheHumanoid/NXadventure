extends Area2D

func handle_plr_collision(player: Player):
	if player == null:
		return
	
	if player.health >= 0:
		player.health = 0
		player.died()

func handle_enemy_collision(enemy: Enemy):
	if enemy == null:
		return
	
	if enemy.health >= 1:
		enemy.hurtEnemy(1000)

func handle_enemy_collision2(enemy: EnemyMafia):
	if enemy == null:
		return
	
	if enemy.health >= 1:
		enemy.hurtEnemy(1000)

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		handle_enemy_collision(area)
	if area is EnemyMafia:
		handle_enemy_collision2(area)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		handle_plr_collision(body)
