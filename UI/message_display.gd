extends TextureRect
#keys
#message
#Timestamp
#direction in 'Sent', 'Recieved'
var messages = []
var fontsize=16
@export 
var senderbubblecolor = '#50757A88'
@export
var recieverbubblecolor = '#26DDFA88'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	var timer = Timer.new()
	timer.wait_time = 1.5
	timer.autostart = true
	timer.connect("timeout",fetch)
	add_child(timer)


func fetch():
	$MessageSender.getMessages()
	

func _http_request_completed(_result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	if response["message"] == "MessagesRetrieved":
		messages  = response['messages']
		displaymessages()

#[table=1][cell padding=0,0,30,0][table=1][cell bg=#50757A88 padding=3,3,3,3]This is a long message that is gonna take up multiple lines[/cell][/table][/cell]
#[cell padding=25,0,5,0][table=1][cell bg=#26DDFA88 padding=3,3,3,3]This is a long message that is gonna take up multiple lines[/cell][/table][/cell][/table]

func displaymessages():
	var text = "[table=1]"
	#set padding size based on text size
	var pad1 = 2*fontsize
	var pad2 = int(fontsize/3.0)
	var pad3 = int(fontsize/6.0)+1
	#check if scrolling needed:
	var scrollbar:ScrollBar = $Text.get_v_scroll_bar()
	if scrollbar.value > scrollbar.max_value*.95:
		$Text.scroll_following = true
	else:
		$Text.scroll_following = false
	for message in messages:
		text+='\n'
		if message['direction'] == 'Recieved':
			text += "[cell padding=0,0,%d,0][table=1][cell bg=%s padding=%d,%d,%d,%d]"%[pad1,recieverbubblecolor, pad3,pad3,pad3,pad3]
			text += escape_bbcode(message['mesage']) +"[/cell][/table][/cell]"
		elif  message['direction'] == 'Sent':
			text += "[cell padding=%d,0,%d,0][table=1][cell bg=%s padding=3,3,3,3]"%[pad1-pad2,pad2,senderbubblecolor, pad3, pad3, pad3, pad3]
			text += escape_bbcode(message['mesage']) + "[/cell][/table][/cell][/table]"
	$Text.text = text		
			
# Returns escaped BBCode that won't be parsed by RichTextLabel as tags.
func escape_bbcode(bbcode_text):
	# We only need to replace opening brackets to prevent tags from being parsed.
	return bbcode_text.replace("[", "[lb]")
