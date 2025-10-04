extends CanvasLayer

enum CHARACTERS {Ashes, Mara, Advisor}

var text_queue: Array[DialogText]
var skipable: bool
var duration: float

@onready var text_obj: RichTextLabel = $Text
@onready var skip_text_obj: RichTextLabel = $SkipText
@onready var timer: Timer = $Timer

signal dialog_finished()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func start_dialog(texts: Array[DialogText], skipable: bool = false, duration: float = 0.0) -> void:
	text_queue = texts
	self.duration = duration
	self.skipable = skipable
	skip_text_obj.visible = skipable
	_next_dialog()

func _next_dialog() -> void:
	if !skipable:
		timer.wait_time = duration
		timer.start()
	else:
		timer.stop()
	if text_queue.size() == 0:
		text_obj.hide()
		skip_text_obj.hide()
		emit_signal("dialog_finished")
		return
	var dt: DialogText = text_queue.pop_front()
	text_obj.text = dt.text
	text_obj.show()


func _process(delta: float) -> void:
	if skipable and Input.is_action_just_pressed("next"):
		_next_dialog()

class DialogText:
	var text: String
	var character: CHARACTERS
	func _init(t: String, ch: CHARACTERS) -> void:
		text = t
		character = ch


func _on_timer_timeout() -> void:
	_next_dialog()
