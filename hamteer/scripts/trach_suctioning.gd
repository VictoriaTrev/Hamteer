extends Node2D
@onready var visual_insertion: Node = $VisualInsertion
@onready var mucus_amount: ProgressBar = $MucusAmount
@onready var between_button_press_timer: Timer = $BetweenButtonPressTimer
@onready var how_long_sucking: Timer = $HowLongSucking
@onready var too_short_timer: Timer = $TooShortTimer
@onready var coughing_audio: AudioStreamPlayer = $CoughingAudio
@onready var suction: Sprite2D = $Suction
@onready var hand_on_pipe: Sprite2D = $HandOnPipe

signal removed_tube
signal patient_hurt
signal game_over
signal procedure_started

@export var speed = .006;
@export var remove_speed = -0.01
var mucus_level
var is_suctioning: bool = false
var has_suction: bool = false
var is_inserted: bool = false
var patient_has_oxygen: bool = false
var is_inserted_correctly: bool = false
var is_left: bool = false
var is_right: bool = false
var button_timed_out:= false
var procedure_begin:= false

var patient_pain_level := 0 :
	set(value):
		patient_pain_level = clampi(value, 0, 10)

func _ready() -> void:
	mucus_level = mucus_amount.max_value
	mucus_amount.value = mucus_level
func reset():
	is_suctioning = false
	has_suction = false
	is_inserted = false
	patient_has_oxygen = false
	is_inserted_correctly = false
	is_left = false
	is_right = false
	button_timed_out = false
	procedure_begin = false
	how_long_sucking.stop()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# AUDIO STUFF:
	if visual_insertion.location() == GlobalVariable.area_of_lung.PERFECT_INSERT:
		coughing_audio.play()
	mucus_amount.value = mucus_level
	if Input.is_action_pressed("suction"):
		suction.frame_coords = Vector2i(1,1)
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
				hand_on_pipe.rotate(deg_to_rad(-20))

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
					GlobalVariable.suction_properly = false
			elif Input.is_action_just_pressed("twist_right"):
				hand_on_pipe.rotate(deg_to_rad(20))
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
					GlobalVariable.suction_properly = false

		print("Mucus Left: ", mucus_level)
	elif Input.is_action_just_released("suction"):
		suction.frame_coords = Vector2i(0,1) 
		is_suctioning = false
		if is_inserted and has_suction:
			has_suction = true
			how_long_sucking.start()
			
	if Input.is_action_pressed("inserting_tube") or Input.is_action_pressed("removing_tube"):
		if Input.is_action_pressed("inserting_tube"): 
			if !procedure_begin:
				procedure_started.emit()
			if is_suctioning:
				patient_hurt.emit()
			if !is_inserted and visual_insertion.location() == GlobalVariable.area_of_lung.IN_TRACH:
				is_inserted = true
			visual_insertion.move_tube(speed)
		elif Input.is_action_pressed("removing_tube"):
			if is_suctioning:
				print("Patient has been hurt.")
				patient_hurt.emit()
			visual_insertion.move_tube(remove_speed)
			if visual_insertion.location() == GlobalVariable.area_of_lung.TUBE_OUT and is_inserted:
				removed_tube.emit()

	
func _on_between_button_press_timer_timeout() -> void:
	print("Not turning fast enough; cannot get enough mucus!")
	button_timed_out = true


func _on_how_long_sucking_timeout() -> void:
	GlobalVariable.oxygenation = false

func _on_too_short_timer_timeout() -> void:
	print("Time left: ", how_long_sucking.time_left)
func _on_removed_tube() -> void:
	if too_short_timer.time_left > 0:
		GlobalVariable.oxygenation_short = true
	GlobalVariable.mucus_amount = mucus_level
	if mucus_level != 0:
		print("There is mucus left!")
	else:
		print("All Mucus Clean")
		GlobalVariable.mucus_cleaned = true
	var how_long = how_long_sucking.time_left
	how_long_sucking.stop()
	reset()
	print("Time Left: ", how_long)
	

func _on_patient_hurt() -> void:
	patient_pain_level += 1
	if patient_pain_level == 10:
		game_over.emit()
