extends KinematicBody2D

signal shoot
signal explode
onready var bullet = preload("res://Scenes/PlayerBullet.tscn")
onready var bullet_container = get_parent().get_node("BulletContainer")
onready var animationPlayer = get_node("AnimationPlayer")
onready var explosion = preload('res://Scenes/Explosion.tscn')

export var max_vel_x = Vector2(-200,200)
export var max_vel_y = Vector2(-200,200)
export var max_health = 100

var speed = 10
var vel = Vector2.ZERO
var health = max_health
var rot = 0 
var weapon_type = 'red laser'
var weapon_recoil = 100
var acc = Vector2(0,0)
var extents
var screensize
var collide_damage = 10
var vulnerable = true


func _ready():
	add_to_group('player')
	extents = $Sprite.texture.get_size() / 2
	screensize = get_viewport_rect().size


func _physics_process(delta):
	animationPlayer.play("spaceship rotating")
	$direction.look_at(get_global_mouse_position())
	rot = $direction.rotation * 180/PI
	check_keys(delta)
	var collision = move_and_collide(vel * delta)
	keep_in_screen()
	vel += -vel/50
	vel.x = clamp(vel.x, max_vel_x.x, max_vel_x.y)
	vel.y = clamp(vel.y, max_vel_y.x, max_vel_y.y)
	
	
	if collision:
		if vulnerable:
			var collider = collision.get_collider()
			if collider.get_parent().get_groups().has('asteroids'):

				collider.take_damage(collide_damage, Vector2.ZERO)
				print(collider.max_health)
				take_damage(collider.max_health / 2)
			$invulnerabilityTimer.start()
			vulnerable = false
			
		
	
func check_keys(delta):
	if Input.is_action_just_pressed("ui_left_click"):

		shoot()
			
		
	if Input.is_action_pressed("ui_up"):
		vel.y += -speed
	if Input.is_action_pressed("ui_down"):
		vel.y += speed
	if Input.is_action_pressed("ui_left"):
		vel.x += -speed
	if Input.is_action_pressed("ui_right"):
		vel.x += speed
		
func shoot():

	$AudioStreamPlayer.playing = true
	emit_signal('shoot', position, rot, weapon_type)
	###
	var b = bullet.instance()
	b.start_at(1000, rot, position) 
	b.show_behind_parent = true
	get_parent().add_child(b)
	###
	acc = Vector2(-weapon_recoil, 0).rotated(rot * PI/180)
	vel += acc

func keep_in_screen():
	position.x = clamp(position.x, 0 + extents.x, 1024 - extents.x)
	position.y = clamp(position.y, 0 + extents.y, 640 - extents.y)

func take_damage(amount):
	health += -amount
	if health <= 0:
		explode()

func _on_invulnerabilityTimer_timeout():
	vulnerable = true

func explode():
	emit_signal('explode', position)
	queue_free()
	
	


func _on_shoot_timer_timeout():
	shoot()
