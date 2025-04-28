extends Camera2D

@export var zoom_speed: float = 3
@export var move_speed: float = 1000.0
var zoom_min: float = 0.65
var zoom_max: float = 2.275
var viewport_size : Vector2
var move_right_max:float
var move_left_max: float 
var move_up_max: float
var move_down_max: float

@export var locked: bool = false

func _ready() -> void:
	viewport_size = get_viewport().size
	calculate_limits(zoom)


func calculate_limits(z: Vector2) -> void:
	move_right_max = limit_right - viewport_size.x / (2*z.x)
	move_left_max = limit_left + viewport_size.x / (2*z.x)
	move_down_max = limit_bottom - viewport_size.y / (2*z.x)
	move_up_max = limit_top + viewport_size.y / (2*z.x)

func _process(delta):
	if locked:
		return
	camera_zoom(delta)
	camera_move(delta)
	
func camera_zoom(delta):
	var zoom_target: Vector2 = zoom
	if Input.is_action_just_released("zoom_in") or Input.is_action_pressed("zoom_in"):
		zoom_target = zoom + Vector2(0.15,0.15)
		zoom_target = zoom_target.min(Vector2(zoom_max,zoom_max))
		
	if Input.is_action_just_released("zoom_out") or Input.is_action_pressed("zoom_out"):
		zoom_target = zoom - Vector2(0.15,0.15)
		zoom_target = zoom_target.max(Vector2(zoom_min,zoom_min))
	
	zoom = zoom.move_toward(zoom_target, zoom_speed * delta)
	calculate_limits(zoom_target)
	
	
func camera_move(delta):
	var move_direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		move_direction.x += 1
		position.x = min(move_right_max,position.x + move_direction.x * delta * move_speed)

	if Input.is_action_pressed("move_left"):
		move_direction.x -= 1
		position.x = max(move_left_max,position.x + move_direction.x * delta * move_speed)
	
	if Input.is_action_pressed("move_up"):
		move_direction.y -= 1
		position.y = max(move_up_max,position.y + move_direction.y * delta * move_speed)
		
	if Input.is_action_pressed("move_down"):
		move_direction.y  += 1
		position.y = min(move_down_max,position.y + move_direction.y * delta * move_speed)

func lock() -> void:
	locked = true
	
func unlock() -> void:
	locked = false
