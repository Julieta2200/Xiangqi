extends AnimationComponent

func play(animation: String) -> void:
	match animation:
		walk_up:
			animated_sprite.play(walk_up)
