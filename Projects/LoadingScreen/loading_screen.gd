extends Control

var progress = []
var scene_load_status = 0
var loaded: bool = false

@onready var load_bar: TextureProgressBar = $LoadBar
@onready var percent_text: Label = $PercentText

func _ready():
	# 1. Request to load the target scene in the background
	# We use the path stored in our Global singleton
	ResourceLoader.load_threaded_request(SceneManager.next_scene_path)
	var tween = create_tween()
	tween.tween_property(load_bar, "value", 100, 1.5)
	tween.finished.connect(func():
		loaded = true
	)

func _process(_delta):
	# 2. Check the status of the load every frame
	scene_load_status = ResourceLoader.load_threaded_get_status(SceneManager.next_scene_path, progress)
	
	# 4. Check if loading is complete
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED and loaded:
		# 5. Get the actual packed scene resource
		var new_scene = ResourceLoader.load_threaded_get(SceneManager.next_scene_path)
		
		# 6. Switch to the new scene
		get_tree().change_scene_to_packed(new_scene)

func _on_load_bar_value_changed(value: float):
	percent_text.text = str(int(value)) + "%"