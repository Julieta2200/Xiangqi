extends CanvasLayer

var level_1 = "res://Projects/Levels/Level_2/level_2.tscn"
var level_3 = "res://Projects/Levels/level_1.tscn"
var level_2 = "res://Projects/Levels/Level_3/level_3.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file(level_1)


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file(level_2)


func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file(level_3)
