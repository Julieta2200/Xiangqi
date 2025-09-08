class_name ShaderComponenet extends Node

@export var main_sprite: AnimatedSprite2D
@export var highlight_material: Material
@export var spawn_material: Material 
@export var spawn_speed: float = 0.3

var spawn_progress: float = 0.0
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

func mouse_entered():
	if main_sprite == null:
		return
	main_sprite.material = highlight_material

func mouse_exited():
	if main_sprite == null or main_sprite.material != highlight_material:
		return
	main_sprite.material = null
