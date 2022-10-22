extends "res://PowerUps/PowerUp.gd"



func _ready():
	powerup_value = get_tree().get_nodes_in_group('Main')[0].powerup_info['boost']['health']

func _on_body_entered(body):
	collected()
	body.increase_health(powerup_value)
	
