class_name GameplayUI extends CanvasLayer

@onready var garrison: Garrison = $Garrison
@onready var power_meter: PowerMeter = $PowerMeter
@onready var support: Control = $Support
@onready var decision: Control = $Decision

@export var board: BoardV2

func _on_garrison_card_selected(selected_card: FigureCard) -> void:
	board.spawn_highlight(selected_card.type)


func _on_support_freeze(chance: float) -> void:
	board.freeze(chance)


func _on_support_wall() -> void:
	board.wall()


func _on_support_destroy_wall() -> void:
	board.destroy_wall()

func decision_activate():
	decision.show()
