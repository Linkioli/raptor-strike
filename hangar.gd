extends Area2D

var health = 1000

signal opened
signal closed
signal killed

var dead = false

func _ready() -> void:
	$CollisionShape2D.disabled = true


func _process(delta: float) -> void:
	if health <= 0:
		kill()


func open():
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.play("open")


func close():
	$AnimatedSprite2D.play("close")


func kill():
	if not dead:
		dead = true 
		killed.emit()
		$CollisionShape2D.disabled = true
		$AnimatedSprite2D.play("die")
		$ExplosionSprite.visible = true
		$ExplosionSprite.play()
		$ExplosionSound.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "open":
		opened.emit()
	if $AnimatedSprite2D.animation == "close":
		$CollisionShape2D.disabled = true
		closed.emit()


func flash():
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0.5)
	$FlashTimer.start()


func _on_flash_timer_timeout() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0)


func _on_explosion_sprite_animation_finished() -> void:
	$ExplosionSprite.visible = false
