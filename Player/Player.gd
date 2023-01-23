extends RigidBody2D

signal GameOver

export (float, -20 ,10.0) var BULLETS_VOLUME
export var god = false
	
export var max_health = 100
export var max_velocity = 10
export var acceleration = 2
export var weapon_recoil = 50

export (AudioStream) var LASER_SOUND
export (AudioStream) var HIT_SOUND
export (PackedScene) var NORMAL_BULLETS 
export (PackedScene) var GOD_BULLLETS 
export (Texture) var GOD_SKIN
export (Texture) var NORMAL_SKIN

var min_pos = Vector2(0, 0)
var max_pos = Vector2(1280, 720)
var extents = 25

var health = max_health
var velocity = Vector2.ZERO
var rot

var camera
var main 
var game 
enum {MOUSE, CONTROLLER}
var AIM_MODE = MOUSE

export var invulnerable = false
export var can_move = true
export var can_shoot = true

func _ready():
	camera = get_tree().get_nodes_in_group('Camera')[0]
	main = get_tree().get_nodes_in_group('Main')[0]
	game = get_tree().get_nodes_in_group('Game')[0]

func _physics_process(_delta):
	if god: 
		$Sprite.texture = GOD_SKIN
	else:
		$Sprite.texture = NORMAL_SKIN
		
	match AIM_MODE:
		MOUSE:
			var controller_aim = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
			if controller_aim != Vector2.ZERO:
				AIM_MODE = CONTROLLER
				$pivot.look_at($pivot.global_position + controller_aim)
			else:
				$pivot.look_at(get_global_mouse_position())
		CONTROLLER:
			if Input.is_action_just_pressed("mouse_activation"):
				AIM_MODE = MOUSE
				$pivot.look_at(get_global_mouse_position())
			else:
				var controller_aim = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
				if controller_aim != Vector2.ZERO:
					AIM_MODE = CONTROLLER
					$pivot.look_at($pivot.global_position + controller_aim)

	rot = $pivot.rotation * 180/PI
	
	var hits = $HitBox.get_overlapping_bodies()
	
	if hits:
		if $InvulnerabilityTimer.time_left == 0:
			$InvulnerabilityTimer.start()
			for b in hits:
				take_damage(int(b.mass/2), b)

func _integrate_forces(state):
	var x_input = 0
	var y_input = 0
	if not god:
		if can_move:
			x_input = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
			y_input = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	else:
		
		x_input = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		y_input = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	var direction = Vector2(x_input, y_input).normalized()
	
	velocity = acceleration * direction
	if not direction and velocity.length() > 1:
		velocity += -velocity * .1
	velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
	velocity.y = clamp(velocity.y, -max_velocity, max_velocity)
	if not god:
		if can_shoot:
			if Input.is_action_just_pressed("shoot"):
				if $ShootDelay.time_left == 0:
					$AutoShootDelay.start()
					$ShootDelay.start()
					velocity += Vector2(-weapon_recoil, 0).rotated(rot * PI/180)
					call_deferred('shoot')
			elif Input.is_action_pressed("shoot"):
				if $AutoShootDelay.time_left == 0:
					$ShootDelay.start()
					$AutoShootDelay.start()
					velocity += Vector2(-weapon_recoil, 0).rotated(rot * PI/180)
					call_deferred('shoot')
			elif AIM_MODE == CONTROLLER:
				var controller_aim = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
				if controller_aim != Vector2.ZERO:
					if $AutoShootDelay.time_left == 0:
						$ShootDelay.start()
						$AutoShootDelay.start()
						velocity += Vector2(-weapon_recoil, 0).rotated(rot * PI/180)
						call_deferred('shoot')
	else:
		if Input.is_action_just_pressed("shoot"):
			call_deferred('shoot')
		elif Input.is_action_pressed("shoot"):
			call_deferred('shoot')
	state.linear_velocity += velocity

func take_damage(amount, _enemy=null):
	if not god:
		if not invulnerable:
			main.play_sfx(HIT_SOUND, global_position, 2, rand_range(0.9, 1.1))
			$Hurt.reset_all()
			$Hurt.interpolate_property($Sprite, 'modulate', Color(4,2,2,1), Color(1,1,1,1), $InvulnerabilityTimer.wait_time, Tween.TRANS_QUAD)
			$Hurt.start()
			health -= amount
			if health <= 0:
				emit_signal('GameOver')
				explode()

func increase_health(amount):
	health += amount
	if health >= max_health:
		health = max_health

func explode():
	main.spawn_explosion(global_position)
	call_deferred('free')

func shoot():

	if god:
		main.play_sfx(LASER_SOUND, global_position, BULLETS_VOLUME, 1.5)
		main.spawn_bullet(GOD_BULLLETS, $pivot/Position2D.global_position, $pivot.rotation * 180/PI)
		
	else:
		main.play_sfx(LASER_SOUND, global_position, BULLETS_VOLUME, rand_range(0.9, 1.1))
		main.spawn_bullet(NORMAL_BULLETS, $pivot/Position2D.global_position, $pivot.rotation * 180/PI)
	
func _on_Hurt_tween_completed(_object, _key):
	$Hurt.stop_all()

func block_actions(value:bool):
	if value:

		can_move = false
		can_shoot = false
	else:

		can_move = true
		can_shoot = true

func vulnerable(value:bool):
	if value:
		invulnerable = true
	else: 
		invulnerable = false
