extends Node

@onready var where_tube: Path2D = $WhereTube
@onready var path_follow_2d: PathFollow2D = $WhereTube/PathFollow2D

var in_lung = 0.9123
var tube_out = .15
var perfect = 0.9 

func move_tube(progress: float):
	path_follow_2d.progress_ratio += progress

func return_ratio(): 
	return path_follow_2d.progress_ratio
# Called when the node enters the scene tree for the first time.
func location():
	if return_ratio() > 0.9123:
		return GlobalVariable.area_of_lung.INSIDE_LUNG
	elif return_ratio() < tube_out:
		return GlobalVariable.area_of_lung.TUBE_OUT
	elif return_ratio() >= (perfect - 0.2) and return_ratio() <= in_lung:
		return GlobalVariable.area_of_lung.PERFECT_INSERT
	else:
		return GlobalVariable.area_of_lung.IN_TRACH
