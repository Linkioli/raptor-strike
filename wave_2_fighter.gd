extends Area2D

@export var speed = 175
@export var health = 50

var movement = Vector2.UP
var can_shoot = false
var directions = ['up', 'down', 'left', 'right']
var dir
var dead = false

@export var bullet_scene: PackedScene

func start():
	dir = directions[randi() % len(directions)]
	var player_pos = Global.player.global_position
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


func shoot():
	if not can_shoot:
		return 
	var b = bullet_scene.instantiate()
	Global.bullets.append(b)
	can_shoot = false
	$GunTimer.start()
	get_tree().root.add_child(b)
	b.start(dir, $Gun.global_position)


func kill():
	if not dead:
		can_shoot = false
		dead = true
		Global.jets_killed += 1
		$AnimatedSprite2D.visible = false
		$ExplosionSprite.visible = true
		$ExplosionSound.play()
		$ExplosionSprite.play()


func _process(delta: float) -> void:
	position += movement * speed * delta
	shoot()
	if health <= 0:
		kill()
	if Global.boss_started:
		kill()


func _on_attack_timer_timeout() -> void:
	can_shoot = true


func _on_gun_timer_timeout() -> void:
	can_shoot = true


func flash():
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0.5)
	$FlashTimer.start()


func _on_flash_timer_timeout() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_explosion_sprite_animation_finished() -> void:
	queue_free()
