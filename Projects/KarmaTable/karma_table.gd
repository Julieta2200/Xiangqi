extends Node2D

@onready var lls: Control = $CanvasLayer/LLs
@onready var hls: Control = $CanvasLayer/HLs
@onready var low_level_label: Label = $CanvasLayer/LLs/Label
@onready var high_level_label: Label = $CanvasLayer/HLs/Label

@onready var hint_bubbles: Array[HintBubble] = [
	$CanvasLayer/Hints/HintBubble,
	$CanvasLayer/Hints/HintBubble2,
]
@onready var play_button: Button = $CanvasLayer/Play
@onready var back_button: Button = $CanvasLayer/Back

@onready var ll_hint_bubble: HintBubble = $CanvasLayer/Hints/LLHint

# Orbs
@onready var orbs: HBoxContainer = %Orbs
@onready var active_orb_texture: CompressedTexture2D = preload("res://Assets/UI/Orb/Orb.png")

var _hint_index: int = 0

var dialogs: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogs = DialoguesManager.get_all_dialogs()
	fill_lls()
	fill_hls()
	# Set translated text for buttons
	play_button.text = tr("PLAY")
	back_button.text = tr("BACK")
	low_level_label.text = tr("ALLIANCE")
	high_level_label.text = tr("KARMA")
	if GameState.state["first_karma_table_run"]:
		run_hint_system()
		return
	if GameState.state["first_ll_introduction"] and GameState.state["ll_cards"].size() > 0:
		run_ll_hint_system()
		return
	fill_orbs()
	run_dialog()

func fill_orbs() -> void:
	var orbs_count = GameState.get_orbs()
	for i in range(orbs_count):
		var orb = orbs.get_child(i)
		orb.texture = active_orb_texture

func run_ll_hint_system() -> void:
	ll_hint_bubble.show()
	play_button.hide()
	back_button.hide()
	GameState.state["first_ll_introduction"] = false
	GameState.save_game()

func _ll_hint_shown() -> void:
	ll_hint_bubble.hide()
	play_button.show()
	back_button.show()
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
	SceneManager.change_scene(SceneManager.Scenes.Overworld)

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
	AudioManager.play_sound("dialog_box")
	hint_bubbles[_hint_index].show()
	_hint_index += 1


func _on_back_mouse_entered() -> void:
	$CanvasLayer/Back/arrow.text = tr("BUTTON_ARROW_HOVER")

func _on_back_mouse_exited() -> void:
	$CanvasLayer/Back/arrow.text = tr("BUTTON_ARROW_NORMAL")

func _on_play_mouse_entered() -> void:
	$CanvasLayer/Play/arrow.text = tr("BUTTON_ARROW_HOVER")

func _on_play_mouse_exited() -> void:
	$CanvasLayer/Play/arrow.text = tr("BUTTON_ARROW_NORMAL")

func _on_play_button_down() -> void:
	$CanvasLayer/Play/arrow.add_theme_color_override("font_color", Color(0.49, 0.349, 0, 1))

func _on_back_button_down() -> void:
	$CanvasLayer/Back/arrow.add_theme_color_override("font_color", Color(0.49, 0.349, 0, 1))

func _on_play_button_up() -> void:
	$CanvasLayer/Play/arrow.add_theme_color_override("font_color", Color(0.98, 0.76, 0.21,1))

func _on_back_button_up() -> void:
	$CanvasLayer/Back/arrow.add_theme_color_override("font_color", Color(0.98, 0.76, 0.21,1))


func _on_toggle_button_pressed() -> void:
	if $CanvasLayer/Special_cards_info.position != Vector2.ZERO:
		$CanvasLayer/Special_cards_info/AnimationPlayer.play("special_card_info")
	else:
		$CanvasLayer/Special_cards_info/AnimationPlayer.play_backwards("special_card_info")
