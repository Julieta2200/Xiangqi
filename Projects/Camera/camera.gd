extends Camera2D

@export var zoom_speed: float = 1
@export var move_speed: float = 1000.0
var zoom_min: float = 0.65
var zoom_max: float = 2.275
var move_right_max:float = 1800
var move_left_max: float = 50
var move_up_max: float = 447
var move_down_max: float = 1600

var zoom_target: Vector2

func _ready():
	zoom_target = zoom


func _process(delta):
	camera_zoom(delta)
	camera_move(delta)
	
func camera_zoom(delta):
	if Input.is_action_just_pressed("zoom_in"):
		zoom_target = zoom + Vector2(0.15,0.15)
		zoom_target = zoom_target.min(Vector2(zoom_max,zoom_max))
		
	if Input.is_action_just_pressed("zoom_out"):
		zoom_target = zoom - Vector2(0.15,0.15)
		zoom_target = zoom_target.max(Vector2(zoom_min,zoom_min))
	
	zoom = zoom.move_toward(zoom_target, zoom_speed * delta)
	
	
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
