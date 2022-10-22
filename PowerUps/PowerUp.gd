extends Area2D

export var powerup_value = 15

func _ready():
	var _connection = $Timer.connect('timeout', self, "_on_Timer_timeout")
	_connection = connect("body_entered", self, '_on_body_entered')


func _on_Timer_timeout():
	set_deferred('monitorable', false)
	set_deferred('monitoring', false)
	$AnimationPlayer.play_backwards("spawn")
	var _connection  = $AnimationPlayer.connect("animation_finished", self, 'timeout')

func timeout(_anim_name):
	queue_free()

func collected():
	set_deferred('monitorable', false)
	set_deferred('monitoring', false)


	$Tween.interpolate_property($Sprite, 'scale', Vector2(0.05,0.05), Vector2(.1, .1), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.interpolate_property($Sprite, 'modulate', Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.interpolate_property($Sprite, 'position', $Sprite.position, $Sprite.position - Vector2(0, 30), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	$Timer.stop()
	
	var _connection = $Tween.connect('tween_all_completed', self, 'kill')
	
	
func _on_body_entered(_body):
	pass
	
func kill():
	queue_free()
