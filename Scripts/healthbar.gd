extends Node2D

var healthbar_width = 1

var max_health
var health 

func _ready():
	set_max_health(100)
	set_health(100)
	
func _update(pos, health):
	position = pos
	set_health(float(health))
	
func set_max_health(amount):
	max_health = amount
	health = float(max_health)
	
func set_health(porcentage):
	health = float(healthbar_width) / float(max_health) * float(porcentage)
	$Health.scale.x = health
	if health <= .2:
		$Health.modulate = Color(255, 0, 0)
	elif health <= .5:
		$Health.modulate = Color(255, 150, 0)
	else:
		$Health.modulate = Color(1, 255, 1)
 
