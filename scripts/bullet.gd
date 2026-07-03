extends Area2D
class_name Bullet

@export var SPEED = 1200
@export var lifetime = 1000

var direction := Vector2()
var initial_velocity := Vector2.ZERO
var parent_name: String

func _enter_tree() -> void:
	set_multiplayer_authority(parent_name.to_int())

func _physics_process(delta: float) -> void:
	
	if lifetime == 0:
		queue_free()
	position += ((direction.normalized() * SPEED) + initial_velocity) * delta
	rotation = direction.angle()
	lifetime -= 1
