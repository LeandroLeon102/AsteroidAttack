extends KinematicBody2D

signal explode

onready var Healthbar = preload("res://Scenes/healthbar.tscn")

export var max_vel = 350
export var max_init_vel = 250
export var min_init_vel = 50
export var max_rot_speed = 1.5
export var min_rot_speed = -1.5
export var bounce = 1.1



var health_type = {'big':100,
				'med':60,
				'small':30,
				'tiny':10}

var exploding = false
var health 
var max_health

var rot_speed = 0
var texture_size
var screensize
var extents
var healthbar

var vel = Vector2(0,0)
var textures = {'big':["res://Resources/Images/spaceshooter/PNG/Meteors/meteorBrown_big1.png",
						"res://Resources/Images/spaceshooter/PNG/Meteors/meteorBrown_big2.png",
						"res://Resources/Images/spaceshooter/PNG/Meteors/meteorBrown_big3.png",
						"res://Resources/Images/spaceshooter/PNG/Meteors/meteorBrown_big4.png",
						"res://Resources/Images/spaceshooter/PNG/Meteors/meteorGrey_big1.png",
						"res://Resources/Images/spaceshooter/PNG/Meteors/meteorGrey_big2.png",
						"res://Resources/Images/spaceshooter/PNG/Meteors/meteorGrey_big3.png",
						"res://Resources/Images/spaceshooter/PNG/Meteors/meteorGrey_big4.png"],
				'med':["res://Resources/Images/spaceshooter/PNG/Meteors/meteorBrown_med1.png",
						"res://Resources/Images/spaceshooter/PNG/Meteors/meteorBrown_med3.png",
						"res://Resources/Images/spaceshooter/PNG/Meteors/meteorGrey_med1.png",
						"res://Resources/Images/spaceshooter/PNG/Meteors/meteorGrey_med2.png"],
				'small':["res://Resources/Images/spaceshooter/PNG/Meteors/meteorBrown_small1.png",
						"res://Resources/Images/spaceshooter/PNG/Meteors/meteorBrown_small2.png",
						"res://Resources/Images/spaceshooter/PNG/Meteors/meteorGrey_small1.png",
						"res://Resources/Images/spaceshooter/PNG/Meteors/meteorGrey_small2.png"],
				'tiny':["res://Resources/Images/spaceshooter/PNG/Meteors/meteorBrown_tiny1.png",
					"res://Resources/Images/spaceshooter/PNG/Meteors/meteorBrown_tiny2.png",
					"res://Resources/Images/spaceshooter/PNG/Meteors/meteorGrey_tiny1.png",
					"res://Resources/Images/spaceshooter/PNG/Meteors/meteorGrey_tiny2.png"]}
func _ready():
	randomize()
	screensize = get_viewport_rect().size

	

func init(size, pos, init_vel):
	max_health = health_type[size]
	health = max_health
	var texture_name = textures[size][randi()%textures[size].size()]
	texture_size = size
	$Sprite.texture = load(texture_name)
	extents = $Sprite.texture.get_size() / 2
	position = pos
	if init_vel.length() > 0:
		vel = init_vel
	else:
		vel = Vector2(rand_range(min_init_vel, max_init_vel), 0).rotated(rand_range(0,2* PI))
	var collisionShape = CircleShape2D.new()
	collisionShape.set_radius(min($Sprite.texture.get_width()/2, $Sprite.texture.get_height()/2) * .9)
	$CollisionShape2D.set_shape(collisionShape)
	rot_speed = rand_range(min_rot_speed, max_rot_speed)
	
func _physics_process(delta):
	vel.y = clamp(vel.y, -max_vel, max_vel)
	vel.x = clamp(vel.x, -max_vel, max_vel)
	rotation += rot_speed * delta
	var collision = move_and_collide(vel * delta)
	
	if collision:
		vel = collision.normal * collision.get_collider().vel.length() * bounce
		get_parent().get_node("Puff").global_position = collision.position
		get_parent().get_node("Puff").emitting = true
		
	if position.x > 1088:
		position.x = -64
	if position.x < -64:
		position.x = 1088
	if position.y > 704:
		position.y = -64
	if position.y < -64:
		position.y = 704

func take_damage(amount, hit_vel):
	health += -amount
	$asteroid_explode.playing = true
	if health <= 0:
		explode(hit_vel)

func explode(hit_vel):
	$CollisionShape2D.disabled = true
	if not exploding:
		exploding = true
		
		emit_signal('explode', texture_size, position, vel, hit_vel)
		$asteroid_explode.playing = true
		get_parent().hide()
		yield($asteroid_explode, "finished")
		get_parent().queue_free()
