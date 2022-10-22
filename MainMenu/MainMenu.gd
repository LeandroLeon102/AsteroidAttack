extends Node

signal Play
signal Settings
signal HowToPlay
signal Exit

func _on_Play_pressed():
	emit_signal("Play")


func _on_Settings_pressed():
	emit_signal("Settings")


func _on_Exit_pressed():
	emit_signal("Exit")

func _on_HowToPlay_pressed():
	emit_signal("HowToPlay")

		
