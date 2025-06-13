extends Node2D

@onready var board: Board = %Board
@onready var dialog: Dialog = %Dialog

var initial_state = {
		Vector2(4, 2): {
			"type": Figure.Types.General,
			"team": Board.team.Red,
			"inactive" : false,
			"group": "Magma"
		},
		Vector2(3, 0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
			"inactive" : false,
			"group": "Magma"
		},
		Vector2(5, 0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
			"inactive" : false,
			"group": "Magma"
		},
	}

func _ready() -> void:
	board.create_state(initial_state)
	var general: Figure = board.get_figures(Board.team.Red, Figure.Types.General)[0]
	general.play_animation("idle")

func start_conversation() -> void:
	var texts: Array[TextBlock] = [
		TextBlock.new("How did you find me?","Ashes", "Sprite"),
		TextBlock.new("We spent 100s of years looking for you, going through dungeons of every empire, and when we realized that you’re not in our world, we guessed that Cloud Empire is standing behind this.","Advisor", "Sprite"),
		TextBlock.new("Please stay quiet, we need to sneak out of here before someone notices?","Advisor", "Sprite"),
		TextBlock.new("Sneak out?","Ashes", "Sprite"),
		TextBlock.new("They brought me here through the main gates, and I will exit only through there!","Ashes", "Sprite"),
		TextBlock.new("And I want to give a visit to the Cloud Emperor <Name>","Ashes", "Sprite"),
		TextBlock.new("But…","Advisor", "Sprite"),
		TextBlock.new("Silence! We do as you say Lord Ashes ","Advisor", "Sprite"),
	]
	dialog.appear(texts)


func _on_dialog_finished(to_call: Callable) -> void:
	$AnimationPlayer.play("finish")

func next_scene() -> void:
	get_tree().change_scene_to_file("res://Projects/Tutorial_1/tutorial_1.tscn")
