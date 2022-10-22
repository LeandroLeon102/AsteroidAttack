extends Node

signal restart
signal mainMenu
signal exitGame

func _ready():
	pass

func score(amount):
	get_node("VBoxContainer2").get_node("Label").text = "Score: " + str(amount)


func _on_Restart_pressed():
	emit_signal("restart")


func _on_MainMenu_pressed():
	emit_signal("mainMenu")


func _on_ExitGame_pressed():
	emit_signal("exitGame")
