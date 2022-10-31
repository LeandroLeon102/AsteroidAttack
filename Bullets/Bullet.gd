extends Area2D

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
	if screen_out_check:
		var _connection = $VisibilityNotifier2D.connect('screen_exited', self, '_on_VisibilityNotifier2D_screen_exited')
	if viewport_out_check:
		var _connection = $VisibilityNotifier2D.connect("viewport_exited", self, '_on_VisibilityNotifier2D_viewport_exited')
	main = get_tree().get_nodes_in_group('Main')
	if main:
		main = main[0]
	add_to_group('Bullet')


func _physics_process(delta):
	global_position += vel * delta


func start_at(pos, dir):
	rotation = dir * PI/180
	global_position =  pos
	vel = Vector2(speed, 0).rotated(dir *  PI/180)


func explode():
	if play_explode_sound:
		if main:
			main.play_sfx(ExplodeSound, global_position, -5, rand_range(.95, 1.05))
	queue_free()


func _ona_VisibilityNotifier2D_screen_exited():
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


func _on_Bullet_area_entered(area):
	if area.is_in_group('Bullet'):
		area.explode()	
		explode()
