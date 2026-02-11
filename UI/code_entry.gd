extends Panel

func _ready() -> void:
	$Feedback.text = ""

#automatically send message
func _on_text_changed() -> void:
	var text = $TextEdit.text
	if text.ends_with('\n'):
		$TextEdit.text = text.left(text.length()-1)
		_send()


func _send() ->void:
	var correct = ("MU"+globalNode.otherCode.sha1_text().substr(0,3)).to_lower()
	var code = $TextEdit.text.strip_edges().to_lower()
	if code != correct:
		$Feedback.text = "Invalid Registration Number"
		print(code, correct)
	else :
		$Feedback.text = "Validated Successfully"
		if globalNode.level==1:
			$MessageSender.updateLevel(2);
	
func _http_request_completed(_result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	print(body.get_string_from_utf8())

	
