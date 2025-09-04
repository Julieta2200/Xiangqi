class_name GameplayUI extends CanvasLayer

@onready var garrison: Garrison = $Garrison
@onready var power_meter: PowerMeter = $PowerMeter
@onready var decision: Control = $Decision
@onready var card_slots: CardSlots = $CardSlots

@export var board: BoardV2

func _ready() -> void:
	card_slots.board = board

func _on_garrison_card_selected(selected_card: FigureCard) -> void:
	board.spawn_highlight(selected_card.type)


func decision_activate():
	decision.show()
