extends "res://PowerUps/PowerUp.gd"


func _ready():
	powerup_value = get_tree().get_nodes_in_group('Main')[0].powerup_info['boost']['health']
	SPAWN_SOUND.loop_mode = AudioStreamSample.LOOP_DISABLED
	get_tree().get_nodes_in_group('Main')[0].play_sfx(SPAWN_SOUND, global_position, SPAWN_VOLUME, 1)
	
func _on_body_entered(body):
	get_tree().get_nodes_in_group('Main')[0].play_sfx(COLLECT_SOUND, global_position, COLLECT_VOLUME , 3)
	collected()
	body.increase_health(powerup_value)
	
