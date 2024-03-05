extends CharacterBody2D

var enemy_alive = true
var Attack_Player2 = false
var enemy_inDamageRange = false
var enemy_takeDamageCooldown = true
var speed = 70
var player_chase = false
var player = null
var health = 100 
var player_attack_cooldown = true

	
func _physics_process(delta):
	
	if health <= 0:
		enemy_alive = false
		health = 0 
		print("player has been killed")
		self.queue_free()
	
	Enemy_Attack()
	
	if player_chase == true:
		move_and_collide(Vector2(0,0))
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("Walk")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("Idle")


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false


func _on_enemy_hitbox_area_entered(area):
	if area.is_in_group("Sword"):
		Attack_Player2 = true
		enemy_inDamageRange = true

func _on_enemy_hitbox_area_exited(area):
	if area.is_in_group("Sword"):
		Attack_Player2 = false
		enemy_inDamageRange = false

func Enemy_Attack():
	if Attack_Player2 == true:
		if enemy_inDamageRange and enemy_takeDamageCooldown == true :
			health = health - 25
			enemy_takeDamageCooldown = false
			$TakeDamage_cooldown.start()
			print("big chicker hp = ", health)
	


func _on_take_damage_cooldown_timeout():
	enemy_takeDamageCooldown = true
