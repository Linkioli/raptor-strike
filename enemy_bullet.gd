extends Area2D

@export var speed = -500
@export var damage = 25

var direction


func start(dir, pos):
	position = pos
	direction = dir
	match dir:
		"up": rotation_degrees = 0
		"down": rotation_degrees = 180
		"left": rotation_degrees = -90
		"right": rotation_degrees = 90
	 
func _process(delta):
	if Global.player.dead:
		queue_free()
	match direction:
		"up": position.y += speed * delta
		"down": position.y -= speed * delta
		"left": position.x += speed * delta
		"right": position.x -= speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Player":
		queue_free()
		area.health -= damage
