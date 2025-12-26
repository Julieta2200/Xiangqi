extends Node2D

enum States {None, New_Game, Continue, Credits, Options}

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
const default_color: Color = Color(0.8, 0.8, 0.8, 1.0)
const white_color: Color = Color(1.0, 1.0, 1.0, 1.0)  # Bright white color

var state: States
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

@onready var ui_animation: AnimationPlayer = %UIAnimation
@onready var nav_blocker: Panel = %NavBlocker
@onready var main_animation: AnimationPlayer = %MainAnimation
@onready var ashes: AnimatedSprite2D = %Ashes
@onready var continue_button: Button = $CanvasLayer/Navigation/Continue
@onready var new_game_button: Button = $CanvasLayer/Navigation/NewGame
@onready var options_button: Button = $CanvasLayer/Navigation/Options
@onready var credits_button: Button = $CanvasLayer/Navigation/Credits
@onready var esc_label: Label = $CanvasLayer/Bottom/Line/EscButton/Esc
@onready var exit_label: Label = $CanvasLayer/Bottom/Line/EscButton/Exit
@onready var producer_lable: Label = $CanvasLayer/Credits/Producer/role
@onready var game_designer_lable: Label = $CanvasLayer/Credits/GameDesigner/role
@onready var lead_programmers_labe: Label = $CanvasLayer/Credits/LeadProgrammers/role
@onready var artist_lable: Label = $CanvasLayer/Credits/Artist/role
@onready var composer_lable: Label = $CanvasLayer/Credits/Composer/role
@onready var programmers_lable: Label = $CanvasLayer/Credits/Programmers/role
@onready var authors_lable: Label = $CanvasLayer/Credits/Authors/role
@onready var scecial_thanks_lable: Label = $CanvasLayer/Credits/SpecialThanks/role
@onready var copyright_lable: Label = $CanvasLayer/Credits/Copyright/role
@onready var prelude_label: RichTextLabel = $CanvasLayer/Prelude/RichTextLabel



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	continue_button.disabled = !GameState.save_exists()
	canvas_modulate.color = default_color
	_start_flash_timer()
	_start_light_floating()
	
	# Set translated text for all menu buttons
	continue_button.text = tr("CONTINUE")
	new_game_button.text = tr("NEW_GAME")
	options_button.text = tr("OPTIONS")
	credits_button.text = tr("CREDITS")
	esc_label.text = tr("ESC")
	exit_label.text = tr("EXIT")
	producer_lable.text = tr("PRODUCER")
	game_designer_lable.text = tr("GAME_DESIGNER")
	lead_programmers_labe.text = tr("LEAD_PROGRAMMERS")
	artist_lable.text = tr("ARTIST")
	composer_lable.text = tr("COMPOSER_AND_SOUND_DESIGNER")
	programmers_lable.text = tr("PROGRAMMERS")
	authors_lable.text = tr("AUTHORS")
	scecial_thanks_lable.text = tr("SPECIAL_THANKS")
	copyright_lable.text = tr("Copyright")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		if !$CanvasLayer/Bottom/Line/EscButton.visible:
			return
		match state:
			States.Credits:
				state = States.None
				ui_animation.play_backwards("credits")
			States.None:
				get_tree().quit()
			States.New_Game:
				main_animation.play("prelude_disappear")
				await main_animation.animation_finished
				start_game_sequence()
	
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

func _on_new_game_pressed() -> void:
	main_animation.play("prelude")
	await main_animation.animation_finished
	var tween = create_tween()
	tween.tween_property(prelude_label.material, "shader_parameter/progress", 1.0, 18)
	state = States.New_Game

func start_game_sequence():
	nav_blocker.visible = true
	main_animation.play("start")
	GameState.new_game()
	
func play_ashes_run() -> void:
	ashes.play("run")

func open_overworld() -> void:
	SceneManager.change_scene(SceneManager.Scenes.Overworld)

func _on_continue_pressed() -> void:
	state = States.Continue
	ui_animation.play("disappear")
	nav_blocker.visible = true
	main_animation.play("start")


func _on_credits_pressed() -> void:
	state = States.Credits
	ui_animation.play("credits")
