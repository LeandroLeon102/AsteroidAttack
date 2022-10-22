extends Node

signal Start_Game
signal exitGame
signal howToPlay

func _ready():
	pass


func _on_Button_pressed():
	emit_signal("Start_Game")


func _on_ExitGame_pressed():
	emit_signal("exitGame")
	


func _on_HowToPlay_pressed():
	emit_signal("howToPlay")
