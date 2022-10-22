extends Node2D

signal mainMenu

func _ready():
	pass
	


func _on_MainMenu_pressed():
	emit_signal("mainMenu")
