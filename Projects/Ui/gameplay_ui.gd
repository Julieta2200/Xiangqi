class_name GameplayUI extends CanvasLayer

@onready var garrison: Garrison = $Garrison
@onready var power_meter: PowerMeter = $PowerMeter
@onready var decision: Control = $Decision
@onready var card_slots: CardSlots = $CardSlots
@export var is_active: bool = true

@export var board: BoardV2

func _ready() -> void:
	update_visibility()
	card_slots.board = board
	board.use_special.connect(card_slots.use_special)

func _on_garrison_card_selected(selected_card: FigureCard) -> void:
	board.spawn_highlight(selected_card.type)


func decision_activate():
	decision.show()

func update_visibility():
	garrison.visible = is_active
	power_meter.visible = is_active
	card_slots.visible = is_active
