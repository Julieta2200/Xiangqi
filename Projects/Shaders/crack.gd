class_name Crack extends Sprite2D

@export var fade_in_duration: float = 1.0
@export var visible_duration: float = 2.0
@export var fade_out_duration: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0.0
	
	var tween = create_tween()
	
	tween.tween_property(self, "modulate:a", 1.0, fade_in_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.tween_interval(visible_duration)
	
	tween.tween_property(self, "modulate:a", 0.0, fade_out_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	tween.finished.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
