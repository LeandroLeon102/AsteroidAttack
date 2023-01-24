extends RigidBody2D

export (float, -20 ,10.0) var SPAWN_VOLUME
export var max_health = 150

export (AudioStream) var SPAWN_SOUND
export (PackedScene) var bullets
export var bullet_streams = 4
export var bullet_per_stream = 1
export var rotation_increment = 0.0
export var rotation_alternate = false
export var bullet_velocity = 0
export (AudioStream) var SHOOT_SOUND

var margin = 50
var target_pos = Vector2.ZERO
var arrived = false

var shooting = false
var shoots

var health = max_health
var drop_rate = .20
var damage = 5

var healthbar

var main
var game

var score = 200

enum {BITRIALS, CIRCLE, ROTFOUR, NEW, RANDOM}

func set_atack_mode(mode):
	match mode:
		BITRIALS:
			bullet_streams = 3
			bullet_per_stream = 10
			rotation_increment = 2
			rotation_alternate = true
			$ShootDelay.wait_time = 0.05
			$ShootTimer.wait_time = 2
			bullet_velocity = 100
		CIRCLE:
			bullet_streams = 20
			bullet_per_stream = 1
			rotation_increment = 0
			rotation_alternate = false
			$ShootDelay.wait_time = 0.05
			$ShootTimer.wait_time = 1
			bullet_velocity = 100
		ROTFOUR:
			bullet_streams = 4
			bullet_per_stream = 30
			rotation_increment = .3
			rotation_alternate = true
			$ShootDelay.wait_time = 0.2
			$ShootTimer.wait_time = 2
			bullet_velocity = 100
		NEW:
			bullet_streams = 2
			bullet_per_stream = 1
			rotation_increment = .3
			rotation_alternate = false
			$ShootDelay.wait_time = 0.3
			$ShootTimer.wait_time = .3
			bullet_velocity = 1000
			
		RANDOM: 
			set_atack_mode(randi() % 4)

func _physics_process(_delta):
	$Position2D.rotation += rotation_increment
	if not arrived: 
		shooting = false
		var direction = (target_pos - global_position).normalized()
		position = Vector2(move_toward(global_position.x, target_pos.x, abs(direction.x)), move_toward(global_position.y, target_pos.y, abs(direction.y)))
		if global_position == target_pos:
			arrived = true

func spawn_bullet(bullet, _position, direction, speed=null):
	var b = bullet.instance()
	b.speed = bullet_velocity
	b.start_at(Vector2.ZERO, direction)
	if speed :
		b.speed = speed
	add_child(b)

func _ready():
	randomize()
	main = get_tree().get_nodes_in_group('Main')
	if main:
		main = main[0]
		main.play_sfx(SPAWN_SOUND, global_position, SPAWN_VOLUME , 1)
	game = get_tree().get_nodes_in_group('Game')
	if game:
		game = game[0]
	set_atack_mode(RANDOM)
	var viewport_size = Vector2(1280, 720)

	
	var rand = Vector2(randi() % int(viewport_size.x - margin * 2 ) + margin, randi() % int(viewport_size.y - margin * 2) + margin)
	target_pos = rand


func take_damage(amount):
	health -= amount
	if health <= 0:
		explode()


func explode():
	if game:
		game.enemy_exploded(self)
	if main:
		main.call_deferred('spawn_explosion', global_position)

		if healthbar:
			healthbar.queue_free()
		queue_free()


func set_initial_health(amount):
	max_health = amount
	health = amount
	if healthbar:
		healthbar.set_max_health(max_health)
		healthbar.set_health(max_health)


func _on_ShootDelay_timeout():
	if shooting:
		shoot()
	
func shoot():
	
	for stream in range(1, bullet_streams+1):
		if main:
			main.play_sfx(SHOOT_SOUND, global_position, -10, 2)
			main.spawn_bullet(bullets, global_position, stream * (360/bullet_streams) + $Position2D.rotation, bullet_velocity)
		else: 
			spawn_bullet(bullets, global_position, stream * (360/bullet_streams) + $Position2D.rotation, bullet_velocity)
	shoots -= 1
	if shoots ==0:
		shooting = false

func _on_ShootTimer_timeout():
	if rotation_alternate:
		rotation_increment *= -1
	shooting = true
	shoots = bullet_per_stream
	$ShootDelay.start()
