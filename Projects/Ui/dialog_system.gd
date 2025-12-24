extends CanvasLayer

enum CHARACTERS {
	Ashes,
	Mara,
	Advisor,
	Jakat,
	Aros
}

const character_names = {
	CHARACTERS.Ashes: "CHARACTER_ASHES",
	CHARACTERS.Mara: "CHARACTER_MARA",
	CHARACTERS.Advisor: "CHARACTER_MOG",
	CHARACTERS.Jakat: "CHARACTER_JAKAT",
	CHARACTERS.Aros: "CHARACTER_AROS"
}

const game_over_dialog_texts: Array[String] = [
	"GAME_OVER_TEXT_1",
	"GAME_OVER_TEXT_2",
	"GAME_OVER_TEXT_3",
	"GAME_OVER_TEXT_4",
	"GAME_OVER_TEXT_5"
]

@onready var character_sprites = {
	CHARACTERS.Ashes: preload("res://Assets/UI/Dialog panel/Characters/Ashes.png"),
	CHARACTERS.Mara: preload("res://Assets/UI/Dialog panel/Characters/Mara.png"),
	CHARACTERS.Advisor: preload("res://Assets/UI/Dialog panel/Characters/Advisor.png"),
	CHARACTERS.Jakat: null,
	CHARACTERS.Aros: null
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
	skip_text_obj.text = tr("SPACE")
	
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
		disappear()
		emit_signal("dialog_finished")
		return
	var dt: DialogText = text_queue.pop_front()
	text_obj.text = TranslationServer.translate(dt.text)
	name_obj.text = TranslationServer.translate(character_names[dt.character])
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

func disappear():
	panel.hide()
	skip_text_obj.hide()
