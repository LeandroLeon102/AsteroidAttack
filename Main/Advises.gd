extends Node

var camera

func _ready():
	camera = get_tree().get_nodes_in_group('Camera')[0]


func show_central_advice(text):
	$Label.text = str(text)
	$AnimationPlayer.play("show")
