extends Button

signal card_select(type,number)

@export var type: SpecialCardInfo.SpecialType
@export var image: Texture
@export var number: int

func _ready() -> void:
	$icon.texture = image

func _on_special_card_pressed() -> void:
	emit_signal("card_select", type, number)
