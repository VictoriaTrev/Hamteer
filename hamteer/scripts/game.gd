extends CanvasLayer

@onready var finish_game_button: Button = $FinishGameButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_finish_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/finished.tscn")


func _on_trach_suctioning_removed_tube() -> void:
	finish_game_button.visible = true
