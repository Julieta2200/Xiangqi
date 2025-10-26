extends Node2D

@onready var lls: Control = $CanvasLayer/LLs
@onready var hls: Control = $CanvasLayer/HLs

@onready var hint_bubbles: Array[HintBubble] = [
	$CanvasLayer/Hints/HintBubble,
	$CanvasLayer/Hints/HintBubble2,
]
@onready var play_button: Button = $CanvasLayer/Play
@onready var back_button: Button = $CanvasLayer/Back

var _hint_index: int = 0


var level_1_dialog: Array[DialogSystem.DialogText] = [
	DialogSystem.DialogText.new("Ashes, you will meet your friend here.", DialogSystem.CHARACTERS.Jakat),
	DialogSystem.DialogText.new("I don’t have any.", DialogSystem.CHARACTERS.Ashes),
	DialogSystem.DialogText.new("Driven by revenge, you’ll get what you give, Karma will catch you.", DialogSystem.CHARACTERS.Jakat),
	DialogSystem.DialogText.new("Don’t forget who you’re speaking to, just stop talking and lend me your powers.", DialogSystem.CHARACTERS.Ashes),
	DialogSystem.DialogText.new("Time is ticking…", DialogSystem.CHARACTERS.Jakat),
]

var level_1_bonus_dialog: Array[DialogSystem.DialogText] = [
	DialogSystem.DialogText.new("You're going out of our path, aren't you?", DialogSystem.CHARACTERS.Jakat),
	DialogSystem.DialogText.new("I have my own path.", DialogSystem.CHARACTERS.Ashes),
	DialogSystem.DialogText.new("You're on your own here, Ashes.", DialogSystem.CHARACTERS.Jakat),
	DialogSystem.DialogText.new("Such a tragedy...", DialogSystem.CHARACTERS.Ashes)
]

var level_2_dialog: Array[DialogSystem.DialogText] = [
	DialogSystem.DialogText.new("Jakat, I need more power.", DialogSystem.CHARACTERS.Ashes),
	DialogSystem.DialogText.new("So be it. But don't forget our deal.", DialogSystem.CHARACTERS.Jakat),
	DialogSystem.DialogText.new("I'll do what I have to do.", DialogSystem.CHARACTERS.Ashes),
	DialogSystem.DialogText.new("Karma moves in two directions...", DialogSystem.CHARACTERS.Jakat),
]

var dialogs: Dictionary = {
	"1": level_1_dialog,
	"1_bonus": level_1_bonus_dialog,
	"2": level_2_dialog,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_lls()
	fill_hls()
	if GameState.state["first_karma_table_run"]:
		run_hint_system()
		return

	run_dialog()


func run_dialog() -> void:
	if dialogs.has(GameState.current_level_info["name"]):
		var dialog: Array[DialogSystem.DialogText] = dialogs[GameState.current_level_info["name"]]
		if dialog.size() > 0:
			DialogSystem.start_dialog(dialog, true)

func fill_lls() -> void:
	for ll_card in lls.get_children():
		if ll_card is not Label:
			ll_card.active = GameState.state.ll_cards.has(ll_card.special)
			ll_card.selected = GameState.state.lls.has(ll_card.special)
			if ll_card.selected:
				ll_card.on_click_full.connect(_dequip_ll)
			else:
				ll_card.on_click_full.connect(_equip_ll)

func fill_hls() -> void:
	for hl_card in hls.get_children():
		if hl_card is not Label:
			hl_card.active = GameState.state.hl_cards.has(hl_card.special)
			hl_card.selected = GameState.state.hl == hl_card.special
			if hl_card.selected:
				hl_card.on_click_full.connect(_dequip_hl)
			else:
				hl_card.on_click_full.connect(_equip_hl)

func _equip_ll(s: SpecialCard):
	s.selected = true
	GameState.state.lls.append(s.special)
	s.on_click_full.disconnect(_equip_ll)
	s.on_click_full.connect(_dequip_ll)

func _dequip_ll(s: SpecialCard):
	s.selected = false
	GameState.state.lls = GameState.state.lls.filter(func(ll): return ll != s.special)
	s.on_click_full.disconnect(_dequip_ll)
	s.on_click_full.connect(_equip_ll)

func _equip_hl(s: SpecialCard):
	s.selected = true
	GameState.state.hl = s.special
	s.on_click_full.disconnect(_equip_hl)
	s.on_click_full.connect(_dequip_hl)

func _dequip_hl(s: SpecialCard):
	s.selected = false
	GameState.state.hl = -1
	s.on_click_full.disconnect(_dequip_hl)
	s.on_click_full.connect(_equip_hl)

func _on_back_pressed() -> void:
	GameState.save_game()
	get_tree().change_scene_to_file("res://Projects/Levels/Overworld/overworld.tscn")

func _on_play_pressed() -> void:
	if GameState.current_level_info["scene"]:
		GameState.save_game()
		get_tree().change_scene_to_packed(GameState.current_level_info["scene"])

func run_hint_system() -> void:
	play_button.hide()
	back_button.hide()
	if _hint_index >= hint_bubbles.size():
		GameState.state["first_karma_table_run"] = false
		GameState.save_game()
		play_button.show()
		back_button.show()
		run_dialog()
		return
	hint_bubbles[_hint_index].show()
	_hint_index += 1


func _on_back_mouse_entered() -> void:
	$CanvasLayer/Back/arrow.text = "> >"

func _on_back_mouse_exited() -> void:
	$CanvasLayer/Back/arrow.text = ">>"

func _on_play_mouse_entered() -> void:
	$CanvasLayer/Play/arrow.text = "> >"

func _on_play_mouse_exited() -> void:
	$CanvasLayer/Play/arrow.text = ">>"

func _on_play_button_down() -> void:
	$CanvasLayer/Play/arrow.add_theme_color_override("font_color", Color(0.49, 0.349, 0, 1))

func _on_back_button_down() -> void:
	$CanvasLayer/Back/arrow.add_theme_color_override("font_color", Color(0.49, 0.349, 0, 1))

func _on_play_button_up() -> void:
	$CanvasLayer/Play/arrow.add_theme_color_override("font_color", Color(0.98, 0.76, 0.21,1))

func _on_back_button_up() -> void:
	$CanvasLayer/Back/arrow.add_theme_color_override("font_color", Color(0.98, 0.76, 0.21,1))
