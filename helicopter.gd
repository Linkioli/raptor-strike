extends Area2D

@export var speed = 80
@export var health = 100
@export var bullet_scene: PackedScene

var can_shoot = false
var movement = Vector2.ZERO
var player_pos
var direction
var distance = 0
var stop_distance
var dead = false

#func start(dir, pos):
#	player_pos = pos
#	direction = dir
#	match dir:
#		'up':
#			movement = Vector2.UP
#			rotation_degrees = 90
#			position = Vector2(pos.x, 280)
#		'down':
#			movement = Vector2.DOWN
#			rotation_degrees = -90
#			position = Vector2(pos.x, -10)
#		'left':
#			movement = Vector2.LEFT
#			rotation_degrees = 0
#			position = Vector2(490, pos.y)
#		'right':
#			movement = Vector2.RIGHT
#			rotation_degrees = 180
#			position = Vector2(-10, pos.y)


func start():
	var directions = ['up', 'down', 'left', 'right']
	var dir = directions[randi() % len(directions)]
	match dir:
		'up':
			stop_distance = randi_range(100, 200)
			movement = Vector2.UP
			rotation_degrees = 90
			position = Vector2(randi_range(40, 440), 280)
		'down':
			stop_distance = randi_range(100, 200)
			movement = Vector2.DOWN
			rotation_degrees = -90
			position = Vector2(randi_range(40, 440), -10)
		'left':
			stop_distance = randi_range(100, 400)
			movement = Vector2.LEFT
			rotation_degrees = 0
			position = Vector2(490, randi_range(45, 145))
		'right':
			stop_distance = randi_range(100, 400)
			movement = Vector2.RIGHT
			rotation_degrees = 180
			position = Vector2(-10, randi_range(45, 145))


func shoot():
	if not can_shoot:
		return
	var b = bullet_scene.instantiate()
	Global.bullets.append(b)
	can_shoot = false
	$GunTimer.start()
	get_tree().root.add_child(b)
	b.shoot_at_player(global_position)


func kill():
	if not dead:
		dead = true
		Global.helis_killed += 1
		$AnimatedSprite2D.visible = false
		$Explosion.visible = true
		$Explosion.play()
		$ExplodeSound.play()


func _process(delta: float) -> void:
	position += movement * speed * delta
	distance += speed * delta
	if distance >= stop_distance:
		speed = 0
	shoot()
	if health <= 0:
		kill()
	if Global.boss_started: 
		kill()


func _on_gun_timer_timeout() -> void:
	can_shoot = true


func _on_start_attack_timeout() -> void:
	can_shoot = true


func flash():
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0.5)
	$FlashTimer.start()


func _on_flash_timer_timeout() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0)


func _on_explosion_animation_finished() -> void:
	queue_free()
