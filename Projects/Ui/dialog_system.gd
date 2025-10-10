extends CanvasLayer

enum CHARACTERS {Ashes, Mara, Advisor, Jakat}

const character_names = {
	CHARACTERS.Ashes: "Ashes",
	CHARACTERS.Mara: "Mara",
	CHARACTERS.Advisor: "Advisor",
	CHARACTERS.Jakat: "Jakat"
}

@onready var character_sprites = {
	CHARACTERS.Ashes: preload("res://Assets/UI/Dialog Panel/Characters/Ashes.png"),
	CHARACTERS.Mara: preload("res://Assets/UI/Dialog Panel/Characters/Mara.png"),
	CHARACTERS.Advisor: preload("res://Assets/UI/Dialog Panel/Characters/Advisor.png"),
	CHARACTERS.Jakat: null
}


var text_queue: Array[DialogText]
var skipable: bool
var duration: float

@onready var text_obj: Label = $Panel/Text
@onready var name_obj: Label = $Panel/Name
@onready var avatar_obj: TextureRect = $Panel/Avatar
@onready var skip_text_obj: RichTextLabel = $Panel/Skip
@onready var panel: TextureRect = $Panel
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
		panel.hide()
		skip_text_obj.hide()
		emit_signal("dialog_finished")
		return
	var dt: DialogText = text_queue.pop_front()
	text_obj.text = dt.text
	name_obj.text = character_names[dt.character]
	if character_sprites[dt.character] != null:
		avatar_obj.texture = character_sprites[dt.character]
		avatar_obj.show()
	else:
		avatar_obj.hide()
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
