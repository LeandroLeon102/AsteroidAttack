extends Node

export (PackedScene) var RecordEntry
export (PackedScene) var MainMenu
func _ready():
	randomize()
	$Control/Back.grab_focus()
#	for i in range(10):
#		var record = RecordEntry.instance()
#		record.set_number(i+1)
#		record.set_name('leandro')
#		record.set_wave(randi()%30)
#		record.set_score(randi()%9999)
#		$Control/Panel/RecordEntriesContainer/VBoxContainer.add_child(record)

func play_hide():
	$AnimationPlayer.play("hide")
	
func play_show():
	$AnimationPlayer.play("show")

func _on_Button_pressed():
	play_hide()
	var i = get_tree().get_nodes_in_group('MainMenu')
	if not i:
		var m = MainMenu.instance()
		m.play_hidden()
		get_tree().get_nodes_in_group('Scene')[0].add_child(m)

	get_tree().get_nodes_in_group('MainMenu')[0].play_show()
		
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'hide':
		queue_free()
