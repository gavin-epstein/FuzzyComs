extends SubScreen

var angle = 0;
var mouseDown=false
signal dialMoved(val)
var allowed=false

#allowed stops the click of getting into the window from counting for the dial. 
func notify_focus_changed(_state:bool)->void:
	allowed = false

func _input(event: InputEvent) -> void:
	if not allowed:
		allowed = true
		return
	if event is InputEventMouseButton:
		mouseDown = event.pressed
	if event is InputEventMouse and mouseDown:
		var inangle = (event.position - Vector2(256,256)).angle()
		if inangle <0 and inangle > -PI:
			angle = inangle
			dialMoved.emit(angle)
			set_text(angle)

func set_text(val):
	var freq = map(angle,-PI,0, 80,120)
	$Panel/Panel/FreqDisplay.text = str(int(freq)) + " MHz" 
	#$Panel/Panel2.rotation = angle
	
static func map(v:float,a1,a2,b1,b2):
	var r= (v-a1)/(a2-a1)
	return b1+(b2-b1)*r
	
		
