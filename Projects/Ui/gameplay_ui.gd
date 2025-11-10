class_name GameplayUI extends CanvasLayer

@onready var garrison: Garrison = $Garrison
@onready var power_meter: PowerMeter = $PowerMeter
@onready var decision: Control = $Decision
@onready var card_slots: CardSlots = $CardSlots
@onready var objectives: Objectives = $Objectives
@export var with_specials: bool = true

@export var board: BoardV2

func _ready() -> void:
	update_specials_visibility()
	card_slots.board = board
	board.use_special.connect(card_slots.use_special)

func _on_garrison_card_selected(selected_card: FigureCard) -> void:
	board.spawn_highlight(selected_card.type)

func _on_garrison_card_deselected() -> void:
	board.clear_markers()

func decision_activate():
	decision.show()

func update_specials_visibility():
	garrison.visible = with_specials
	power_meter.visible = with_specials
	card_slots.visible = with_specials
