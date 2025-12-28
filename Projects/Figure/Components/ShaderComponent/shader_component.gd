class_name ShaderComponenet extends Node

@export var main_sprite: AnimatedSprite2D
@export var highlight_material: Material
@export var spawn_material: Material 
@export var sickness_material: Material
@export var blocker_material: Material
@export var spawn_speed: float = 0.3

var figure_ui_component: FigureUIComponent # is set in figure_ui_component.gd

@onready var hint_highlight_material: Material = preload("res://Projects/Shaders/hint_highlight.tres")

var spawn_progress: float = 0.0
var scale_speed: float = 1.0

func _ready() -> void:
	spawn()

func spawn():
	main_sprite.material = spawn_material.duplicate()
	var tween := create_tween()
	tween.tween_property(main_sprite.material, "shader_parameter/progress", 1.0, 1.2)
	tween.finished.connect(apply_sickness_material)

func mouse_entered():
	if main_sprite == null:
		return
	main_sprite.material = highlight_material

func mouse_exited():
	if main_sprite == null or main_sprite.material != highlight_material:
		return
	main_sprite.material = null

func hint_highlight() -> void:
	main_sprite.material = hint_highlight_material

func hint_unhighlight() -> void:
	main_sprite.material = null

func apply_sickness_material():
	if figure_ui_component == null or figure_ui_component.active:
		return
	main_sprite.material = sickness_material
	
func remove_sickness_material():
	main_sprite.material = null
	
func highlight_blocker():
	if main_sprite == null or blocker_material == null:
		return
	main_sprite.material = blocker_material
	
func unhighlight_blocker(is_active: bool):
	if main_sprite == null or main_sprite.material != blocker_material:
		return
	if is_active:
		main_sprite.material = null
	else:
		main_sprite.material = sickness_material
		
