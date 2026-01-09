extends Control

var progress = []
var scene_load_status = 0
var loaded: bool = false
var current_tween: Tween = null
var target_progress: float = 0.0

@onready var load_bar: TextureProgressBar = $LoadBar
@onready var percent_text: Label = $PercentText

func _ready():
	# 1. Request to load the target scene in the background
	# We use the path stored in our Global singleton
	ResourceLoader.load_threaded_request(SceneManager.next_scene_path)

func _process(_delta):
	# 2. Check the status of the load every frame
	scene_load_status = ResourceLoader.load_threaded_get_status(SceneManager.next_scene_path, progress)
	
	# 3. Animate to real loading progress
	if scene_load_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		var real_progress = progress[0] if progress.size() > 0 else 0.0
		var real_progress_percent = real_progress * 100.0
		
		# If progress target changed, update animation
		if abs(target_progress - real_progress_percent) > 0.01:
			target_progress = real_progress_percent
			
			# Kill current tween if exists
			if current_tween:
				current_tween.kill()
			
			# Start new animation from current progress bar value to target
			current_tween = create_tween()
			current_tween.tween_property(load_bar, "value", target_progress, (target_progress - load_bar.value) / 50)
			current_tween.finished.connect(func():
				if target_progress >= 100.0:
					loaded = true
			)
	elif scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		# Scene is loaded, check if bar is already at 100%
		if load_bar.value >= 100.0:
			# Bar is already at 100%, set loaded immediately
			loaded = true
		elif abs(target_progress - 100.0) > 0.01:
			# Bar not at 100%, animate to 100%
			target_progress = 100.0
			if current_tween:
				current_tween.kill()
			current_tween = create_tween()
			current_tween.tween_property(load_bar, "value", 100.0, (target_progress - load_bar.value) / 50)
			current_tween.finished.connect(func():
				loaded = true
			)
	
	# 4. Check if loading is complete
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED and loaded:
		# 5. Get the actual packed scene resource
		var new_scene = ResourceLoader.load_threaded_get(SceneManager.next_scene_path)
		
		# 6. Switch to the new scene
		get_tree().change_scene_to_packed(new_scene)

func _on_load_bar_value_changed(value: float):
	percent_text.text = str(int(value)) + "%"