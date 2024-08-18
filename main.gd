extends Node

var scroll_speed = 75

var player_killed = false

var wave_one_started = false
var wave_two_started = false
var wave_three_started = false
var boss
var boss_intro_started = false
var boss_started = false
var end_started = false
var boss_unlocked = false

var sound_fade = false

var enemies_spawnable = true
var player_spawnable = true

var title_started = false
var title_finished = false

var enemies = []
var spawn_array = []

@export var boss_scene: PackedScene
@export var helicopter_scene: PackedScene
@export var jet_scene: PackedScene
@export var ship_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player = $Player
	$Player.can_shoot = false
	$TitleScreen.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# scrolling background
	$background.scroll_offset.y += scroll_speed * delta
	if player_killed and Input.is_action_just_pressed("shoot"):
		restart()

	if not title_finished and Input.is_action_just_pressed("shoot") and not title_started:
		title_started = true
		$TitleScreen.start_game()
	
	if Global.helis_killed >= 5 and wave_two_started == false:
		start_wave_two()
		
	if Global.jets_killed >= 3:
		if wave_three_started == false:
			start_wave_three()
		
	if Global.ships_killed >= 3:
		if not boss_intro_started:
			start_boss_intro()
	
	if sound_fade:
		$WorldMusic.volume_db -= 0.5
	if $WorldMusic.volume_db <= -80:
		sound_fade = false
		$WorldMusic.stop()
		if not boss_started:
			start_boss()
	
	if Global.boss_defeated:
		$BossMusic.volume_db -= 1
		end_game()


func spawn_enemies():
	var enemy = spawn_array [randi() % len(spawn_array)]
	match enemy:
		'helicopter':
			var helicopter = helicopter_scene.instantiate()
			get_tree().root.add_child(helicopter)
			enemies.append(helicopter)
			helicopter.start()
		'jet':
			var jet = jet_scene.instantiate()
			enemies.append(jet)
			get_tree().root.add_child(jet)
			jet.start()
		'ship':
			var ship = ship_scene.instantiate()
			enemies.append(ship)
			get_tree().root.add_child(ship)
			ship.start()


func start_wave_one():
	$EnemySpawnTimer.start()
	$WorldMusic.play()
	$WorldMusic.volume_db = 0
	wave_one_started = true
	$EnemySpawnTimer.wait_time = 2.5
	spawn_array.append('helicopter')


func start_wave_two():
	wave_two_started = true
	$EnemySpawnTimer.wait_time = 3
	spawn_array.append('jet')


func start_wave_three():
	wave_three_started = true
	$EnemySpawnTimer.wait_time = 4
	spawn_array.append('ship')
	spawn_array.remove_at(1)


func start_boss_intro():
	enemies_spawnable = false
	sound_fade = true


func start_boss():
	if not player_killed:
		boss_unlocked = true
		Global.boss_started = true
		$WorldMusic.stop()
		$BossMusic.play()
		boss_started = true
		boss = boss_scene.instantiate()
		get_tree().root.add_child(boss)
		boss.start()
		boss.z_index = -1


func restart():
	if player_spawnable:
		$TryAgain.visible = false
		$GameOverLabel.visible = false
		$GameOverMusic.stop()
		player_killed = false
		$Player.spawn(Vector2(243, 127))
		wave_one_started = false
		wave_two_started = false
		wave_three_started = false
		boss_intro_started = false
		boss_started = false
		sound_fade = false
		enemies_spawnable = true
		spawn_array = []
		if boss_unlocked:
			start_boss()
		else:
			start_wave_one()


func end_game():
	if not end_started:
		end_started = true
		$EndGameTimer.start()


func _on_player_killed() -> void:
	$RespawnTimer.start()
	$GameOverLabel.visible = true
	player_spawnable = false
	Global.helis_killed = 0
	Global.jets_killed = 0
	Global.ships_killed
	Global.boss_started = false
	$WorldMusic.stop()
	for i in enemies:
		if i != null:
			i.queue_free()
	if boss_started:
		$BossMusic.stop()
		boss.queue_free()
	player_killed = true
	enemies_spawnable = false
	$GameOverMusic.play()


func _on_enemy_spawn_timer_timeout() -> void:
	if enemies_spawnable:
		spawn_enemies()
		$EnemySpawnTimer.start()


func _on_respawn_timer_timeout() -> void:
	player_spawnable = true
	$TryAgain.visible = true


func _on_title_screen_done() -> void:
	$Player.can_shoot = true
	title_finished = true
	$TitleScreen.queue_free()
	$Player.visible = true
	start_wave_one()


func _on_end_game_timer_timeout() -> void:
	$end_screen.start()
