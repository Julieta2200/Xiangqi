class_name BoardMarker extends Node2D

enum Highlights {NONE, MOVE, CAPTURE, SPAWN, SELECTED, SPECIAL, HOVER}

var board_position: Vector2i
var clickable: bool = true
@onready var walking_marker: AnimatedSprite2D = $walking_marker
@onready var spawn_marker: AnimatedSprite2D = $spawn_marker
@onready var hover_marker: Sprite2D = $hover_marker

@onready var spawn_light: AnimatedSprite2D = $spawn_marker/light
@onready var spawn_audio: AudioStreamPlayer = $spawn_audio
@onready var click_audio: AudioStreamPlayer = $click_audio

var board: BoardV2

signal figure_move(marker)
signal figure_spawn(marker)
signal spawn_done(marker)
signal highlight_end
signal special(marker)

var state: Highlights
var trap: bool = false
var tween : Tween

func _ready() -> void:
	state = Highlights.NONE

func play_spawn_audio():
	if spawn_audio != null:
		spawn_audio.play()
	if click_audio != null:
		click_audio.play()

func _on_area_2d_input_event(viewport, event, shape_idx):
	if clickable and event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			click()

func click() -> void:
	match state:
		Highlights.MOVE, Highlights.CAPTURE:
			emit_signal("figure_move",self)
		Highlights.SPAWN:
			play_spawn_audio()
			spawn_light.show()
			spawn_light.play("light")
			emit_signal("figure_spawn",self)
		Highlights.SPECIAL:
			emit_signal("special", self)

func highlight(type: Highlights) -> void:
	state = type
	match type:
		Highlights.MOVE:
			$walking_marker/highlight.play("highlight")
			walking_marker.play("move")
			walking_marker.show()
		Highlights.CAPTURE:
			walking_marker.play("capture")
			$walking_marker/highlight.play("capture_highlight")
			walking_marker.show()
		Highlights.SPAWN:
			$SpawnAnimationPlayer.play("RESET")
			spawn_marker.show()
		Highlights.SELECTED:
			pass
		Highlights.SPECIAL:
			$special_marker.show()
		Highlights.HOVER:
			hover_marker.show()
			return
	if board.state.has(board_position):
		var figure: FigureComponent = board.state[board_position]
		if figure.target_component != null:
			figure.target_component.active = true
			figure.target_component.marker = self
			clickable = false
			
		
func unhighlight():
	if state == Highlights.HOVER:
		hover_marker.hide()
		state = Highlights.NONE
		return
	if state == Highlights.SELECTED:
		$walking_marker/highlight.hide()
	if spawn_marker.visible:
		$SpawnAnimationPlayer.play("spawn_marker_unhighlight")
	walking_marker.hide()
	$special_marker.hide()
	state = Highlights.NONE
	clickable = true
	if board.state.has(board_position):
		var figure: FigureComponent = board.state[board_position]
		if figure.target_component != null:
			figure.target_component.active = false
			figure.target_component.marker = null

func _on_area_2d_mouse_entered() -> void:
	$walking_marker/highlight.visible = $walking_marker.visible
	var highlight_mat = $walking_marker/highlight.material
	highlight_mat.set_shader_parameter("reveal_progress", 0.0)
	
	if tween != null and tween.is_valid():
		tween.stop()
	tween = create_tween()
	tween.tween_property(highlight_mat, "shader_parameter/reveal_progress", 1,1 ) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)


func _on_area_2d_mouse_exited() -> void:
	if state == Highlights.SELECTED:
		return
	$walking_marker/highlight.hide()

func _on_spawn_light_animation_finished() -> void:
	emit_signal("spawn_done", self)
	await get_tree().process_frame
	spawn_light.hide()


func _on_spawn_unhighlight_animation_finished(anim_name: StringName) -> void:
	if anim_name == "spawn_marker_unhighlight":
		$SpawnAnimationPlayer.play("RESET")
		spawn_marker.call_deferred("hide")
