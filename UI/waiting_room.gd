extends Control
var mainmenu = preload("res://Scenes/MainMenu.tscn");
var ship = preload("res://Scenes/ship.tscn");
var station = preload("res://Scenes/station.tscn");

var bothconnected = false
func _ready() -> void:
	query()
	var timer = Timer.new()
	timer.wait_time = 5.0
	timer.autostart = true
	timer.connect("timeout",query)
	add_child(timer)


func query()->void:
	if !bothconnected:
		var error = $MessageSender.joinExisting(globalNode.code)
		if error != OK:
			push_warning("Disconnected")

func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	if response["message"] == "Game Joined":
		var otherjoined = response["partnerConnected"]
		if otherjoined:
			globalNode.otherCode = response["partnerCode"]
			$ButtonLabel.text = "Proceed"
			bothconnected = true;
			
				
				
				
			
	


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://Scenes/MainMenu.tscn"));


func _on_proceed_button_pressed() -> void:
	if bothconnected:
		if globalNode.playerType == "Ship":
			get_tree().change_scene_to_packed(ship);
		elif  globalNode.playerType == "Station":
			get_tree().change_scene_to_packed(station);
