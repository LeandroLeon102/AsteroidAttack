extends CanvasLayer

onready var player = get_parent().get_node_or_null('Player')
onready var scorelabel = $PlayerHUD/ScoreLabel
onready var healthbar = $PlayerHUD/healthbar

func _ready():
	pass
	
func _process(delta):
	if get_parent().get_node_or_null('Player') != null:
		healthbar._update(healthbar.position, player.health)
		pass
	else:
		healthbar._update(healthbar.position, 0)
		
func score(amount):
	scorelabel.text = str(amount)
	
