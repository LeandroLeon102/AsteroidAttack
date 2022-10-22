extends Node2D

func _ready():
	$AudioStreamPlayer2D.play()
	$AnimatedSprite.play('explosion')


func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.stop()


func _on_AnimatedSprite_animation_finished():
	queue_free()
