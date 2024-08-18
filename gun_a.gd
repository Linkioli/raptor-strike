extends Area2D

var health = 1000
var can_shoot = false

var dead = false

var theta: float = 0.0
@export_range(0, 2*PI) var alpha: float = 0.0

@export var bullet_node: PackedScene

func _process(delta: float) -> void:
	if health <= 0:
		kill()

func get_vector(angle):
	theta = angle + alpha
	return Vector2(cos(theta), sin(theta))


func shoot(angle):
	var bullet = bullet_node.instantiate()
	
	bullet.speed = 100
	bullet.position = global_position
	bullet.direction = get_vector(angle)
	
	get_tree().current_scene.call_deferred("add_child", bullet)


func start():
	$Animation.set_animation('open')


func kill(sound=true):
	if not dead:
		dead = true
		can_shoot = false
		$CollisionShape2D.disabled = true
		$Animation.play("dead")
		$ExplosionSprite.visible = true
		$ExplosionSprite.play()
		if sound:
			$ExplosionSound.play()


func _on_speed_timeout() -> void:
	if can_shoot:
		shoot(theta)


func _on_animation_animation_finished() -> void:
	if $Animation.animation == "open":
		$CollisionShape2D.disabled = false
		can_shoot = true

func flash():
	$Animation.material.set_shader_parameter("flash_modifier", 0.5)
	$FlashTimer.start()


func _on_flash_timer_timeout() -> void:
	$Animation.material.set_shader_parameter("flash_modifier", 0)


func _on_explosion_sprite_animation_finished() -> void:
	$ExplosionSprite.visible = false
