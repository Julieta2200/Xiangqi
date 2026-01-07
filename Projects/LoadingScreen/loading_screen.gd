extends Control

var progress = []
var scene_load_status = 0

@onready var load_bar: TextureProgressBar = $LoadBar

func _ready():
    # 1. Request to load the target scene in the background
    # We use the path stored in our Global singleton
    ResourceLoader.load_threaded_request(SceneManager.next_scene_path)

func _process(_delta):
    # 2. Check the status of the load every frame
    scene_load_status = ResourceLoader.load_threaded_get_status(SceneManager.next_scene_path, progress)
    
    # 3. Update the visual progress bar
    # 'progress' is an array where the first index is the percentage (0.0 to 1.0)
    load_bar.value = progress[0] * 100
    
    # 4. Check if loading is complete
    if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
        # 5. Get the actual packed scene resource
        var new_scene = ResourceLoader.load_threaded_get(SceneManager.next_scene_path)
        
        # 6. Switch to the new scene
        get_tree().change_scene_to_packed(new_scene)