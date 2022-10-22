extends Area2D

export var damage = 0
export var speed = 0
export (AudioStream) var ExplodeSound

var vel = Vector2.ZERO
var rot = 0
var active = true
var main 
func _ready():
	randomize()
#	main = get_tree().get_nodes_in_group('Main')[0]
#	add_to_group('bullet')


func _physics_process(delta):
	global_position += vel * delta


func start_at(pos, dir):
	rotation = dir * PI/180
	global_position =  pos
	vel = Vector2(speed, 0).rotated(dir *  PI/180)


func explode():
#	main.play_sfx(ExplodeSound, global_position, -5, rand_range(.95, 1.05))
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	if active:
		explode()
		active = false


func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	if active:
		explode()
		active = false


func _on_Bullet_body_entered(body):
	body.take_damage(damage)
	if active:
		explode()
		active = false
