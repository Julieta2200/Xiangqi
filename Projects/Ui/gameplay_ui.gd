class_name GameplayUI extends CanvasLayer

@onready var garrison: Garrison = $Garrison
@onready var power_meter: PowerMeter = $PowerMeter
@onready var support: Control = $Support

@export var board: BoardV2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_garrison_card_selected(selected_card: FigureCard) -> void:
	board.spawn_highlight(selected_card.type)


func _on_support_freeze(chance: float) -> void:
	board.freeze(chance)
