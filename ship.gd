extends Area2D

@export var speed = 50
@export var health = 500

var movement
var stop_distance
var distance = 0
var dead = false


func _ready() -> void:
	$gun_b.ship_gun = true


func start():
	var directions = ['left', 'right']
	var dir = directions[randi() % len(directions)]
	match dir:
		'up':
			stop_distance = randi_range(100, 200)
			movement = Vector2.UP
			rotation_degrees = 0
			position = Vector2(randi_range(40, 440), 280)
		'down':
			stop_distance = randi_range(100, 200)
			movement = Vector2.DOWN
			rotation_degrees = 180
			position = Vector2(randi_range(40, 440), -10)
		'left':
			stop_distance = randi_range(100, 400)
			movement = Vector2.LEFT
			rotation_degrees = -90
			position = Vector2(490, randi_range(45, 145))
		'right':
			stop_distance = randi_range(100, 400)
			movement = Vector2.RIGHT
			rotation_degrees = 90
			position = Vector2(-10, randi_range(45, 145))
	$GunTimer.start()

func flash():
	$Sprite2D.material.set_shader_parameter("flash_modifier", 0.5)
	$FlashTimer.start()


func kill():
	if not dead:
		dead = true
		Global.ships_killed += 1
		$Sprite2D.visible = false
		$ExplosionSprite.visible = true
		$gun_b.visible = false
		$ExplosionSprite.play()
		$ExplosionSound.play()


func _process(delta: float) -> void:
	position += movement * speed * delta
	distance += speed * delta
	if distance >= stop_distance:
		speed = 0
	if health <= 0:
		kill()
	if Global.boss_started: 
		kill()


func _on_flash_timer_timeout() -> void:
	$Sprite2D.material.set_shader_parameter("flash_modifier", 0)


func _on_explosion_sprite_animation_finished() -> void:
	queue_free()


func _on_gun_timer_timeout() -> void:
	$gun_b.start()
