extends CanvasLayer

@onready var ox_label: Label = $Control/OxLabel
@onready var sterile_label: Label = $Control/SterileLabel
@onready var suction_label: Label = $Control/SuctionLabel

var suction_positive:= "You suctioned for the expected 10-15 seconds!"
var oxy_positive:= "You ensured proper oxygenation in between passes!"
var sterile_positive:= "You maintained sterility while applying suctioning."

var suction_neg:= "You suctioned for too long!! Suctioning for longer than 10-15 seconds puts the patient at a higher risk for damage or trauma "
var oxy_short:= "You didn’t suction long enough!! Suctioning for less than 8-10 seconds makes the chances higher that you may need more passes to clear the secretions. After three passes the patient cannot tolerate more passes as each pass is creating the chance for trauma and exposing the patient to periods of hypoxia."
var oxy_long:= "You forgot to oxygenate the patient between passes! The patient needs the period of oxygen because the process of tracheostomy suctioning deprives them of the oxygen, they need it supplemented after each pass. " 

func _ready() -> void:
	if GlobalVariable.oxygenation:
		ox_label.text = oxy_positive
	elif GlobalVariable.oxygenation_short or !GlobalVariable.oxygenation:
		if GlobalVariable.oxygenation_short and !GlobalVariable.oxygenation:
			ox_label.text = str(oxy_long, "/n", oxy_short)
	if GlobalVariable.suction_properly:
		suction_label.text = suction_positive
	elif !GlobalVariable.suction_properly:
		suction_label.text = suction_neg
	if GlobalVariable.maintained_sterility:
		sterile_label.text = sterile_positive
