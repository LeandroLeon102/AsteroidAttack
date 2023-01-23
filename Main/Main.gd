extends Node

signal Spawned
export (float, -20 ,10.0) var MUSIC_VOLUME_MIN
export (float, -20 ,10.0) var MUSIC_VOLUME_MAX
export (AudioStream) var ExplosionSound
var LEADERBOARD = []


var MainMenu = preload("res://Menus/MainMenu.tscn")
var Game = preload("res://Main/Game.tscn")
var SettingsMenu = preload("res://Menus/SettingsMenu.tscn")
var RecordsScreen = preload("res://Menus/RecordsScreen.tscn")
var InformationScreen = preload("res://Menus/InformationScreen.tscn")
var Player = preload("res://Player/Player.tscn")
var Explosion = preload("res://Explosion/Explosion.tscn")
var PlayerBullet = preload("res://Bullets/PlayerBullet.tscn")
var HealthBar = preload("res://Healthbar/HealthBar.tscn")
var HealthPowerUp = preload("res://PowerUps/HealthPowerup.tscn")
var SoundEffect = preload("res://SFX/SoundEffect.tscn")
var ShipUFO = preload("res://Enemies/EnemyShipUFORed.tscn")


var game_ended = false
onready var EnemiesContainer = $Containers/Enemies
onready var httpRequest  = $HTTPRequest


var powerup_info = {
	'types':[
		'health'],
	'boost':{
		'health':10}
	
}
var asteroid_info = {
	'sizes':{
		'big':[
			"res://Asteroids/MeteorBrownBig1.tscn",
			"res://Asteroids/MeteorBrownBig2.tscn",
			"res://Asteroids/MeteorBrownBig3.tscn",
			"res://Asteroids/MeteorBrownBig4.tscn",
			"res://Asteroids/MeteorGreyBig1.tscn",
			"res://Asteroids/MeteorGreyBig2.tscn",
			"res://Asteroids/MeteorGreyBig3.tscn",
			"res://Asteroids/MeteorGreyBig4.tscn"],
		'med':[
			"res://Asteroids/MeteorBrownMed1.tscn",
			"res://Asteroids/MeteorBrownMed3.tscn",
			"res://Asteroids/MeteorGreyMed1.tscn",
			"res://Asteroids/MeteorGreyMed2.tscn"],
		'small':[
			"res://Asteroids/MeteorBrownSmall1.tscn",
			"res://Asteroids/MeteorBrownSmall2.tscn",
			"res://Asteroids/MeteorGreySmall1.tscn",
			"res://Asteroids/MeteorGreySmall2.tscn"],
		'tiny':[
			"res://Asteroids/MeteorBrownTiny1.tscn",
			"res://Asteroids/MeteorBrownTiny2.tscn",
			"res://Asteroids/MeteorGreyTiny1.tscn",
			"res://Asteroids/MeteorGreyTiny2.tscn"]
	},
	'health':{
		'big':[100, 120],
		'med':[60, 70],
		'small':[30, 40],
		'tiny':[10, 10]
	},
	'drop_rate':{
		'big':.04,
		'med':.03,
		'small':.02,
		'tiny':.01
	}
}

var enemy_ships_info = {
	'drop_rate':.7
}

func _ready():
	randomize()
	main_menu()

#func _process(delta):
#	print($Containers/Explosions.get_child_count())

func play_sfx(stream:AudioStream, position:Vector2=Vector2.ZERO, volume:float=0.0, pitch:float=1, backwards:bool=false):
	var sound = SoundEffect.instance()
	sound.stream = stream
	sound.volume_db = volume
	sound.pitch_scale = pitch
	sound.global_position = position
	if backwards:
		sound.autoplay = false
		
	$Containers/Sounds.add_child(sound)
	if backwards:
		sound.play(stream.get_length())

func spawn(spawnee=null):
	if spawnee:
		var s = spawnee.instance()
		emit_signal("Spawned", s)
		return s

func spawn_healthbar(target):
	var healthbar = HealthBar.instance()
	healthbar.target = target
	healthbar.global_position = Vector2(target.global_position.x, target.global_position.y + (target.extents.y*0.05) *1.4 + 10)
	$Containers/HealthBars.add_child(healthbar)
	return healthbar

func spawn_asteroid(position:Vector2=Vector2.ZERO, size:String='random', vel = Vector2(0,0)):
	if size == 'random':
		size = asteroid_info['sizes'].keys()[randi()%4]

	var asteroid = asteroid_info['sizes'][size][randi()%asteroid_info['sizes'][size].size()]
	asteroid = load_scene(asteroid)
	asteroid = spawn(asteroid)
	asteroid.size = size
	asteroid.drop_rate = asteroid_info['drop_rate'][size]
	$Containers/Enemies.add_child(asteroid)
	asteroid.healthbar = spawn_healthbar(asteroid)
	asteroid.set_initial_health(int(rand_range(asteroid_info['health'][size][0], asteroid_info['health'][size][1])))

	asteroid.global_transform.origin = position
	vel = Vector2(vel.x - asteroid.mass if vel.x != 0 else 0, vel.y - asteroid.mass if vel.y != 0 else 0)
	asteroid.set_linear_velocity(vel)

