extends AudioStreamPlayer2D


func _ready():
	pass


func _on_SoundEffect_finished():
	queue_free()
