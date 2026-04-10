extends CanvasLayer

@onready var q_1: Control = $Q1
@onready var q_2: Control = $Q2
@onready var q_3: Control = $Q3
@onready var wait_timer_1: Timer = $WaitTimer1
@onready var wait_timer_2: Timer = $WaitTimer2
@onready var wait_timer_3: Timer = $WaitTimer3
@onready var results: Control = $Results


# Question 1 Code
@onready var wrong_2q1: Button = $Q1/Wrong2
@onready var rightq1: Button = $Q1/Right

func answer_picked_question1():
	wrong_2q1.visible = false
	wait_timer_1.start()
	

# Question 2 Code
@onready var wrong: Button = $Q2/Wrong
@onready var wrong_3: Button = $Q2/Wrong3
@onready var wrong_2: Button = $Q2/Wrong2

func answer_picked_question_2():
	wrong.visible = false
	wrong_3.visible = false
	wrong_2.visible = false
	wait_timer_2.start()

func change_scene() -> void: 
	get_tree().change_scene_to_file("res://game.tscn")
	

func _on_wait_timer_1_timeout() -> void:
	q_1.visible = false
	q_2.visible = true
	
func _on_wait_timer_2_timeout() -> void:
	q_2.visible = false
	q_3.visible = true

# Question 3
@onready var q3wrong: Button = $Q3/Wrong
@onready var q3wrong_3: Button = $Q3/Wrong3
@onready var q3wrong_2: Button = $Q3/Wrong2

func answer_picked_question_3():
	q3wrong.visible = false
	q3wrong_2.visible = false
	q3wrong_3.visible = false
	wait_timer_3.start()

func _on_wait_timer_3_timeout() -> void:
	q_3.visible = false
	results.visible = true
