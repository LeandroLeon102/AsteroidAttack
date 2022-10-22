extends CanvasLayer

var enemy_number setget set_enemy_number, get_enemy_number
var score setget set_score, get_score
var main
func _ready():
	main = get_tree().get_nodes_in_group('Main')[0]
	$Node2D/HealthBar.set_max_health(100)



func set_wave_number(wave):
	$Node2D/WaveCount.text = str(wave)
	

func set_enemy_number(number):
	enemy_number = number
	$Node2D/EnemiesCount.text = str(enemy_number)

func get_enemy_number():
	return enemy_number
	
func set_score(number):
	score = number
	$Node2D/ScoreCount.text = str(score)

func get_score():
	return score

func toggle_visibility():
	$Node2D.visible = not $Node2D.visible
	
func set_player_health(porcentage):
	$Node2D/HealthBar.set_health(porcentage)
	
func get_player_health():
	return$Node2D/HealthBar.get_health()

