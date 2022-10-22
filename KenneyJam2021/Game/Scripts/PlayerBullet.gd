extends Node2D

signal explode

var speed = 0
var vel = Vector2.ZERO
var rot = 0
var damage = 10
var screensize
var extents

func _ready():
	add_to_group('player_bullets')
	screensize = get_viewport_rect().size
	extents = $Area2D/Sprite.texture.get_size() / 2
	set_physics_process(true)
	
func _physics_process(delta):

	position += vel * delta
	keep_in_screen()

func start_at(spd, dir, pos):
	rotation = dir * PI/180 
	speed = spd
	position = pos
	vel = Vector2(speed, 0).rotated(dir *  PI/180)
func keep_in_screen():
	pass




func _on_Area2D_body_entered(body):
	if body.get_parent().get_groups().has('asteroids'):
		body.take_damage(damage, vel.normalized())
		explode()
		
		
		
func explode():
	emit_signal("explode", global_position)
	hide()
	vel = Vector2.ZERO
	damage = 0
	$AudioStreamPlayer2D.playing = true
	yield($AudioStreamPlayer2D, "finished")
	queue_free()
	

func _on_VisibilityNotifier2D_screen_exited():
	explode()
