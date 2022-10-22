extends KinematicBody2D

signal explode

onready var HealthBar = preload("res://HealthBar/HealthBar.tscn")


export var max_vel = 350
export var max_init_vel = 250
export var min_init_vel = 50
export var max_rot_speed = 1.5
export var min_rot_speed = -1.5
export var bounce = 1.1
export var minVel = 0



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

var velocity = Vector2(0,0)
var textures = {'big':["res://Images/spaceshooter/PNG/Meteors/meteorBrown_big1.png",
						"res://Images/spaceshooter/PNG/Meteors/meteorBrown_big2.png",
						"res://Images/spaceshooter/PNG/Meteors/meteorBrown_big3.png",
						"res://Images/spaceshooter/PNG/Meteors/meteorBrown_big4.png",
						"res://Images/spaceshooter/PNG/Meteors/meteorGrey_big1.png",
						"res://Images/spaceshooter/PNG/Meteors/meteorGrey_big2.png",
						"res://Images/spaceshooter/PNG/Meteors/meteorGrey_big3.png",
						"res://Images/spaceshooter/PNG/Meteors/meteorGrey_big4.png"],
				'med':["res://Images/spaceshooter/PNG/Meteors/meteorBrown_med1.png",
						"res://Images/spaceshooter/PNG/Meteors/meteorBrown_med3.png",
						"res://Images/spaceshooter/PNG/Meteors/meteorGrey_med1.png",
						"res://Images/spaceshooter/PNG/Meteors/meteorGrey_med2.png"],
				'small':["res://Images/spaceshooter/PNG/Meteors/meteorBrown_small1.png",
						"res://Images/spaceshooter/PNG/Meteors/meteorBrown_small2.png",
						"res://Images/spaceshooter/PNG/Meteors/meteorGrey_small1.png",
						"res://Images/spaceshooter/PNG/Meteors/meteorGrey_small2.png"],
				'tiny':["res://Images/spaceshooter/PNG/Meteors/meteorBrown_tiny1.png",
					"res://Images/spaceshooter/PNG/Meteors/meteorBrown_tiny2.png",
					"res://Images/spaceshooter/PNG/Meteors/meteorGrey_tiny1.png",
					"res://Images/spaceshooter/PNG/Meteors/meteorGrey_tiny2.png"]}
func _ready():
	randomize()
	screensize = get_viewport_rect().size

	

func init(size, pos, init_vel):
	max_health = health_type[size]
	health = max_health -1
	var texture_name = textures[size][randi()%textures[size].size()]
	texture_size = size
	$Sprite.texture = load(texture_name)
	extents = $Sprite.texture.get_size() / 2
	global_position = pos
	if init_vel.length() > 0:
		velocity = init_vel
	else:
		velocity = Vector2(rand_range(min_init_vel, max_init_vel), 0).rotated(rand_range(0,2* PI))
	var collisionShape = CircleShape2D.new()
	collisionShape.set_radius(min($Sprite.texture.get_width()/2, $Sprite.texture.get_height()/2) * .9)
	$CollisionShape2D.set_shape(collisionShape)
	rot_speed = rand_range(min_rot_speed, max_rot_speed)
	
	healthbar = HealthBar.instance()
	get_tree().get_nodes_in_group('HealthbarContainer')[0].add_child(healthbar)
	
	
func _physics_process(delta):
	velocity.y = clamp(velocity.y, -max_vel, max_vel)
	velocity.x = clamp(velocity.x, -max_vel, max_vel)
	rotation += rot_speed * delta
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity = collision.normal * collision.get_collider().velocity.length() * bounce
	#	get_parent().get_node("Puff").global_position = collision.position
	#	get_parent().get_node("Puff").emitting = true
		
	if position.x > 1280 + extents.x:
		position.x = 0 - extents.x
	if position.x < 0 - extents.x:
		position.x = 1280 + extents.x
	if position.y > 720 + extents.y:
		position.y = 0 - extents.y
	if position.y < 0 - extents.y:
		position.y = 720 - extents.y
	
	if velocity.x < 0:
		if velocity.x > -minVel:
			velocity.x = -minVel
	if velocity.x > 0:
		if velocity.x < minVel:
			velocity.x = minVel
			
	if velocity.y < 0:
		if velocity.y > -minVel:
			velocity.y = -minVel
	if velocity.y > 0:
		if velocity.y < minVel:
			velocity.y = minVel
	update_healthbar()
	
func take_damage(amount, hit_vel):
	health += -amount
	if health <= 0:
		explode(hit_vel)

func explode(hit_vel=0):
	get_tree().get_nodes_in_group('AsteroidAtack')[0].Spawn_Explosion(global_position)
	healthbar.queue_free()
	queue_free()
	
	
func update_healthbar():
	healthbar.set_max_health(max_health)
	healthbar._update(Vector2(global_position.x, global_position.y + extents.y *1.5 + 10), health)
	if health < max_health:
		healthbar.show()
	else:
		healthbar.hide()
		
