extends Node

var token
var player_id
var board = []
var can_get_board = false


func authenticate_guest_session():
#	if OS.get_name == "Android":
#		player_id = ''
#	else:
	player_id = OS.get_unique_id()
	
	var anim = get_tree().get_nodes_in_group('Main')[0].play_info_animation('pop_in')
	yield(anim, 'animation_finished')

	anim = get_tree().get_nodes_in_group('Main')[0].play_info_animation('authenticating_session')
	var http_request = get_tree().get_nodes_in_group('Main')[0].httpRequest
	var url = 'https://api.lootlocker.io/game/v2/session/guest'
	var header = ['Content-Type: application/json']
	var method = HTTPClient.METHOD_POST
	var request_body
	if player_id != '':
		request_body = {
		'game_key': '77eee908b20748d7971b5fe97118688cc0266156',
		'game_version': '2.0.0',
		'player_identifier': player_id, 
		'development_mode': false
	}
	else:
		request_body = {
		'game_key': '77eee908b20748d7971b5fe97118688cc0266156',
		'game_version': '2.0.0',
		'development_mode': false
	}

	http_request.request(url, header, false, method, to_json(request_body))
	var response = yield(http_request, "request_completed")[3]
	response = JSON.parse(response.get_string_from_utf8()).result

	if response != null:
		if 'session_token' in response:
			token = response['session_token']
			if player_id == '':
				player_id = response['player_identifier']
			anim = get_tree().get_nodes_in_group('Main')[0].play_info_animation('done')
			can_get_board = true
			print(can_get_board)

		else:
			anim = get_tree().get_nodes_in_group('Main')[0].play_info_animation('error')

	else:
		anim = get_tree().get_nodes_in_group('Main')[0].play_info_animation('error')

	
func submit_records(r):
	var http_request = get_tree().get_nodes_in_group('Main')[0].httpRequest
	
	var url = 'https://api.lootlocker.io/game/leaderboards/leaderboard/submit'
	var header = ['Content-Type: application/json', 'x-session-token: %s'% token]
	var method = HTTPClient.METHOD_POST

	var request_data = {
		'score': r['score'],
		'member_id': player_id,
		'metadata':r["metadata"]
	}
	
	http_request.request(url, header, false, method, to_json(request_data))
	yield(http_request, "request_completed")
	
func get_board():
	
	var http_request = get_tree().get_nodes_in_group('Main')[0].httpRequest
	var url = 'https://api.lootlocker.io/game/leaderboards/leaderboard/list?count=100'
	var header = ['Content-Type: application/json', 'x-session-token: %s'% token]
	var method = HTTPClient.METHOD_GET
	var anim = get_tree().get_nodes_in_group('Main')[0].play_info_animation('pop_in')
	yield(anim, 'animation_finished')

	anim = get_tree().get_nodes_in_group('Main')[0].play_info_animation('retrieving_leaderboard')
	
	http_request.request(url, header, false, method)
	
	var response = yield(http_request, "request_completed")[3]
	response = JSON.parse(response.get_string_from_utf8()).result
	if response != null:
		if 'items' in response:
			board = response['items']
			can_get_board = true
			anim = get_tree().get_nodes_in_group('Main')[0].play_info_animation('done')
			
		else:
			can_get_board = false
			anim = get_tree().get_nodes_in_group('Main')[0].play_info_animation('error')

	else:
		can_get_board = false
		anim = get_tree().get_nodes_in_group('Main')[0].play_info_animation('error')

