extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BlurOverlay.material.set_shader_parameter("blur_amount", 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#
#func _on_visibility_changed() -> void:
	#if visible:
		#$BlurOverlay/AnimationPlayer.play("blur")
