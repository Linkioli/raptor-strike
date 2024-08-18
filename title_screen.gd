extends Node

var color = '#cf573c'
var fade = false
var alpha = 0

signal done

func start():
	$Music.play()


func start_game():
	fade = true
	$FadeTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fade:
		$Music.volume_db -= 0.5
		alpha += 0.01
		$Black.color = Color(0, 0, 0, alpha)


func _on_flash_timer_timeout() -> void:
	if color == '#cf573c':
		color = '#ffffff'
	else: color = '#cf573c'
	$subtext.add_theme_color_override("font_color", color)


func _on_fade_timer_timeout() -> void:
	fade = false
	$MissionObjective.visible = true
	$SubjectiveTimer.start()


func _on_subjective_timer_timeout() -> void:
	$MissionObjective/Subjective.visible = true
	$FinishTimer.start()


func _on_finish_timer_timeout() -> void:
	done.emit()
