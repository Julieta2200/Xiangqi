class_name Board extends Node

var array : Array = [[Figure.figures_type, Figure.team]]
var marker_array : Array 

func _ready():
	marker_array = $Markers.get_children()
