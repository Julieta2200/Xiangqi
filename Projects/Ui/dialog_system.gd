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

@onready var option_scene: PackedScene = preload("res://Projects/Ui/option.tscn")

var text_queue: Array[DialogText]
var skipable: bool
var is_decision: bool = false

@onready var text_obj: Label = $Panel/Text
@onready var name_obj: Label = $Panel/Name
@onready var avatar_obj: TextureRect = $Panel/Avatar
@onready var skip_text_obj: RichTextLabel = $Panel/Skip
@onready var panel: Panel = $Panel
@onready var options_container: VBoxContainer = $Panel/Options

signal dialog_finished()
signal decision_made(option: Dictionary)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skip_text_obj.text = tr("SPACE")
	
func start_dialog(texts: Array[DialogText], skipable: bool = false) -> void:
	text_queue = texts
	self.skipable = skipable
	skip_text_obj.visible = skipable
	_next_dialog()

func _next_dialog() -> void:
	if text_queue.size() == 0:
		disappear()
		emit_signal("dialog_finished")
		return
	var dt: DialogText = text_queue.pop_front()
	if dt.options.size() > 0:
		is_decision = true
		options_container.show()
		text_obj.hide()
		skip_text_obj.hide()
		for option in dt.options:
			var option_node = option_scene.instantiate()
			option_node.text = TranslationServer.translate(option.text)
			option_node.connect("pressed", _on_option_pressed.bind(option))
			options_container.add_child(option_node)
	text_obj.text = TranslationServer.translate(dt.text)
	name_obj.text = TranslationServer.translate(character_names[dt.character])
	if character_sprites[dt.character] != null:
		avatar_obj.texture = character_sprites[dt.character]
		avatar_obj.show()
	else:
		avatar_obj.hide()
	panel.show()


func _process(delta: float) -> void:
	if skipable and !is_decision and Input.is_action_just_pressed("next"):
		_next_dialog()

class DialogText:
	var text: String
	var character: CHARACTERS
	var options: Array[Dictionary]
	func _init(t: String, ch: CHARACTERS, opts: Array[Dictionary] = []) -> void:
		text = t
		character = ch
		options = opts

func disappear():
	panel.hide()
	skip_text_obj.hide()

func _on_option_pressed(option: Dictionary) -> void:
	for option_node in options_container.get_children():
		option_node.queue_free()
	is_decision = false
	options_container.hide()
	text_obj.show()
	skip_text_obj.show()
	emit_signal("decision_made", option)
	_next_dialog()
