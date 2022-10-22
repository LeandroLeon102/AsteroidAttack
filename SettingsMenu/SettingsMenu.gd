extends Node

signal Back
signal Save
signal Reset


func _on_Back_pressed():
	emit_signal("Back")


func _on_Save_pressed():
	emit_signal("Save")


func _on_Reset_pressed():
	emit_signal("Reset")
