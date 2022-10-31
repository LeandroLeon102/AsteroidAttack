extends Node

var focused

func _ready():
	focused = true

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and focused:
		$Control/VBoxContainer/Exit.grab_focus()
	

func play_hide():
	$AnimationPlayer.play("hide")
	focused = false
	
func play_show():
	$AnimationPlayer.play("show")
	focused = true

func _on_Play_pressed():
	get_tree().get_nodes_in_group('Main')[0].start_new_game()
	

func _on_Settings_pressed():
	get_tree().get_nodes_in_group('Main')[0].settings_menu()
	
	
func _on_Exit_pressed():
	get_tree().quit()


func _on_Records_pressed():
	pass


func _on_Information_pressed():
	get_tree().get_nodes_in_group('Main')[0].information_screen()


func _on_Leaderboard_pressed():
	get_tree().get_nodes_in_group('Main')[0].records_screen()
