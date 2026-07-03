class_name UI
extends CanvasLayer

@onready var drift_display: Label = %DriftDisplay

var drift_state = false:
	set(new_state):
		drift_state = new_state

func _ready() -> void:
	pass
#	_update_drift_display(false)

func _update_drift_display(new_state):
	drift_state = new_state
	if drift_state:
		drift_display.text = "True"
	else:
		drift_display.text = "False"