func spawn_player(position:Vector2=Vector2.ZERO):
	var p = Player.instance()
	p.position = position
	$Containers/Player.add_child(p)
	return p
	
	
func spawn_enemy(_position:Vector2=Vector2.ZERO, _type='ship'):
	var e = ShipUFO.instance()
	e.global_position = _position

	$Containers/Enemies.add_child(e)
	
	
func spawn_powerup(position:Vector2=Vector2.ZERO, type='health'):
	var powerup = null
	match type:
		'health':
			powerup = HealthPowerUp.instance()
			powerup.global_position = position
			$Containers/PowerUps.add_child(powerup)


func spawn_explosion(position:Vector2=Vector2.ZERO):
	var explosion = Explosion.instance()
	play_sfx(ExplosionSound, position, 0, rand_range(1, 1.4))
	$Containers/Explosions.add_child(explosion)
	explosion.start(position)
	
	
func spawn_bullet(bullet, position, direction, speed=null):
	var b = bullet.instance()
	if speed:
		b.speed = speed
	b.start_at(position, direction)
	
	$Containers/Bullets.add_child(b)

	
func spawn_enemy_bullet():
	pass


func load_scene(path):
	var scene = load(path)
	return scene

func play_info_animation(anim):
	$CanvasLayer2/Control/AnimationPlayer2.play(anim)
	return $CanvasLayer2/Control/AnimationPlayer2

func stop_info_anim():
	$CanvasLayer2/Control/AnimationPlayer2.stop()

func main_menu():
	change_scene(MainMenu)
	$MusicPlayer.volume_db = MUSIC_VOLUME_MAX

	

func start_new_game():
	game_ended = false
	clean_containers()
	change_scene(Game)
	$MusicPlayer.volume_db = MUSIC_VOLUME_MIN
	
	
func settings_menu():
	var s = SettingsMenu.instance()
	$Scene.get_child(0).play_hide()
	$Scene.add_child(s)
	s.play_show()

func records_screen(data=null):
	if not LootLocker.token:
		yield(LootLocker.authenticate_guest_session(), 'completed')
	yield(LootLocker.get_board(), 'completed')
	var s = RecordsScreen.instance()
	var leaderboard_copy = LEADERBOARD.duplicate()
	if LootLocker.board != null:
		leaderboard_copy.append_array(LootLocker.board.duplicate())
		if data != null:
			LEADERBOARD.append(data)
			leaderboard_copy.append_array(LEADERBOARD)
			if leaderboard_copy.find(data, 0) < 100:
			
				yield(LootLocker.submit_records(data), 'completed')
	else:
		if data != null:
			
			LEADERBOARD.append(data)
			leaderboard_copy.append_array(LEADERBOARD)

		
	leaderboard_copy.sort_custom(customSorter, 'sort')
			
			
	if $Scene.get_children():
		$Scene.get_child(0).play_hide()
	$Scene.add_child(s)
	s.update_records(leaderboard_copy, data)
	s.play_show()


func information_screen():
	var s = InformationScreen.instance()
	$Scene.get_child(0).play_hide()
	$Scene.add_child(s)
	s.play_show()


func change_scene(scene):
	clean_childs($Scene)
	var s = scene.instance()
	$Scene.add_child(s)


func clean_childs(scene):
	for child in scene.get_children():
		scene.remove_child(child)
		
func clean_containers():
	for container in $Containers.get_children():
		for child in container.get_children():
			container.remove_child(child)

func GameEnded():
	game_ended = true
	
func restore_music_volume():
	$MusicPlayer.volume_db = MUSIC_VOLUME_MAX

#func update_records(data):
#	if data != null:
#		yield(LootLocker.get_board(), 'completed')
#		var leaderboard =  LootLocker.board.duplicate()
#		leaderboard.append(data)
#		LEADERBOARD.sort_custom(customSorter, 'sort')
#		LEADERBOARD.append(data)

#		if data['score'] >= LOCAL_RECORDS[0]['score']:
#			LOCAL_RECORDS.sort_custom(customSorter, 'sort')
#			MAX_RECORD = data
#			return true
#		else:
#			LOCAL_RECORDS.sort_custom(customSorter, 'sort')
#
#			return false


class customSorter:
	static func sort(a, b):
		if a != null and b != null:
			if a['score'] > b['score']:
				return true
			return false
		else:
			return false
