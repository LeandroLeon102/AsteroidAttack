extends Node

signal Continue
signal RestartWave
signal MainMenu

func _on_Continue_pressed():
	togle_menu()
	

func _on_RestartWave_pressed():
	emit_signal("RestartWave")


func _on_MainMenu_pressed():
	emit_signal("MainMenu")
	
func togle_menu():
	$CanvasLayer/Control.visible = not $CanvasLayer/Control.visible
	get_tree().paused = not get_tree().paused
