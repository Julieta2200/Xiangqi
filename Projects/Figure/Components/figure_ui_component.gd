class_name FigureUIComponent extends Area2D

var active: bool = true

@export var highlight_material: Material
@onready var spawn_material: Material = load("res://Projects/Shaders/spawn.tres")

@export var chess_component: ChessComponent
@export var main_sprite: AnimatedSprite2D

var spawn_progress: float = 0.0
var spawn_speed: float = 0.3
var scale_speed: float = 1.0

func _ready() -> void:
	main_sprite.material = spawn_material.duplicate()
	

func _process(delta):
	if main_sprite.material is ShaderMaterial  and \
	main_sprite.material.shader and \
	"spawn.gdshader" in main_sprite.material.shader.resource_path:
		if spawn_progress < 1.0:
			spawn_progress += spawn_speed*delta
			spawn_progress = min(spawn_progress, 1.0)
			main_sprite.material.set_shader_parameter("progress", spawn_progress)

func _on_mouse_entered() -> void:
	if !active:
		return
	if main_sprite == null:
		return
	main_sprite.material = highlight_material


func _on_mouse_exited() -> void:
	if main_sprite == null or main_sprite.material != highlight_material:
		return
	main_sprite.material = null


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !active:
		return
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			chess_component.show_moves()
