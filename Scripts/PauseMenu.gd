extends Node2D
signal restart 
signal endgame

var paused = false

func _ready():
	$Control/VBoxContainer2/Continue.connect("pressed", self, 'pauseGame')
	$Control/VBoxContainer2/Restart.connect('pressed', self, 'restart')
	$Control/VBoxContainer2/ExitGame.connect("pressed", self, 'endGame')
	
func restart():
	emit_signal("restart")
	pauseGame()
	pass
	

func pauseGame():
	paused = not paused
	
func endGame():
	emit_signal('endgame')

	pauseGame()
	$Control.queue_free()
func _process(delta):
	if Input.is_action_just_released("pause"):
		pauseGame()
	get_tree().set_pause(paused)
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		get_parent().get_parent().get_node("PlayerHUD/PlayerHUD").visible = false
		visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		get_parent().get_parent().get_node("PlayerHUD/PlayerHUD").visible = true
		visible = false
		
