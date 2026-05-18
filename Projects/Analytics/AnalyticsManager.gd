extends Node

var _ga = null
var _start_time: int = 0

func _ready() -> void:
	if Engine.has_singleton("GameAnalytics"):
		_ga = Engine.get_singleton("GameAnalytics")
		_ga.init("6b01a1a7c532509e4de543a696b2b54f", "2492ccadef200216c9d88119790a3e54e8c1fc6c")

func level_start(level: String) -> void:
	_start_time = Time.get_ticks_msec()
	if _ga:
		_ga.addProgressionEvent("start", "Chapter1", level, "", {})

func level_complete(level: String) -> void:
	if _ga:
		var elapsed_seconds: int = (Time.get_ticks_msec() - _start_time) / 1000
		_ga.addProgressionEventWithScore("complete", "Chapter1", level, "", elapsed_seconds)

func level_fail(level: String) -> void:
	if _ga:
		var elapsed_seconds: int = (Time.get_ticks_msec() - _start_time) / 1000
		_ga.addProgressionEventWithScore("fail", "Chapter1", level, "", elapsed_seconds)

func design_event(event_id: String, value: float = 0.0) -> void:
	if _ga:
		_ga.addDesignEventWithValue(event_id, value)
