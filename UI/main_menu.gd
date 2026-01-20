extends Control
var waitingroom = preload("res://Scenes/WaitingRoom.tscn")
var gameCreated=false
@onready var giveCodeText = $GiveCode
var code
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_new_game_button_pressed() -> void:
	if !gameCreated:
		gameCreated = true
		giveCodeText.text = "Creating Game ..."
		var error = $MessageSender.setupConnection()
		if error != OK:
			giveCodeText.text = "Connection Failed. Check your internet?"
			gameCreated = false
func _on_join_game_button_pressed() -> void:
	if $CodeEntry.text == "":
		$JoinGameFeedback.text = "You must enter a code to join a game"
	else:
		$JoinGameFeedback.text = "Joining Game..."
		code  = $CodeEntry.text
		for c in [","," ",";","-","'",".",'"']:
			code = code.replace(c, "")
		code = code.strip_edges()
		var error = $MessageSender.joinExisting(code)
		if error != OK:
			$JoinGameFeedback.text  = "Connection Failed. Check the code is correct?"


func _http_request_completed(_result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	if response["message"] == "Connection Created":
		giveCodeText.text ='''Your partner's code is: '''+response["StationPlayer"]+'''
They will need this to join your game.

Your code is: '''+response["ShipPlayer"]+'''
Write this down in case you disconnect.''' 
		$CodeEntry.text = response["ShipPlayer"]
	elif response["message"] == "Game Joined":
		globalNode.code = code
		globalNode.playerType = response["playerType"]
		globalNode.level = response['Level']
		get_tree().change_scene_to_packed(waitingroom)
	elif response["message"] == "No Game Found":
		$JoinGameFeedback.text  = "No such game exists. Double check your game code?"
