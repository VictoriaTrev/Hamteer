extends Node

enum area_of_lung {
	TUBE_OUT,
	IN_TRACH,
	PERFECT_INSERT,
	INSIDE_LUNG
}

var mucus_cleaned = false
var mucus_amount

# Finish
var suction_properly:= true
var oxygenation_short:= false
var oxygenation:= true
var maintained_sterility:= true
