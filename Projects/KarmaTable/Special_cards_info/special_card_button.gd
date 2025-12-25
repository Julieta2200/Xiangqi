extends Button

signal card_select(type,number)

#enum SPECIALS {TreeTrunk, SnakeChain, WaterPortal, DisconnectionMistCard, Null}
#
#const card_names = {
	#SPECIALS.TreeTrunk: "TREE TRUNK",
	#SPECIALS.SnakeChain: "SNAKE CHAIN",
	#SPECIALS.WaterPortal: "WATER PORTAL",
	#SPECIALS.DisconnectionMistCard: "DISCONNECTION MIST"
#}
#
#const card_image = {
	#SPECIALS.TreeTrunk: preload("res://Assets/UI/Icons/Low level/Tree_Trunk.png"),
	#SPECIALS.SnakeChain: preload("res://Assets/UI/Icons/Low level/Snake_Chain.png"),
	#SPECIALS.WaterPortal: preload("res://Assets/UI/Icons/Low level/Water_Portal.png"),
	#SPECIALS.DisconnectionMistCard: preload("res://Assets/UI/Icons/High level/Fog1.png")
#}
#
#const card_info = {
	#SPECIALS.TreeTrunk: "Tree truke is a .....",
	#SPECIALS.SnakeChain: "Snake chain is a ...",
	#SPECIALS.WaterPortal: " Water portal is a ...",
	#SPECIALS.DisconnectionMistCard: " Dis mist ia a ..."
#}

@export var type: SpecialCardInfo.SPECIALS
@export var image: Texture
@export var number: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$icon.texture = image
	#$icon.texture = SpecialCardInfo.card_image[type]
	#text = card_names[type]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	


func _on_special_card_pressed() -> void:
	emit_signal("card_select", type, number)
