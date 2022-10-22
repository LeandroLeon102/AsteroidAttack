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

func _ready():
	randomize()
	enemy_container = get_tree().get_nodes_in_group('EnemiesContainer')[0]
	main = get_tree().get_nodes_in_group('Main')[0]
	camera = get_tree().get_nodes_in_group('Camera')[0]
	camera.zoom_in()
	player = main.spawn_player(Vector2(500, 320))
	player_path = player.get_path()
	var _connection = $Advises/AnimationPlayer.connect("animation_finished", self, 'generate_new_wave')
	new_wave(wave)
	


func _physics_process(_delta):
	$HUD.set_score(score)
	var enemy_count = main.EnemiesContainer.get_child_count()
	$HUD.set_enemy_number(enemy_count)
	if enemy_count == 0:
		if on_wave:
			on_wave = false
			new_wave(wave)
	if get_node_or_null(player_path):
		$HUD/Node2D/HealthBar.set_health(player.health)
	else:
		$HUD/Node2D/HealthBar.set_health(0)
	if Input.is_action_just_pressed("view_enemy"):

		if camera.get_target():
			if camera.get_target().is_in_group('Player'):
				player.block_actions(true)
				change_camera_target('enemy')

	if Input.is_action_just_released("view_enemy"):

		if camera.get_target():
			if camera.get_target().is_in_group('Enemies'):
				player.block_actions(false)
				change_camera_target('player')
		else:
			change_camera_target('player')


func asteroid_exploded(asteroid):
	score += asteroid.mass
	match asteroid.size:
		'big':
			for _i in range(2):

				randomize()
				main.spawn_asteroid(asteroid.global_position, 'med', Vector2(asteroid.mass * mass_multiplier, asteroid.mass * mass_multiplier ).rotated(randi()% 180/PI))
		'med':
			for _i in range(2):
				randomize()
				main.spawn_asteroid(asteroid.global_position, 'small', Vector2(asteroid.mass * mass_multiplier, asteroid.mass * mass_multiplier ).rotated(randi()% 180/PI))
		'small':
			for _i in range(2):
				randomize()
				main.spawn_asteroid(asteroid.global_position, 'tiny', Vector2(asteroid.mass * mass_multiplier,asteroid.mass * mass_multiplier ).rotated(randi()% 180/PI))
		'tiny':
			pass
	if randf() <= main.asteroid_info['drop_rate'][asteroid.size]:
		main.spawn_powerup(asteroid.global_position, 'health')


func new_wave(current_wave):

	wave = current_wave +1
	$HUD.set_wave_number(wave)
	$Advises.show_central_advice('Wave ' + str(wave))


func generate_new_wave(_anim):
	var wave_total_points = wave_points * float(wave)

	var enemy_list = {
						'asteroids':{'tiny':int(wave_total_points / 2.4) %10,
									'small':int(wave_total_points / 4),
									'med':int(wave_total_points / 6) ,
									'big':int(wave_total_points / 10)},
						'ships':1 * ((wave)/5) if (wave) % 5 == 0 else 0}
	
#	print(enemy_list)
	for enemy_type in enemy_list.keys():
		match enemy_type:
			'asteroids':
				for size in enemy_list[enemy_type].keys():
					print(enemy_list[enemy_type][size])
					for x in range(enemy_list[enemy_type][size]):
						var pos = randomize_mob_spawn_position()
						main.spawn_asteroid(pos, size, Vector2(rand_range(60, 120),rand_range(60, 120)).rotated(deg2rad(randi()%360)))
						
			'ships':
				pass
#	for i in range(enemy_list['asteroids']['tiny']):
#		var pos = randomize_mob_spawn_position()
#		main.spawn_asteroid(pos, 'tiny', Vector2(rand_range(60, 120),rand_range(60, 120)).rotated(deg2rad(randi()%360)))
#	for i in range(int(wave_total_points / 4)):
#		var pos = randomize_mob_spawn_position()
#		main.spawn_asteroid(pos, 'small', Vector2(rand_range(60, 120),rand_range(60, 120)).rotated(deg2rad(randi()%360)))
#	for i in range(int(wave_total_points / 6)):
#		var pos = randomize_mob_spawn_position()
#		main.spawn_asteroid(pos, 'med', Vector2(rand_range(60, 120),rand_range(60, 120)).rotated(deg2rad(randi()%360)))
#	for i in range(int(wave_total_points / 10)):
#		var pos = randomize_mob_spawn_position()
#		main.spawn_asteroid(pos, 'big', Vector2(rand_range(60, 120),rand_range(60, 120)).rotated(deg2rad(randi()%360)))
#	for i in range(int(wave_total_points / 2.4) % 10):
#		var pos = randomize_mob_spawn_position()
#		main.spawn_asteroid(pos, 'tiny', Vector2(rand_range(60, 120),rand_range(60, 120)).rotated(deg2rad(randi()%360)))

	
	on_wave = true


func randomize_mob_spawn_position():
	mob_spawn_range.unit_offset = rand_range(0, 1)
	return mob_spawn_range.position
	
func change_camera_target(target):
	match target:
		'player': 
			camera.set_target(player_path)
		'advice':
			camera.set_target($Advises/Position2D.get_path())
		'enemy':
			camera.set_target(enemy_container.get_children()[0].get_path() if enemy_container.get_child_count() else null)
			

func block_player_actions(value:bool):
	if player:
		if value:
			player.block_actions(true)
		else:
			player.block_actions(false)
