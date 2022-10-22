extends Node

onready var Player = preload("res://Player/Player.tscn")
onready var LaserBullet = preload("res://Bullets/LaserBullet.tscn")
onready var Asteroid = preload("res://Asteroid/Asteroid.tscn")

export (int) var wave = 0
export (int) var score = 0
export (int) var player_lives = 3

var asteroid_sizes = ['tiny', 'small', 'med', 'big']
var camera
var p

signal Main_Menu


func _ready():
	$PauseMenu.connect("MainMenu", self, 'Go_To_Main_Menu')
	camera = get_tree().get_nodes_in_group('Camera')[0]
	camera.zoom_in()
	randomize()
	p = Player.instance()
	p.global_position = Vector2(1024/2, 640/2)
	add_child(p)
	p.connect("Shoot", self, 'player_shoot')
	for i in range(1):
		var a = Asteroid.instance()
		var choice = asteroid_sizes[randi() % asteroid_sizes.size()]
		get_tree().get_nodes_in_group('EnemyContainer')[0].add_child(a)
		a.init(choice, Vector2(rand_range(0,1024), rand_range(0,640)), Vector2(rand_range(-100,100), rand_range(-100,100)))


func player_shoot(pos, rot, type):
	var b
	match type:
		'laser':
			b = LaserBullet.instance()

			b.start_at(rot, pos)
			
	get_tree().get_nodes_in_group('BulletsContainer')[0].add_child(b)

func _input(event):
	if event.is_action_pressed('pause'):
		$PauseMenu.togle_menu()


func Go_To_Main_Menu():
	
	$PauseMenu.togle_menu()
	p.explode()
	emit_signal("Main_Menu")
	camera.zoom_out()
	
