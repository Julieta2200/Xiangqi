class_name SpecialCard extends Panel

enum TYPE {HL, LL}
@export var type: TYPE
@export var special: CardSlots.SPECIALS
@export var cooldown: int
@export var description: Button
@onready var icon: TextureRect = $Icon

var active: bool = true:
	set(a):
		active = a 
		icon.visible = a
		icon.modulate.a = 0.4

var selected: bool:
	set(s):
		selected = s
		if selected:
			modulate = Color(0.984,0.761,0.212,1)
		else:
			modulate = Color(1,1,1,1)

var use: bool:
	set(s):
		use = s
		if use:
			icon.modulate.a = 1
		else:
			icon.modulate.a = 0.4

var cooldown_counter: int = 0 :
	set(cc):
		cooldown_counter = cc
		if cooldown_counter < 0:
			cooldown_counter = 0

signal on_click(s: CardSlots.SPECIALS)
signal on_click_full(s: SpecialCard)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and active:
		use = !use
		emit_signal("on_click", special)
		emit_signal("on_click_full", self)

func start_cooldown() -> void:
	active = false
	cooldown_counter = cooldown

func countdown() -> void:
	cooldown_counter -= 1
	if cooldown_counter == 0:
		active = true

func _on_description_pressed() -> void:
	$DescriptionText.show()

func _on_back_pressed() -> void:
	$DescriptionText.hide()
