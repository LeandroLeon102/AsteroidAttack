extends Camera2D
var target setget set_target, get_target
var path = null
var locked = false

func lock_camera(value:bool):
	locked = value

func _physics_process(_delta):
	if get_target():

		global_position = target.global_position
		
func zoom_in():
	$AnimationPlayer.play("zoom_in")
	
func zoom_out():
	$AnimationPlayer.play("zoom_out")
	
func set_target(path_to_node):
	if not locked:
		path = path_to_node
		target = get_target()
	

func get_target():
	if path:
		var t = get_node_or_null(path)
		if t:
			return t
		else:
			path = null
			target = null
