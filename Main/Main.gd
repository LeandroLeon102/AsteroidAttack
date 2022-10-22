extends Node

signal Spawned

export (AudioStream) var ExplosionSound

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
onready var EnemiesContainer = $Containers/Enemies


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

func _ready():

	randomize()
	main_menu()


func play_sfx(stream:AudioStream, position:Vector2=Vector2.ZERO, volume:float=0.0, pitch:float=1):
	
	var sound = SoundEffect.instance()
	sound.stream = stream
	sound.volume_db = volume
	sound.pitch_scale = pitch
	sound.global_position = position
	$Containers/Sounds.add_child(sound)
	

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
	pass
	
	
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
	
	
func spawn_bullet(bullet, position, direction):
	var b = bullet.instance()
	b.start_at(position, direction)
	$Containers/Bullets.add_child(b)

	
func spawn_enemy_bullet():
	pass


func load_scene(path):
	var scene = load(path)
	return scene


func main_menu():
	change_scene(MainMenu)
	$MusicPlayer.volume_db = 0
	

func start_new_game():

	clean_containers()
	change_scene(Game)

	$MusicPlayer.volume_db = -5
	
	
func settings_menu():
	var s = SettingsMenu.instance()
	$Scene.get_child(0).play_hide()
	$Scene.add_child(s)
	s.play_show()

	

func records_screen():
	var s = RecordsScreen.instance()
	$Scene.get_child(0).play_hide()
	$Scene.add_child(s)
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
