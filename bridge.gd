extends Area2D

@export var health = 3200

var dead = false

signal killed

func _process(delta: float) -> void:
	if health <= 0:
		kill()


func flash():
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0.2)
	$FlashTimer.start()


func kill():
	if not dead:
		dead = true
		killed.emit()
		$CollisionShape2D.disabled = true
		$ExplosionSound.play()
		$AnimatedSprite2D.play("die")
		$ExplosionSprite.visible = true
		$ExplosionSprite.play()


func _on_flash_timer_timeout() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0)


func _on_explosion_sprite_animation_finished() -> void:
	$ExplosionSprite.visible = false
