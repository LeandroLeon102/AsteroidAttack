extends Node

signal MainMenu


func _on_MainMenu_pressed():
	emit_signal("MainMenu")
