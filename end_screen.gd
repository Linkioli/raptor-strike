extends ColorRect

var fade = false
var alpha = 0

func start():
	print('test')
	fade = true
	$MissionCompleteTimer.start()


func _process(delta: float) -> void:
	if fade: alpha += 0.1
	color = Color(0, 0, 0, alpha)


func _on_mission_complete_timer_timeout() -> void:
	$MissionObjective.visible = true
	$TheEndTimer.start()


func _on_the_end_timer_timeout() -> void:
	$MissionObjective/Subjective.visible = true
