extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
const default_color: Color = Color(0.8, 0.8, 0.8, 1.0)
const white_color: Color = Color(1.0, 1.0, 1.0, 1.0)  # Bright white color

var can_flash: bool = true
var flash_timer: Timer

@onready var lights: Array[Sprite2D] = [
	$Background/Light1,
	$Background/Light2,
	$Background/Light3,
	$Background/Light4,
	$Background/Light5,
]

var light_original_positions: Array[Vector2] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_modulate.color = default_color
	_start_flash_timer()
	_start_light_floating()

func _start_light_floating() -> void:
	# Store original positions
	for light in lights:
		if light:
			light_original_positions.append(light.position)
	
	# Start floating animation for each light with variations
	for i in range(lights.size()):
		if lights[i]:
			_float_light(i)

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

func _float_light(light_index: int) -> void:
	if light_index >= lights.size() or light_index >= light_original_positions.size():
		return
	
	var light = lights[light_index]
	if not light:
		return
	
	var original_pos = light_original_positions[light_index]
	# Vary the floating distance and speed for each light (5-15 pixels, 1.5-2.5 seconds)
	var float_distance = randf_range(5.0, 15.0)
	var float_duration = randf_range(1.5, 2.5)
	
	var tween = create_tween()
	tween.set_loops()  # Loop infinitely
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# Smooth floating cycle: float up, then down, creating a gentle bobbing motion
	tween.tween_property(light, "position:y", original_pos.y - float_distance, float_duration)
	tween.tween_property(light, "position:y", original_pos.y + float_distance, float_duration)
	tween.tween_property(light, "position:y", original_pos.y, float_duration * 0.5)

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
