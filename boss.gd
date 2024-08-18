extends Area2D

var speed = 0
var direction = Vector2.ZERO

var intro_started = false
var phase_one_started = false
var phase_one_completed = false
var phase_two_started = false
var defeated = false

var fighter


func _process(delta: float) -> void:
	position += direction * speed * delta
	if position.y >= 97 and phase_one_started == false:
		start_phase_one()
	if position.y >= 264 and phase_two_started == false:
		start_phase_two()


func start():
	if intro_started == false:
		intro_started = true
		position.y = -25
		position.x = 240
		speed = 20
		direction = Vector2.DOWN
	if intro_started == true and phase_two_started == false:
		speed = 20
	return


func start_phase_one():
	speed = 0
	phase_one_started = true
	$gun_a1.start()
	$gun_a2.start()
	$gun_b1.start()
	$gun_b2.start()

func start_phase_two_intro():
	$gun_a1.kill(false)
	$gun_a2.kill(false)
	$gun_b1.kill(false)
	$gun_b2.kill(false)
	start()
	
func start_phase_two():
	$gun_c1.start()
	$gun_c2.start()
	$gun_c3.start()
	$gun_c4.start()
	$gun_c5.start()
	$gun_c6.start()
	$gun_c7.start()
	$gun_c8.start()
	$gun_c9.start()
	$gun_c10.start()
	$gun_c11.start()
	$gun_c12.start()
	$gun_c13.start()
	$gun_c14.start()
	$Hangar.open()
	speed = 0
	phase_two_started = true
	
func kill():
	$gun_c1.kill(false)
	$gun_c2.kill(false)
	$gun_c3.kill(false)
	$gun_c4.kill(false)
	$gun_c5.kill(false)
	$gun_c6.kill(false)
	$gun_c7.kill(false)
	$gun_c8.kill(false)
	$gun_c9.kill(false)
	$gun_c10.kill(false)
	$gun_c11.kill(false)
	$gun_c12.kill(false)
	$gun_c13.kill(false)
	$gun_c14.kill(false)
	$EnemyFighter.kill()
	speed = 30
	Global.boss_defeated = true
	


func _on_bridge_killed() -> void:
	phase_one_completed = true
	start_phase_two_intro()


func _on_hangar_opened() -> void:
	$EnemyFighter.take_off()


func _on_hangar_closed() -> void:
	$HangarOpenTimer.start()


func _on_enemy_fighter_killed() -> void:
	if not defeated:
		$EnemyFighter.z_index = 0
		$EnemyFighter.position = Vector2(0, -126)
		$Hangar.open()


func _on_enemy_fighter_departed() -> void:
	if not defeated:
		$Hangar.close()


func _on_hangar_killed() -> void:
	defeated = true
	kill()
