extends Area2D

var health = 100
var can_shoot = false
var dead = false

@export var bullet_node: PackedScene

func _process(delta: float) -> void:
	if health <= 0:
		kill()


func shoot():
	var bullet = bullet_node.instantiate()
	bullet.shoot_at_player(global_position)
	bullet.speed = 100
	get_tree().current_scene.call_deferred("add_child", bullet)


func start():
	$Animation.set_animation('open')
	$BurstInterval.start()


func kill(sound=true):
	if dead:
		return
	else:
		dead = true
		can_shoot = false
		$CollisionShape2D.disabled = true
		$Animation.set_animation('die')
		$Explosion.visible = true
		$Explosion.play()
		if sound:
			$ExplosionSound.play()


func _on_animation_animation_finished() -> void:
	if $Animation.animation == "open":
		$CollisionShape2D.disabled = false
		can_shoot = true


func _on_burst_speed_timeout() -> void:
	if can_shoot:
		shoot()


func _on_burst_interval_timeout() -> void:
	if can_shoot == false and not dead:
		can_shoot = true
	elif can_shoot == true:
		can_shoot = false


func flash():
	$Animation.material.set_shader_parameter("flash_modifier", 0.5)
	$FlashTimer.start()


func _on_flash_timer_timeout() -> void:
	$Animation.material.set_shader_parameter("flash_modifier", 0)


func _on_explosion_animation_finished() -> void:
	$Explosion.stop()
	$Explosion.visible = false
