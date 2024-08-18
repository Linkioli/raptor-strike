extends Area2D

@export var speed = 100
@export var damage = 25
var player_position
var direction: Vector2


func shoot_at_player(pos):
	global_position = pos
	direction = global_position.direction_to(Global.player.global_position)


func _process(delta: float) -> void:
	position += direction * speed * delta
	if Global.player.dead:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Player":
		queue_free()
		area.health -= damage


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
