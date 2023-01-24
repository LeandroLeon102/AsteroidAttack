extends Area2D
export (float, -20 ,10.0) var EXPLOSION_VOLUME
export var damage = 0
export var speed = 0
export (AudioStream) var ExplodeSound

export var screen_out_check = false
export var viewport_out_check = false
export var play_explode_sound = false

var vel = Vector2.ZERO
var rot = 0
var active = true
var main 
func _ready():
	randomize()
	main = get_tree().get_nodes_in_group('Main')
	if main:
		main = main[0]
	add_to_group('Bullet')


func _physics_process(delta):
	global_position += vel * delta
	if active and viewport_out_check:
		if global_position.x > ProjectSettings.get("display/window/size/width") + 50 or global_position.x < 0 - 50 or global_position.y > ProjectSettings.get("display/window/size/height") + 50 or global_position.y < 0 - 50:

			explode()
			active = false

func start_at(pos, dir):
	rotation = dir * PI/180
	global_position =  pos
	vel = Vector2(speed, 0).rotated(dir *  PI/180)


func explode():
	if play_explode_sound:
		if main:
			main.play_sfx(ExplodeSound, global_position, EXPLOSION_VOLUME, rand_range(.95, 1.05))
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():

	if active and screen_out_check:
		explode()
		active = false

func _on_Bullet_body_entered(body):
	body.take_damage(damage)
	if active:
		explode()
		active = false


func _on_Bullet_area_entered(area):
	if area.is_in_group('Bullet'):
		area.explode()	
		explode()


func _on_VisibilityNotifier2D2_screen_exited():
	visible = false


func _on_VisibilityNotifier2D2_screen_entered():
	visible = true
