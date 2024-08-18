extends Area2D

signal departed

var speed = 0
var direction = Vector2.UP


func start():
	speed = 50
	$BoostTimer.start()


func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	speed = 0
	departed.emit()


func _on_boost_timer_timeout() -> void:
	speed = 150
