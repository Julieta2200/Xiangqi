class_name SpecialCardInfo extends Control

enum SpecialType { TREE_TRUNK, SNAKE_CHAIN, WATER_PORTAL, DISCONNECTION_MIST, NONE }
enum Category { LL, HL }

const cards_name = {
	SpecialType.TREE_TRUNK: "SPECIAL_CARD_TREE_TRUNK",
	SpecialType.WATER_PORTAL: "SPECIAL_CARD_WATER_PORTAL",
	SpecialType.SNAKE_CHAIN: "SPECIAL_CARD_SNAKE_CHAIN",
	SpecialType.DISCONNECTION_MIST: "SPECIAL_CARD_DISCONNECTION_MIST",
	SpecialType.NONE: "SPECIAL_CARD_NONE"
}

const cards_icon = {
	SpecialType.TREE_TRUNK: preload("res://Assets/UI/Specials icon/Low Level/Tree trunk.png"),
	SpecialType.SNAKE_CHAIN: preload("res://Assets/UI/Specials icon/Low Level/Snake Chain.png"),
	SpecialType.WATER_PORTAL: preload("res://Assets/UI/Specials icon/Low Level/Water Portal.png"),
	SpecialType.DISCONNECTION_MIST: preload("res://Assets/UI/Specials icon/High Level/Fog.png"),
	SpecialType.NONE : preload("res://Assets/UI/Specials icon/Lock(Big).png")
}

const cards_description = {
	SpecialType.TREE_TRUNK: "SPECIAL_CARD_TREE_TRUNK_DESC",
	SpecialType.SNAKE_CHAIN: "SPECIAL_CARD_SNAKE_CHAIN_DESC",
	SpecialType.WATER_PORTAL: "SPECIAL_CARD_WATER_PORTAL_DESC",
	SpecialType.DISCONNECTION_MIST: "SPECIAL_CARD_DISCONNECTION_MIST_DESC",
	SpecialType.NONE: "SPECIAL_CARD_NONE_DESC"
}

@onready var container_ll = $specials_list/LLScrollContainer/VBoxContainer
@onready var container_hl = $specials_list/HLScrollContainer/VBoxContainer
@onready var scroll_ll = $specials_list/LLScrollContainer
@onready var scroll_hl = $specials_list/HLScrollContainer

@onready var card_name = $special_preview/name
@onready var card_info = $info_section/text
@onready var card_icon = $special_preview/icon/special_card
@onready var card_indicator = $special_preview/indicators/number_lable

@onready var ll_list_button = $specials_list/ll_button
@onready var hl_list_button = $specials_list/hl_button

var selected_card_index : int = 0
var current_category : Category = Category.LL
var category_containers = {}

func _ready() -> void:
	category_containers = {
		Category.LL: container_ll,
		Category.HL: container_hl
	}
	
	switch_category(Category.LL)
	select_card_by_index(0)

#Updates the UI with the given card data
func display_card_info(type: SpecialType, current_num: int, total_count: int) -> void:
	card_name.text = tr(cards_name[type])
	card_info.text = tr(cards_description[type])
	card_icon.texture = cards_icon[type]
	card_indicator.bbcode_text = "[center][font_size=40][color=#a58532]%d[/color][/font_size]  /  %d[/center]" % [current_num + 1, total_count]

#Selects the card by index in the current category
func select_card_by_index(index: int) -> void:
	var container = category_containers[current_category]
	if container.get_child_count() == 0: 
		return
		
	container.get_child(selected_card_index).button_pressed = false
	selected_card_index = index
	var card_node = container.get_child(selected_card_index)
	card_node.button_pressed = true
	display_card_info(card_node.type, selected_card_index, container.get_child_count())
	
	#AUTO SCROLL
	var scroll = scroll_ll if current_category == Category.LL else scroll_hl
	scroll.ensure_control_visible(card_node)
	
#Switches between LL and HL categories
func switch_category(category: Category) -> void:
	current_category = category
	selected_card_index = 0
	
	var container = category_containers[current_category]
	for child in container.get_children():
		child.button_pressed = false
		
	var is_ll_card = (category == Category.LL)
	
	scroll_ll.visible = is_ll_card
	scroll_hl.visible = !is_ll_card
	ll_list_button.button_pressed = is_ll_card
	hl_list_button.button_pressed = !is_ll_card
	select_card_by_index(0)

func _on_ll_button_pressed() -> void:
	switch_category(Category.LL)

func _on_hl_button_pressed() -> void:
	switch_category(Category.HL)

func _on_button_special_card_select(type: SpecialType, number: int) -> void:
	var container = category_containers[current_category]
	for child in container.get_children():
		child.button_pressed = false

	selected_card_index = number - 1
	container.get_child(selected_card_index).button_pressed = true
	
	display_card_info(type, selected_card_index, container.get_child_count())

func _on_left_button_pressed() -> void:
	if selected_card_index > 0:
		select_card_by_index(selected_card_index - 1)


func _on_right_button_pressed() -> void:
	var container = category_containers[current_category]
	if selected_card_index < container.get_child_count() - 1:
		select_card_by_index(selected_card_index + 1)
