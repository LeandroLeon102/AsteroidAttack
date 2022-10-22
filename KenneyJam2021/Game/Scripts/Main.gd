extends Node

onready var game = preload("res://Scenes/Game.tscn")
onready var RestartMenu = preload("res://Scenes/restartMenu.tscn")
onready var Mainmenu = preload("res://Scenes/MainMenu.tscn")
onready var howtoplay = preload("res://Scenes/HowToPlay.tscn")

onready var scene = get_node("Scene")

var actual_scene = 'menu'

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	MainMenu()





func StartGame():
	$Scene.remove_child($Scene.get_child(0))
	var new_game = game.instance()
	actual_scene = 'ingame'
	scene.add_child(new_game)
	new_game.connect('restart_menu', self, 'restart_menu')


func _physics_process(delta):
	if actual_scene == 'menu':
		$Mouse/Sprite.texture = $Mouse.mouse_cursor
	if actual_scene == 'ingame':
			$Mouse/Sprite.texture = $Mouse.crosshair_cursor2
			
	var mouse_colliding = $Mouse/Area2D.get_overlapping_bodies()
	if mouse_colliding:
		if mouse_colliding[0].is_in_group('player'):
			pass

		else:
			$Mouse/Sprite.texture = $Mouse.crosshair_cursor1
	


func _on_Area2D_area_entered(area):
	if $Mouse/Sprite.texture == $Mouse.crosshair_cursor2:
		$Mouse/Sprite.texture = $Mouse.crosshair_cursor1
	else:
		$Mouse/Sprite.texture = $Mouse.crosshair_cursor2
		
func restart_menu(score):
	$Scene.remove_child($Scene.get_child(0))
	actual_scene = 'menu'
	var restartmenu = RestartMenu.instance()
	restartmenu.score(score)
	$Scene.add_child(restartmenu)
	restartmenu.connect("mainMenu", self, "MainMenu")
	restartmenu.connect("restart", self, "StartGame")
	restartmenu.connect("exitGame", self, 'ExitGame')
	
func MainMenu():
	$Scene.remove_child($Scene.get_child(0))
	actual_scene = 'menu'
	var mainmenu = Mainmenu.instance()
	mainmenu.connect("Start_Game", self, "StartGame")
	mainmenu.connect("exitGame", self, 'ExitGame')
	mainmenu.connect("howToPlay", self, 'HowToPlay')
	$Scene.add_child(mainmenu)
	
func ExitGame():
	get_tree().quit()

func HowToPlay():
	$Scene.remove_child($Scene.get_child(0))
	actual_scene = 'menu'
	var htp = howtoplay.instance()
	htp.connect("mainMenu", self, 'MainMenu')
	$Scene.add_child(htp)
	
	
	
	

