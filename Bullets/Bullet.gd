extends Node2D

signal explode

var speed = 1000
var vel = Vector2.ZERO
var rot = 0
var damage = 10

var extents

func _ready():
	add_to_group('player_bullets')


	set_physics_process(true)
	
func _physics_process(delta):

	global_position += vel * delta
	keep_in_screen()

func start_at(dir, pos):
	rotation = dir * PI/180
	position = pos
	vel = Vector2(speed, 0).rotated(dir *  PI/180)
	
func keep_in_screen():
	pass




func _on_Area2D_body_entered(body):
	if body.get_groups().has('Enemy'):
		body.take_damage(damage, vel.normalized())
		explode()
		
		
		
func explode():
	emit_signal("explode", global_position)
	$Area2D.set_deferred('monitoring', false)
	$Area2D.set_deferred('monitoreable', false)
	hide()
	vel = Vector2.ZERO
	damage = 0
	$AudioStreamPlayer2D.playing = true
	yield($AudioStreamPlayer2D, "finished")
	queue_free()
	
	

func _on_VisibilityNotifier2D_screen_exited():
	explode()
