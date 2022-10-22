extends Node

onready var Explosion = preload("res://explosion/Explosion.tscn")
onready var Game = preload("res://Game/Game.tscn")
onready var SettingsMenu = preload("res://SettingsMenu/SettingsMenu.tscn")
onready var HowToPlayMenu = preload("res://HowToPlayMenu/HowToPlayMenu.tscn")
onready var MainMenu = preload("res://MainMenu/MainMenu.tscn")


func add_scene(new_scene):
	var scene = new_scene.instance()
	$Scene.add_child(scene)
	return scene
	
func clear_scene():
	var childs = $Scene.get_children()
	for child in childs:
		$Scene.remove_child(child)
		
func _ready():
	Go_To_Main_Menu()
	
func Go_To_Main_Menu():
	clean_containers()
	clear_scene()
	
	var scene = add_scene(MainMenu)
	scene.connect('Play', self, 'Go_To_Game')
	scene.connect('Settings', self, 'Go_To_Settings_Menu')
	scene.connect('HowToPlay', self, 'Go_To_HowToPlay_Menu')
	scene.connect('Exit', self, 'exit')
	
func Go_To_Game():
	clear_scene()
	
	var scene = add_scene(Game)
	
	scene.connect('Main_Menu', self, 'Go_To_Main_Menu')
	
func exit():
	get_tree().quit()
	
func Go_To_Settings_Menu():
	clear_scene()
	var scene = add_scene(SettingsMenu)
	scene.connect('Back', self, 'Go_To_Main_Menu')
	
func Go_To_HowToPlay_Menu():
	clear_scene()
	var scene = add_scene(HowToPlayMenu)
	scene.connect('MainMenu', self, 'Go_To_Main_Menu')

func Spawn_Explosion(position=Vector2(0,0), size=1):

		var e = Explosion.instance()
		e.global_position = position
		add_child(e)
		
func clean_containers():
	for child in $EnemyContainer.get_children():
		child.explode()
	
	
