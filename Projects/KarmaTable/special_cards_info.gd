class_name SpecialCardInfo extends Control

var selected_card_num : int =0
enum SPECIALS {TreeTrunk, SnakeChain, WaterPortal, DisconnectionMistCard, Null}
enum SPECIALS_TYPE {LL, HL}
const card_names = {
	SPECIALS.TreeTrunk: "TREE TRUNK",
	SPECIALS.SnakeChain: "SNAKE CHAIN",
	SPECIALS.WaterPortal: "WATER PORTAL",
	SPECIALS.DisconnectionMistCard: "DISCONNECTION MIST"
}

const icons_image = {
	SPECIALS.TreeTrunk: preload("res://Assets/UI/Icons/Low level/Tree_Trunk.png"),
	SPECIALS.SnakeChain: preload("res://Assets/UI/Icons/Low level/Snake_Chain.png"),
	SPECIALS.WaterPortal: preload("res://Assets/UI/Icons/Low level/Water_Portal.png"),
	SPECIALS.DisconnectionMistCard: preload("res://Assets/UI/Icons/High level/Fog1.png")
}

const card_info = {
	SPECIALS.TreeTrunk: "Tree truke is a .....",
	SPECIALS.SnakeChain: "Snake chain is a ...",
	SPECIALS.WaterPortal: " Water portal is a ...",
	SPECIALS.DisconnectionMistCard: " Dis mist ia a ..."
}

var specials = { }
	#SPECIALS_TYPE.LL : $specials_list/ScrollContainer/VBoxContainer,
	#SPECIALS_TYPE.HL : $specials_list/ScrollContainer2/VBoxContainer
#} 
var selected_special: SPECIALS_TYPE
func _ready() -> void:
	specials = { 
	SPECIALS_TYPE.LL : $specials_list/ScrollContainer/VBoxContainer,
	SPECIALS_TYPE.HL : $specials_list/ScrollContainer2/VBoxContainer
	} 
	selected_special = SPECIALS_TYPE.LL
	$info_section/RichTextLabel
	$specials_list/ScrollContainer/VBoxContainer/button.button_pressed = true
	$specials_list/ll_button.button_pressed = true
	$special_preview/indicators/Label.bbcode_text = "[color=%s]%d[/color] / %d" % ["#a58532", selected_card_num+1, specials[selected_special].get_child_count()]


func _on_ll_button_pressed() -> void:
	selected_card_num = 0
	selected_special = SPECIALS_TYPE.LL
	var card = $specials_list/ScrollContainer/VBoxContainer/button
	card.button_pressed = true
	$special_preview/name.text = card_names[card.type]
	$info_section/RichTextLabel.text = card_info[card.type]
	$special_preview/icon/special_card.texture = icons_image[card.type]
	$special_preview/indicators/Label.bbcode_text = "[color=%s]%d[/color] / %d" % ["#a58532", selected_card_num+1, specials[selected_special].get_child_count()]
	$specials_list/hl_button.button_pressed = false
	$specials_list/ScrollContainer2.hide()
	$specials_list/ScrollContainer.show()


func _on_hl_button_pressed() -> void:
	selected_card_num = 0
	selected_special = SPECIALS_TYPE.HL
	var card = $specials_list/ScrollContainer2/VBoxContainer/button6
	card.button_pressed = true
	$special_preview/name.text = card_names[card.type]
	$info_section/RichTextLabel.text = card_info[card.type]
	$special_preview/icon/special_card.texture = icons_image[card.type]
	$special_preview/indicators/Label.bbcode_text = "[color=%s]%d[/color] / %d" % ["#a58532", selected_card_num+1, specials[selected_special].get_child_count()]
	$specials_list/ll_button.button_pressed = false
	$specials_list/ScrollContainer.hide()
	$specials_list/ScrollContainer2.show()

func _on_button_pressed() -> void:
	if selected_card_num == 0:
		return
	specials[selected_special].get_child(selected_card_num).button_pressed = false
	selected_card_num -= 1
	$special_preview/indicators/Label.bbcode_text = "[color=%s]%d[/color] / %d" % ["#a58532", selected_card_num+1, specials[selected_special].get_child_count()]
	var card = specials[selected_special].get_child(selected_card_num)
	card.button_pressed = true
	$special_preview/name.text = card_names[card.type]
	$info_section/RichTextLabel.text = card_info[card.type]
	$special_preview/icon/special_card.texture = icons_image[card.type]


func _on_button_special_card_select(type: Variant, number: Variant) -> void:
	for i in specials[selected_special].get_children():
		i.button_pressed = false
	$special_preview/name.text = card_names[type]
	$info_section/RichTextLabel.text = card_info[type]
	$special_preview/icon/special_card.texture = icons_image[type]
	selected_card_num = number -1
	$special_preview/indicators/Label.bbcode_text = "[color=%s]%d[/color] / %d" % ["#a58532", number, specials[selected_special].get_child_count()]


func _on_button_2_pressed() -> void:
	if selected_card_num == specials[selected_special].get_child_count()-1:
		return
	specials[selected_special].get_child(selected_card_num).button_pressed = false
	selected_card_num += 1
	$special_preview/indicators/Label.bbcode_text = "[color=%s]%d[/color] / %d" % ["#a58532", selected_card_num+1, specials[selected_special].get_child_count()]
	var card = specials[selected_special].get_child(selected_card_num)
	card.button_pressed = true
	$special_preview/name.text = card_names[card.type]
	$info_section/RichTextLabel.text = card_info[card.type]
	$special_preview/icon/special_card.texture = icons_image[card.type]
