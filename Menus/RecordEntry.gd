extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Number.rect_min_size = Vector2(100, 0)
	$Name.rect_min_size = Vector2(350, 0)
	$Wave.rect_min_size = Vector2(150, 0)
	$Score.rect_min_size = Vector2(344, 0)

func set_number(number):
	$Number.text = str(number)
	
func set_name(name):
	$Name.text = str(name)
	
func set_wave(wave):
	$Wave.text = str(wave)
	
func set_score(score):
	$Score.text = str(score)
