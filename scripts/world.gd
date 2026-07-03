class_name World
extends Node2D

#@export var ship: Spaceship
#@export var ui: UI

#func _ready() -> void:
#	if !ship.drift_changed.is_connected(ui._update_drift_display):
#		ship.drift_changed.connect(ui._update_drift_display)
