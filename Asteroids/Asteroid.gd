extends RigidBody2D

var max_health
var health
var drop_rate
var damage = 10

var size
var extents
var healthbar

var main 
var game
export var limits = [Vector2.ZERO, Vector2.ZERO]

func _ready():
	add_to_group('Enemies')
	main = get_tree().get_nodes_in_group('Main')[0]
	game = get_tree().get_nodes_in_group('Game')[0]
	contact_monitor = true
	contacts_reported = 1000
	var _connection = connect("body_entered", self, 'body_entered')

	extents = ($Sprite.texture.get_size() / 2) * 0.05
	limits = [
		[int(0-extents.x-5), int(1280+extents.x+5)],
		[int(0-extents.y-5), int(720+extents.y+5)]]


func _physics_process(_delta):
	keep_on_screen()

	if linear_velocity.x > -3 and linear_velocity.x < 3:
		linear_velocity.x = linear_velocity.x * 2
	if linear_velocity.y > -3 and linear_velocity.y < 3:
		linear_velocity.y = linear_velocity.y * 2
		
func keep_on_screen():
	if position.x < limits[0][0]:
		global_transform.origin.x = limits[0][1]
	if position.x > limits[0][1]:
		global_transform.origin.x = limits[0][0]
	if position.y < limits[1][0]:
		global_transform.origin.y = limits[1][1]
	if position.y > limits[1][1]:
		global_transform.origin.y = limits[1][0]

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


func body_entered(_body):
	pass
