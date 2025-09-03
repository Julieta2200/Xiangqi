class_name SpecialCard extends Panel

enum TYPE {HL, LL}
@export var type: TYPE
@export var special: CardSlots.SPECIALS

signal on_click(s: CardSlots.SPECIALS)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		emit_signal("on_click", special)
