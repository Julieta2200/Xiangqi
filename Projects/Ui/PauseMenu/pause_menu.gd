extends Control


func _ready() -> void:
	$BlurOverlay.material.set_shader_parameter("blur_amount", 1)


func _on_visibility_changed() -> void:
	if visible:
		$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stop()
