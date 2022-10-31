extends Node2D

var target = null

var healthbar_width = 1

var max_health
var health 

func _ready():

	set_physics_process(true)
	
func _physics_process(_delta):
	if target:
		if target.health < max_health:
			show()
		else:
			hide()
		global_position = Vector2(target.global_position.x, target.global_position.y + (target.extents.y) *1.4 + 10)

		set_health(target.health)

func set_max_health(amount):
	max_health = amount
	health = float(max_health)

	
func set_health(amount):
	health = float(healthbar_width) / float(max_health) * float(amount)
	health = clamp(health, 0, 1000)
	$Health.scale.x = health
	if health <= .2:
		$Health.modulate = Color(255, 0, 0)
	elif health <= .5:
		$Health.modulate = Color(255, 150, 0)
	else:
		$Health.modulate = Color(1, 255, 1)
 
func get_health():
	return health
