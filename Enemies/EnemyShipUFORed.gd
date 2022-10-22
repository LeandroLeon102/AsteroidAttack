extends RigidBody2D
export var max_health = 150

export (PackedScene) var bullets
export var bullet_streams = 4
export var bullet_per_stream = 1
export var rotation_increment = 0
export var rotation_alternate = false
export var bullet_velocity = 0

var shooting = false
var shoots

var health
var drop_rate = .20
var damage = 15

var healthbar

var main
var game

enum {BITRIALS, CIRCLE, ROTFOUR}

func set_atack_mode(mode):
	match mode:
		BITRIALS:
			bullet_streams = 3
			bullet_per_stream = 10
			rotation_increment = 2
			rotation_alternate = true
			$ShootDelay.wait_time = 0.05
			$ShootTimer.wait_time = 1
			bullet_velocity = 700
		CIRCLE:
			bullet_streams = 30
			bullet_per_stream = 1
			rotation_increment = 0
			rotation_alternate = false
			$ShootDelay.wait_time = 0.05
			$ShootTimer.wait_time = 1
			bullet_velocity = 400
		
		ROTFOUR:
			bullet_streams = 4
			bullet_per_stream = 20
			rotation_increment = .1
			rotation_alternate = false
			$ShootDelay.wait_time = 0.1
			$ShootTimer.wait_time = 1
			bullet_velocity = 300
		
			
			

func _physics_process(delta):
	$Position2D.rotation += rotation_increment

func spawn_bullet(bullet, position, direction):
	var b = bullet.instance()
	b.speed = bullet_velocity
	b.start_at(position, direction)

	add_child(b)

func _ready():
	
	main = get_tree().get_nodes_in_group('Main')
	if main:
		main = main[0]
	
	game = get_tree().get_nodes_in_group('Game')
	if game:
		game = game[0]
	set_atack_mode(CIRCLE)

func take_damage(amount):
	health -= amount
	if health <= 0:
		explode()


func explode():
	main.call_deferred('spawn_explosion', global_position)
	game.call_deferred('asteroid_exploded', self)
	healthbar.queue_free()
	queue_free()


func set_initial_health(amount):
	max_health = amount
	health = amount
	healthbar.set_max_health(max_health)
	healthbar.set_health(max_health)


func _on_ShootDelay_timeout():
	if shooting:
		shoot()
	
func shoot():

	for stream in range(1, bullet_streams+1):
		spawn_bullet(bullets, Vector2.ZERO, stream * (360/bullet_streams) + $Position2D.rotation)
	shoots -= 1
	if shoots ==0:
		shooting = false


func _on_ShootTimer_timeout():
	if rotation_alternate:
		rotation_increment *= -1
	shooting = true
	shoots = bullet_per_stream
	$ShootDelay.start()
