extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
const default_color: Color = Color(0.8, 0.8, 0.8, 1.0)
const white_color: Color = Color(1.0, 1.0, 1.0, 1.0)  # Bright white color

var can_flash: bool = true
var flash_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_modulate.color = default_color
	_start_flash_timer()

func _start_flash_timer() -> void:
	if flash_timer:
		flash_timer.queue_free()
	
	flash_timer = Timer.new()
	add_child(flash_timer)
	# Random interval between 2-5 seconds
	flash_timer.wait_time = randf_range(2.0, 5.0)
	flash_timer.one_shot = true
	flash_timer.timeout.connect(_on_flash_timer_timeout)
	flash_timer.start()

func _on_flash_timer_timeout() -> void:
	if can_flash:
		_flash_lightning()

func _flash_lightning() -> void:
	var tween = create_tween()
	# Tween to lightning color (quick flash up)
	tween.tween_property(canvas_modulate, "color", white_color, 0.1)
	# Hold at lightning color briefly
	tween.tween_interval(0.1)
	# Tween back to default color
	tween.tween_property(canvas_modulate, "color", default_color, 0.3)
	await tween.finished
	_start_flash_timer()  # Start a new random timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
