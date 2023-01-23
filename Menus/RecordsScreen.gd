extends Node

export (PackedScene) var RecordEntry
export (PackedScene) var MainMenu
func _ready():
	randomize()
	$Control/Back.grab_focus()

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
		get_tree().get_nodes_in_group('Main')[0].restore_music_volume()

	get_tree().get_nodes_in_group('MainMenu')[0].play_show()
		
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'hide':
		queue_free()

func update_records(records, new_record=null):
	var record_copy = records.duplicate()
	var pos = 1

	record_copy.resize(100)
	for record in record_copy:
		if record != null:
			var r = RecordEntry.instance()
			var m  = record['metadata']
			m = JSON.parse(m).get_result()
			r.set_number(pos)
			r.set_score(record['score'])
			r.set_name(m['name'])
			r.set_wave(m['wave'])
			
			pos += 1
			if new_record != null:
				if record == new_record:
					r.iluminate()
					
			$Control/Panel/RecordEntriesContainer/VBoxContainer.add_child(r)
			if new_record != null:
				if record == new_record:
					yield(get_tree(), "idle_frame")
					$Control/Panel/RecordEntriesContainer.ensure_control_visible(r)
					
		else:
			var r = RecordEntry.instance()
			r.set_number(pos)
			r.set_name(' - - - ')
			r.set_wave(' - - ')
			r.set_score(' - - - - ')
			pos += 1
			$Control/Panel/RecordEntriesContainer/VBoxContainer.add_child(r)
			
	if records.find(new_record) > 100:
		var r = RecordEntry.instance()
		var m  = new_record['metadata']
		m = JSON.parse(m).get_result()
		r.set_number(' - - ')
		r.set_score(new_record['score'])
		r.set_name(m['name'])
		r.set_wave(m['wave'])
		
		if new_record != null:
			r.iluminate()
				
		$Control/Panel/RecordEntriesContainer/VBoxContainer.add_child(r)
		if new_record != null:
			yield(get_tree(), "idle_frame")
			$Control/Panel/RecordEntriesContainer.ensure_control_visible(r)
