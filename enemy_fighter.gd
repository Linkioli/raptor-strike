extends Area2D

@export var speed = 0
@export var health = 1

var movement = Vector2.UP
var direction
var can_shoot = false
var directions = ['up', 'down', 'left', 'right']
var dead = false

@export var bullet_scene: PackedScene

signal killed
signal departed

func _ready() -> void:
	$CollisionShape2D.disabled = true 


func take_off():
	health = 75
	dead = false
	$AnimatedSprite2D.visible = true
	movement = Vector2.UP
	visible = true
	rotation_degrees = 0
	speed = 50
	$BoostTimer.start()
	$DepartTimer.start()


func attack(dir, player_pos):
	visible = true
	$CollisionShape2D.disabled = false
	direction = dir
	match dir:
		'up':
			movement = Vector2.UP
			rotation_degrees = 0
			global_position = Vector2(player_pos.x, 280)
		'down':
			movement = Vector2.DOWN
			rotation_degrees = 180
			global_position = Vector2(player_pos.x, -10)
		'left':
			movement = Vector2.LEFT
			rotation_degrees = -90
			global_position = Vector2(490, player_pos.y)
		'right':
			movement = Vector2.RIGHT
			rotation_degrees = 90
			global_position = Vector2(-10, player_pos.y)
	
	$AttackTimer.start()

func _process(delta: float) -> void:
	position += movement * speed * delta
	shoot()
	if health <= 0:
		kill()


func shoot():
	if not can_shoot:
		return 
	var b = bullet_scene.instantiate()
	Global.bullets.append(b)
	can_shoot = false
	$GunTimer.start()
	get_tree().root.add_child(b)
	b.start(direction, $Gun.global_position)


func kill():
	if not dead:
		can_shoot = false
		$CollisionShape2D.disabled = true
		$ExplosionSound.play()
		$AnimatedSprite2D.visible = false
		$ExplosionSprite.visible = true
		$ExplosionSprite.play('default')
		dead = true


func _on_gun_timer_timeout() -> void:
	if not dead:
		can_shoot = true


func _on_attack_timer_timeout() -> void:
	if not dead:
		can_shoot = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$SpawnTimer.start()


func _on_spawn_timer_timeout() -> void:
	if not dead:
		attack(directions[randi() % len(directions)], Global.player.global_position)


func _on_boost_timer_timeout() -> void:
	$CollisionShape2D.disabled = false
	z_index = 1
	speed = 150


func _on_depart_timer_timeout() -> void:
	departed.emit()


func flash():
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0.5)
	$FlashTimer.start()


func _on_flash_timer_timeout() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0)


func _on_explosion_sprite_animation_finished() -> void:
	killed.emit()
	speed = 0
	$ExplosionSprite.visible = false
