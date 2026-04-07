extends TextureRect
#indices of message
#message = 0
#Timestamp = 1
#direction in 'Sent', 'Recieved' = 2
var messages = []
var timer:Timer
var pauseframe:Timer
@export
var fontsize=16
@export 
var senderbubblecolor = '#50757A88'
@export
var recieverbubblecolor = '#26DDFA88'
var lastmessagetime = "0";
signal unread_messages(count:int)
var scrollbar:ScrollBar 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = Timer.new()
	timer.connect("timeout",fetch)
	add_child(timer)
	timer.start(10)
	scrollbar= $Text.get_v_scroll_bar()
#	messages = [["hi","2026-02","Sent"],["hello","2026-02","Recieved"]]
#	displaymessages()


func fetch():
	$MessageSender.getMessages()
	

func _http_request_completed(_result, _response_code, _headers, body):
	if timer.is_stopped():
		timer.start(10)
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	if response == null:
		print(body.get_string_from_utf8())
		return
	if response["message"] == "MessagesRetrieved":
		var newlevel = int(response['Level'])
		if newlevel > globalNode.level: #levels only go up
			globalNode.level = newlevel
			globalNode.levelChanged.emit()
		messages  = response['messages']
		displaymessages()

#[table=1][cell padding=0,0,30,0][table=1][cell bg=#50757A88 padding=3,3,3,3]This is a long message that is gonna take up multiple lines[/cell][/table][/cell]
#[cell padding=25,0,5,0][table=1][cell bg=#26DDFA88 padding=3,3,3,3]This is a long message that is gonna take up multiple lines[/cell][/table][/cell][/table]

func displaymessages(forcescroll = false):
	var text = "[table=1]"
	#set padding size based on text size
	var pad1 = 2*fontsize
	var pad2 = int(fontsize/3.0)
	var pad3 = int(fontsize/6.0)+1
	#check if scrolling needed:
	var doscroll = forcescroll
	if  scrollbar.value + scrollbar.size.y > scrollbar.max_value*.95:
		doscroll = true
#		$Text.scroll_following = true
	var unread = 0
	var lastSentFound=false #flag for making sure last sent still shows up even if server behind
	for message in messages:
		text+='\n'
		if message[2] == 'Recieved':
			text += "[cell padding=0,0,%d,0][table=1][cell bg=%s padding=%d,%d,%d,%d]"%[pad1,recieverbubblecolor, pad3,pad3,pad3,pad3]
			text += escape_bbcode(message[0]) +"[/cell][/table][/cell]"
			if message[1] >lastmessagetime:
				lastmessagetime = message[1]
				if not is_visible_in_tree():
					unread +=1	
		elif  message[2] == 'Sent':
			text += "[cell padding=%d,0,%d,0][table=1][cell bg=%s padding=%d,%d,%d,%d]"%[pad1-pad2,pad2,senderbubblecolor, pad3, pad3, pad3, pad3]
			text += escape_bbcode(message[0]) + "[/cell][/table][/cell]"
			if message[0] == $"../SendButton".lastSent:
				lastSentFound = true
	if not lastSentFound:
		text += "[cell padding=%d,0,%d,0][table=1][cell bg=%s padding=%d,%d,%d,%d]"%[pad1-pad2,pad2,senderbubblecolor, pad3, pad3, pad3, pad3]
		text += escape_bbcode($"../SendButton".lastSent) + "[/cell][/table][/cell]"
	text+="[/table]"
	$Text.text = text	
	if doscroll:
		if get_tree() != null:
			get_tree().create_timer(.01).timeout.connect(scroll_to_bottom)
	if unread > 0:	
		unread_messages.emit(unread)

#this must be scheduled i guess
func scroll_to_bottom():
	scrollbar.set_value(scrollbar.max_value)
	
			
# Returns escaped BBCode that won't be parsed by RichTextLabel as tags.
func escape_bbcode(bbcode_text):
	# We only need to replace opening brackets to prevent tags from being parsed.
	return bbcode_text.replace("[", "[lb]").replace('▒','[char=2592]')
	
