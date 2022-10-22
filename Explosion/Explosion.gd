extends Node2D


func _ready():
	start(Vector2(100, 100))

func start(pos:Vector2=Vector2.ZERO):
	global_position = pos
	$AnimatedSprite.play("default")

func _on_AnimatedSprite_animation_finished():
	queue_free()
