extends CharacterBody2D

var Attack_Enemy1 = false
var Attack_Enemy2 = false
var player_inDamageRange = false
var enemy_attack_cooldown = true
var player_takeDamageCooldown = true
var health = 100
var player_alive = true
var current_dir = "none"
var attack_ip = false
var direction : Vector2 = Vector2.ZERO
@onready var speed : float = 100
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar : ProgressBar = $HUD_layer2/HUD/HP_bar



func _ready():
	$AnimatedSprite2D.play("idle_down")
	print("player hp = ", health)

func _physics_process(delta):
	
	if not attack_ip:
		player_movement()
	
	Enemy_Attack()
	
	attack()
	
	if attack_ip == false:
		$Attack_Area/CollisionShape2D.disabled = true;
		
	if health <= 0:
		player_alive = false
		health = 0 
		print("player has been killed")
		self.queue_free()

func player_movement():
	var direction: Vector2 = Vector2(Input.get_axis("left","right"), Input.get_axis("up","down")).normalized()
	
	if Input.is_action_pressed("right"):
		current_dir = "right"
		$Attack_Area.position = Vector2(15, -15)
		play_anim(1)
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		$Attack_Area.position = Vector2(-15, -15)
		play_anim(2)
	elif Input.is_action_pressed("down"):
		current_dir = "down"
		$Attack_Area.position = Vector2(0, 3)
		play_anim(3)
	elif Input.is_action_pressed("up"):
		current_dir = "up"
		$Attack_Area.position = Vector2(0,-25)
		play_anim(4)
	else: 
		play_anim(0)
	velocity  =  direction * speed
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		if movement == 1:
			anim.play("walk_right")
		elif movement == 0:
			if attack_ip == false:
				anim.play("idle_right")
			
	if dir == "left":
		if movement == 2:
			anim.play("walk_left")
		elif movement == 0:
			if attack_ip == false:
				anim.play("idle_left")
			
	if dir == "down":
		if movement == 3:
			anim.play("walk_down")
		elif movement == 0:
			if attack_ip == false:
				anim.play("idle_down")
			
	if dir == "up":
		if movement == 4:
			anim.play("walk_up")
		elif movement == 0:
			if attack_ip == false:
				anim.play("idle_up")
		
	

func player():
	pass



	
func attack():
	var dir = current_dir
	if Input.is_action_just_pressed("attack"):
		$Attack_Area/CollisionShape2D.disabled = false
		global.player_current_attack = true
		attack_ip = true
		
		if dir == "right" and enemy_attack_cooldown == true:
			$AnimatedSprite2D.play("attack_right")
			$deal_attack_timer.start()

			
		if dir == "left" and enemy_attack_cooldown == true:
			$AnimatedSprite2D.play("attack_left")
			$deal_attack_timer.start()

			
		if dir == "down" and enemy_attack_cooldown == true:
			$AnimatedSprite2D.play("attack_down")
			$deal_attack_timer.start()

			
		if dir == "up" and enemy_attack_cooldown == true:
			$AnimatedSprite2D.play("attack_up")
			$deal_attack_timer.start()

				
			
			
		


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false


func Player():
	pass
	
func _on_hitbox_player_area_entered(area):
	if area.is_in_group("Attack_Enemy"):
		Attack_Enemy1 = true
		player_inDamageRange = true
	if area.is_in_group("Attack_Enemy2"):
		Attack_Enemy2 = true
		player_inDamageRange = true


func _on_hitbox_player_area_exited(area):
	if area.is_in_group("Attack_Enemy"):
		player_inDamageRange = false
		Attack_Enemy1 = false
	if area.is_in_group("Attack_Enemy2"):
		player_inDamageRange = false
		Attack_Enemy2 = false

		
func Enemy_Attack():
	if Attack_Enemy1 == true:
		if player_inDamageRange and player_takeDamageCooldown == true :
			health = health - 10
			update_health_bar()
			player_takeDamageCooldown = false
			$TakeDamage_cooldown.start()
			print("player hp = ", health)
	if Attack_Enemy2 == true:
		if player_inDamageRange and player_takeDamageCooldown == true :
			health = health - 25
			update_health_bar()
			player_takeDamageCooldown = false
			$TakeDamage_cooldown.start()
			print("player hp = ", health)


func _on_take_damage_cooldown_timeout():
	player_takeDamageCooldown = true


func update_health_bar():
	if health_bar:
		health_bar.value = health
