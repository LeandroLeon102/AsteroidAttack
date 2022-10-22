extends KinematicBody2D

signal Shoot

export var max_health = 100
export var max_velocity = 500
export var acceleration = 10
export var weapon_recoil = 100
export var friction = 10
export var weapon_type = 'laser'

var min_pos = Vector2(0, 0)
var max_pos = Vector2(1280, 720)
var extents = 25

var health = max_health
var velocity = Vector2.ZERO
var rot


func _ready():
	$RemoteTransform2D.remote_path = get_tree().get_nodes_in_group('Camera')[0].get_path()
	randomize()


func _physics_process(delta):
	var x_input = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var y_input = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	var direction = Vector2(x_input, y_input).normalized()
	if Input.is_action_just_pressed("shoot"):
		shoot()
	velocity += acceleration * direction
	if not direction and velocity.length() > 100:
		velocity += -velocity * .01
	velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
	velocity.y = clamp(velocity.y, -max_velocity, max_velocity)
	
	$pivot.look_at(get_global_mouse_position())
	rot = $pivot.rotation * 180/PI
	
	global_position += velocity * delta
	keep_on_screen()


func shoot():
	emit_signal('Shoot', global_position, rot, weapon_type)
	$AudioStreamPlayer2D.pitch_scale = rand_range(0.9, 1.1)
	$AudioStreamPlayer2D.play()
	velocity += Vector2(-weapon_recoil, 0).rotated(rot * PI/180)


func keep_on_screen():
	global_position.x = clamp(global_position.x, min_pos.x + extents, max_pos.x - extents)
	global_position.y = clamp(global_position.y, min_pos.y + extents, max_pos.y - extents)
	
func explode():
	get_tree().get_nodes_in_group('AsteroidAtack')[0].Spawn_Explosion(global_position)
	queue_free()
