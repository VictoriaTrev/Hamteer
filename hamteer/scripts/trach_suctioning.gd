extends Node2D
@onready var visual_insertion: Node = $VisualInsertion
@onready var mucus_amount: ProgressBar = $MucusAmount
@onready var between_button_press_timer: Timer = $BetweenButtonPressTimer
@onready var how_long_sucking: Timer = $HowLongSucking
@onready var too_short_timer: Timer = $TooShortTimer

signal removed_tube
signal patient_hurt
signal game_over

@export var speed = .006;
var mucus_level
var is_suctioning: bool = false
var has_suction: bool = false
var is_inserted: bool = false
var patient_has_oxygen: bool = false
var is_inserted_correctly: bool = false
var is_left: bool = false
var is_right: bool = false
var button_timed_out:= false

var patient_pain_level := 0 :
	set(value):
		patient_pain_level = clampi(value, 0, 10)

func _ready() -> void:
	mucus_level = mucus_amount.max_value
	mucus_amount.value = mucus_level

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mucus_amount.value = mucus_level
	if Input.is_action_pressed("suction"):
		is_suctioning = true
		if Input.is_action_just_pressed("twisit_left") or Input.is_action_just_pressed("twist_right"):
			if !is_left and !is_right:
				if Input.is_action_just_pressed("twisit_left"):
					is_left = true
					print("Starting Left")
				else:
					is_right = true
					print("Starting Left")
				between_button_press_timer.start()
			elif Input.is_action_just_pressed("twisit_left"):
				if is_right:
					is_right = false
					is_left = true
					between_button_press_timer.start()
					button_timed_out = false
					if button_timed_out:
						mucus_level -= 1
					else:
						mucus_level -= 4
				else: 
					print("Hurting patient")
			elif Input.is_action_just_pressed("twist_right"):
				if is_left:
					is_left = false
					is_right = true
					between_button_press_timer.start()
					button_timed_out = false
					if button_timed_out:
						mucus_level -= 1
					else:
						mucus_level -=4
				else:
					print("Hurting patient!")
		print("Mucus Left: ", mucus_level)
	elif Input.is_action_just_released("suction"):
		is_suctioning = false
		if has_suction == false:
			has_suction = true
			how_long_sucking.start()
			too_short_timer.start()
			
	if Input.is_action_pressed("inserting_tube") or Input.is_action_pressed("removing_tube"):
		if Input.is_action_pressed("inserting_tube"): 
			if is_suctioning:
				patient_hurt.emit()
			visual_insertion.move_tube(speed)
		elif Input.is_action_pressed("removing_tube"):
			if is_suctioning:
				print("Patient has been hurt.")
				patient_hurt.emit()
			visual_insertion.move_tube(-speed)
			if visual_insertion.location() == GlobalVariable.area_of_lung.TUBE_OUT:
				removed_tube.emit()
			
	if Input.is_action_just_released("inserting_tube"):
		if is_inserted_correctly:
			print("Stop Inserting >:(")
		if visual_insertion.location() == GlobalVariable.area_of_lung.PERFECT_INSERT:
			is_inserted_correctly = true
			print("Perfect!")
	
func _on_between_button_press_timer_timeout() -> void:
	print("Not turning fast enough; cannot get enough mucus!")
	button_timed_out = true


func _on_how_long_sucking_timeout() -> void:
	print("In there too Long!")

func _on_too_short_timer_timeout() -> void:
	print("Time left: ", how_long_sucking.time_left)
	
func _on_removed_tube() -> void:
	if mucus_level != 0:
		print("There is mucus left!")
	else:
		print("All Mucus Clean")
		GlobalVariable.mucus_cleaned = true

func _on_patient_hurt() -> void:
	patient_pain_level += 1
	if patient_pain_level == 10:
		game_over.emit()
