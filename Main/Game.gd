extends Node

var main 
var enemy_container
var player = null
var player_path
var camera
export var mass_multiplier = 1.7
onready var mob_spawn_range = $MobSpawnRange/PathFollow2D

export var wave = 0
var wave_points = 2.4
var on_wave
var score = 0

var game_ended

func _ready():
	randomize()
	enemy_container = get_tree().get_nodes_in_group('EnemiesContainer')[0]
	main = get_tree().get_nodes_in_group('Main')[0]
	camera = get_tree().get_nodes_in_group('Camera')[0]
	camera.zoom_in()
	player = main.spawn_player(Vector2(640, 360 + 100))

	player_path = player.get_path()
	player.connect('GameOver', self, 'game_over')
	var _connection = $Advises/AnimationPlayer.connect("animation_finished", self, 'generate_new_wave')
	new_wave(wave)

func _physics_process(_delta):
	if game_ended:
		if enemy_container.get_child_count():
			enemy_container.get_child(0).explode()
	else:
		$HUD.set_score(score)
		var enemy_count = main.EnemiesContainer.get_child_count()
		$HUD.set_enemy_number(enemy_count)
		if enemy_count == 0 and not game_ended:

			if on_wave:
				on_wave = false
				new_wave(wave)

		if get_node_or_null(player_path):
			$HUD/UI/HealthBar.set_health(player.health)
		else:
			$HUD/UI/HealthBar.set_health(0)
		
		if Input.is_action_pressed("view_enemy"):
			if get_tree().get_nodes_in_group('EnemiesContainer')[0].get_children():
				if get_tree().get_nodes_in_group('PlayerContainer')[0].get_children():
					if not camera.locked:
						player.block_actions(true)
						change_camera_target('enemy')
				else:
					change_camera_target('advice')
		if Input.is_action_just_released("view_enemy"):
			if get_tree().get_nodes_in_group('PlayerContainer')[0].get_children():
				if not camera.locked:
						player.block_actions(false)
						change_camera_target('player')
			
			else:
					change_camera_target('advice')

func enemy_exploded(enemy):
	
	if enemy.is_in_group('Asteroid'):
		if not game_ended:
			score += enemy.mass
		match enemy.size:
			'big':
				for _i in range(2):

					randomize()
					main.spawn_asteroid(enemy.global_position, 'med', Vector2(enemy.mass * mass_multiplier, enemy.mass * mass_multiplier ).rotated(randi()% 180/PI))
			'med':
				for _i in range(2):
					randomize()
					main.spawn_asteroid(enemy.global_position, 'small', Vector2(enemy.mass * mass_multiplier, enemy.mass * mass_multiplier ).rotated(randi()% 180/PI))
			'small':
				for _i in range(2):
					randomize()
					main.spawn_asteroid(enemy.global_position, 'tiny', Vector2(enemy.mass * mass_multiplier,enemy.mass * mass_multiplier ).rotated(randi()% 180/PI))
			'tiny':
				pass
		if randf() <= main.asteroid_info['drop_rate'][enemy.size] and not game_ended:
			main.spawn_powerup(enemy.global_position, 'health')
	if enemy.is_in_group('UFO'):
		if not game_ended:
			score += enemy.score
			if randf() <= main.enemy_ships_info['drop_rate']:
				main.spawn_powerup(enemy.global_position, 'health')

func new_wave(current_wave):
	if not game_ended:
		wave = current_wave +1
		$HUD.set_wave_number(wave)
		$Advises.show_central_advice('Wave ' + str(wave))
		on_wave= false

func generate_new_wave(_anim):
	if not game_ended:
		var wave_total_points = wave_points * float(wave)
		var enemy_list = {
							'asteroids':{'tiny':int(wave_total_points / 2.4) %10,
										'small':int(wave_total_points / 4),
										'med':int(wave_total_points / 6) ,
										'big':int(wave_total_points / 10)},
							'ships':1 * ((wave)/5) if (wave) % 5 == 0 else 0}
		for enemy_type in enemy_list.keys():
			match enemy_type:
				'asteroids':
					for size in enemy_list[enemy_type].keys():
						for _x in range(enemy_list[enemy_type][size]):
							var pos = randomize_mob_spawn_position()
							main.spawn_asteroid(pos, size, Vector2(rand_range(-120, 120),rand_range(-120, 120)).rotated(deg2rad(randi()%360)))
				'ships':
					for _x in range(enemy_list['ships']):
						var pos = randomize_mob_spawn_position()
						main.spawn_enemy(pos)
		on_wave = true

func randomize_mob_spawn_position():
	mob_spawn_range.unit_offset = rand_range(0, 1)
	return mob_spawn_range.position
	
func change_camera_target(target):
	match target:
		'player': 
			if get_tree().get_nodes_in_group('PlayerContainer')[0].get_children():
				camera.set_target(get_tree().get_nodes_in_group('PlayerContainer')[0].get_children()[0].get_path())
		'advice':
			camera.set_target($Advises/Position2D.get_path())
		'enemy':
			camera.set_target(get_tree().get_nodes_in_group('EnemiesContainer')[0].get_children()[0].get_path())
		_:
			camera.set_target(target.get_path())

func block_player_actions(value:bool):
	if is_instance_valid(player):
		if value:
			
			player.block_actions(true)
		else:

			player.block_actions(false)

func player_invulnerable(value:bool):
		if is_instance_valid(player):
			player.vulnerable(value)

func end_game():
	game_ended = true
	if get_tree().get_nodes_in_group('PlayerContainer')[0].get_child_count():
		player.explode()
	$HUD/PauseMenu.queue_free()
	game_over()

func game_over():
	$HUD/UI.visible = false
	
	$Advises.show_central_advice('GAME OVER')
	game_ended = true
	camera.zoom_out()
	$Advises/AnimationPlayer.connect("animation_finished", self, 'show_score_screen')
	$HUD/PauseMenu.queue_free()

func show_score_screen(_anim):
	$HUD/Score/VBoxContainer2/ScoreCount.text = str(score)
	$HUD/Score/VBoxContainer/WaveCount.text = str(wave)
	$HUD/Score.visible = true

	
func lock_camera(value:bool):
	camera.lock_camera(value)


func _on_LineEdit_text_entered(new_text):
	main.records_screen()
	queue_free()
