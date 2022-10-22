extends Node

signal resume
signal restart_menu
signal exitGame
signal restart

onready var bullet = preload("res://Scenes/PlayerBullet.tscn")
onready var asteroid = preload("res://Scenes/asteroid.tscn")
onready var explosion = preload("res://Scenes/Explosion.tscn")
onready var puff = preload("res://Scenes/Puff.tscn")
onready var message = preload("res://Scenes/message.tscn")

onready var bullet_container = get_node("BulletContainer")
onready var asteroid_container = get_node("AsteroidContainer")
onready var player = get_node("Player")

onready var enemyCounter = $PlayerHUD/PlayerHUD/enemyCount

var enemies_points = {'asteroids':{'big':100, 'med':60, 'small':30, 'tiny':10}}
var asteroid_textures = ['big', 'med', 'small', 'tiny']
var asteroid_explode_pattern = {'big':'med',
								 'med':'small',
								 'small':'tiny',
								 'tiny': null}
var score = 0
export var wave = 0
var total_waves = 0
var total_enemies = {'asteroids':{'big':0, 'med':0, 'small':0, 'tiny':0}}

func _ready():
	$CanvasLayer/PauseMenu.connect('restart', self, 'restartGame')
	$CanvasLayer/PauseMenu.connect('endgame', self, 'endGame')
	player.connect('shoot', self, 'player_shoot')
	player.connect('explode', self, 'player_explode')
	new_wave()
	
func restartGame():
	emit_signal("restart")
	
func endGame():
	$Player.explode()
	
func _process(delta):
	$PlayerHUD.score(score)	
	if $AsteroidContainer.get_child_count() <= 0:
		new_wave()
	enemyCounter.text = "Enemies: \n" + str($AsteroidContainer.get_child_count())

func player_shoot(pos, rot, weapon_type):
	var b = bullet.instance()
	b.connect("explode", self, 'bullet_explode')
	b.start_at(1000, rot, pos) 
	bullet_container.add_child(b) 
	
func player_explode(pos):
	spawn_explosion(pos)
	$PlayerExplosionSound.play()
	$Node2D/Camera2D.animation_name = "camera zoomout"
	$Node2D/Camera2D.smoothing_speed = 5
	$Node2D/Camera2D.global_position = Vector2(512, 320)
	var m = message.instance()
	m.message("GAME OVER")
	m.global_position = Vector2(512, 320)
	$PlayerHUD/PlayerHUD.add_child(m)
	m.show_message()
	$restartMenuDelay.start()
	yield($restartMenuDelay, "timeout")
	emit_signal("restart_menu", score)

func bullet_explode(pos):
	var p = puff.instance()
	$BulletContainer.add_child(p)
	p.position = pos

func new_wave():
	wave += 1
	total_waves += 1
	var m = message.instance()
	m.position = Vector2(512, 300)
	$PlayerHUD/PlayerHUD.add_child(m)
	m.message("WAVE %s" % wave)


	
	for i in range(int(wave/4)):
		$Path2D/PathFollow2D.offset = randi()
		spawn_asteroid(asteroid_textures[0], $Path2D/PathFollow2D.position, Vector2(0,0))		
	
	for i in range(int(wave/3)):
		$Path2D/PathFollow2D.offset = randi()
		spawn_asteroid(asteroid_textures[1], $Path2D/PathFollow2D.position, Vector2(0,0))		
	
	for i in range(int(wave/2)):
		$Path2D/PathFollow2D.offset = randi()
		spawn_asteroid(asteroid_textures[2], $Path2D/PathFollow2D.position, Vector2(0,0))		
	
	for i in range(int(wave/1)):
		$Path2D/PathFollow2D.offset = randi()
		spawn_asteroid(asteroid_textures[3], $Path2D/PathFollow2D.position, Vector2(0,0))		
	
func spawn_asteroid(size, pos, vel):
	var a = asteroid.instance()
	a.get_node("KinematicBody2D").connect('explode', self, 'explode_asteroid')
	a.init(size, pos, vel)
	$AsteroidContainer.add_child(a)

func explode_asteroid(size, pos, vel, hit_vel):
	score += enemies_points['asteroids'][size]
	total_enemies['asteroids'][size] += 1
	
	var new_size = asteroid_explode_pattern[size]
	if new_size:
		for offset in [-1, 1]:
			var new_pos = pos + hit_vel.tangent().clamped(25) * offset
			var new_vel = vel * hit_vel.tangent() * offset
			spawn_asteroid(new_size, new_pos, new_vel)
		$asteroid_explode.playing = true
	spawn_explosion(pos)

func spawn_explosion(pos, size=null):
	var e = explosion.instance()
	add_child(e)
	e.set_position(pos)
	e.frame = 0
	e.play('explosion')
	


