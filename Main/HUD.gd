extends CanvasLayer

var enemy_number setget set_enemy_number, get_enemy_number
var score setget set_score, get_score
var main

var paused = false

func _ready():
	main = get_tree().get_nodes_in_group('Main')[0]
	$UI/HealthBar.set_max_health(100)


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if is_instance_valid(get_node_or_null('PauseMenu')):
			paused = not paused
			get_tree().set_pause(paused)
			if paused: 
				$UI.visible = false
				$PauseMenu.visible = true
			else:
				$UI.visible = true
				$PauseMenu.visible = false
		
		


func set_wave_number(wave):
	$UI/WaveCount.text = str(wave)
	

func set_enemy_number(number):
	enemy_number = number
	$UI/EnemiesCount.text = str(enemy_number)

func get_enemy_number():
	return enemy_number
	
func set_score(number):
	score = number
	$UI/ScoreCount.text = str(score)

func get_score():
	return score

func toggle_visibility():
	$UI.visible = not $UI.visible
	
func set_player_health(porcentage):
	$UI/HealthBar.set_health(porcentage)
	
func get_player_health():
	return$UI/HealthBar.get_health()

func _on_Button_pressed():
	$UI.visible = false
	$PauseMenu.visible = false
	paused = false
	get_tree().set_pause(false)
	get_parent().end_game()
