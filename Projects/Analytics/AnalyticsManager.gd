extends Node

var _ga = null

func _ready() -> void:
	if Engine.has_singleton("GameAnalytics"):
		_ga = Engine.get_singleton("GameAnalytics")
		_ga.init("6b01a1a7c532509e4de543a696b2b54f", "2492ccadef200216c9d88119790a3e54e8c1fc6c")

func level_start(level: String) -> void:
	if _ga:
		_ga.addProgressionEvent("start", "Chapter1", level, "", {})

func level_complete(level: String, move_number: int) -> void:
	if _ga:
		_ga.addProgressionEventWithScore("complete", "Chapter1", level, "", move_number)

func level_fail(level: String, move_number: int) -> void:
	if _ga:
		_ga.addProgressionEventWithScore("fail", "Chapter1", level, "", move_number)

func design_event(event_id: String, value: float = 0.0) -> void:
	if _ga:
		_ga.addDesignEventWithValue(event_id, value)
