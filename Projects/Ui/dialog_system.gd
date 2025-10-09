extends CanvasLayer

enum CHARACTERS {Ashes, Mara, Advisor, Jakat}

var figures_image: Dictionary = {
	CHARACTERS.Ashes: load("res://Assets/UI/Dialog panel/Characters/Ashes.png"),
	CHARACTERS.Advisor: load("res://Assets/UI/Dialog panel/Characters/Advisor.png"),
	CHARACTERS.Mara : load("res://Assets/UI/Dialog panel/Characters/Mara.png"),
	CHARACTERS.Jakat : null
}
var figures_name: Dictionary = {
	CHARACTERS.Ashes: "Ashes",
	CHARACTERS.Advisor: "Asvisor",
	CHARACTERS.Mara : "Mara",
	CHARACTERS.Jakat : "Jakat"
}
var text_queue: Array[DialogText]
var skipable: bool
var duration: float

@onready var text_obj: RichTextLabel = $Panel/Text
@onready var skip_text_obj: RichTextLabel = $Panel/SkipText
@onready var figure_name: Label = $Panel/Name
@onready var image: TextureProgressBar = $Panel/image
@onready var timer: Timer = $Timer
@onready var panel: Panel = $Panel

signal dialog_finished()


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
		panel.hide()
		emit_signal("dialog_finished")
		return
	var dt: DialogText = text_queue.pop_front()
	text_obj.text = dt.text
	figure_name.text = figures_name[dt.character]
	image.texture_progress = figures_image[dt.character]
	panel.show()


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
