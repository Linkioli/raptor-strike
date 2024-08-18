extends Area2D

@export var speed = 200
@export var bullet_scene : PackedScene
@export var health = 1

@onready var screensize = get_viewport_rect().size

signal killed

var dead = false
var can_shoot = true
var spawnable = false


func _process(delta):
	if not dead:
		var input = Input.get_vector("left", "right", "up", "down")
		position += input * speed * delta
		position = position.clamp(Vector2(8, 8), screensize - Vector2(8, 8))
		if Input.is_action_pressed("shoot"):
			if not Global.boss_defeated:
				shoot()
			
		if Input.is_action_pressed("left"):
			$AnimatedSprite.set_animation('left')
		elif Input.is_action_pressed("right"):
			$AnimatedSprite.set_animation('right')
		else:
			$AnimatedSprite.set_animation('idle')
		
		if health <= 0:
			kill()

func kill():
	dead = true
	killed.emit()
	$AnimatedSprite.visible = false
	$ExplosionSprite.visible = true
	$ExplosionSprite.play()
	$ExplosionSound.play()


func spawn(pos: Vector2):
	if spawnable:
		$AnimatedSprite.visible = true
		spawnable = false
		dead = false
		position = pos
		health = 1
		show()


func shoot():
	if not can_shoot:
		return 
	$Shoot.play()
	var b = bullet_scene.instantiate()
	Global.bullets.append(b)
	can_shoot = false
	$GunTimer.start()
	get_tree().root.add_child(b)
	b.start("up", position + Vector2(0, -15))


func _on_gun_timer_timeout() -> void:
	can_shoot = true


func _on_explosion_sound_finished() -> void:
	spawnable = true


func _on_explosion_sprite_animation_finished() -> void:
	$ExplosionSprite.visible = false
