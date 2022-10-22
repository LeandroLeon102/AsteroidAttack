extends Node


func _ready():
	$Control/Back.grab_focus()
	
func play_hide():
	$AnimationPlayer.play("hide")
	
func play_show():
	$AnimationPlayer.play("show")


func _on_Back_pressed():
	play_hide()
	get_tree().get_nodes_in_group('MainMenu')[0].play_show()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'hide':
		queue_free()
