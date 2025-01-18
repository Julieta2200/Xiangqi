extends Control


func appear(texture: Texture,text: String):
	visible = true
	$Background/Hint_texture.texture = texture
	$Background/RichTextLabel.text = text
	$Background/AnimationPlayer.play("write_text")


func _on_ok_button_pressed():
	visible = false
