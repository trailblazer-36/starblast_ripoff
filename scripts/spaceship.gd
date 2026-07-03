extends CharacterBody2D
class_name Spaceship

@export var ACCELRATION = 60.0
@export var MAX_SPEED = 20.0
@export var DECELRATION = 60.0
@export var TRESHOLD = 3.0     # the speed where the player will stop moving if not accelerating
@export var MAX_ANGLE = 3.0
@export var MASS = 80.0

signal drift_changed(is_drifting)

var ship_direction = Vector2(1.0,0.0)
var is_drifting := false

@onready var weapon: Weapon = $Weapon
@onready var camera = $Camera2D as Camera2D

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	MAX_ANGLE = deg_to_rad(MAX_ANGLE)
	if is_multiplayer_authority(): 
		camera.make_current()



func update_direction(ship_direction: Vector2, target_direction: Vector2) -> Vector2:
	var angle_to_target = ship_direction.angle_to(target_direction)
	if angle_to_target > MAX_ANGLE:
		return ship_direction.rotated(MAX_ANGLE)
	elif angle_to_target < -MAX_ANGLE:
		return ship_direction.rotated(-MAX_ANGLE)
	else:
		return ship_direction.rotated(angle_to_target)

# https://www.youtube.com/watch?v=Uh9PSOORMmA
func _handle_collisions(collision: KinematicCollision2D):
	if collision and collision.get_collider() is RigidBody2D:
		var push_dir = -collision.get_normal()
		var velocity_diff_in_push_dir = velocity.dot(push_dir) - collision.get_collider().linear_velocity.dot(push_dir)
		# the positive velocity refers to the direction to the rigidbody being colided with
		var velocity_to_push_dir = max(0.0, velocity_diff_in_push_dir)
		var mass_ratio = MASS / collision.get_collider().mass
		
		collision.get_collider().apply_impulse(push_dir * velocity_to_push_dir * mass_ratio,
			collision.get_position() - collision.get_collider().global_position)
		
		print(push_dir * velocity_to_push_dir * mass_ratio)

func _physics_process(delta: float) -> void:
	# only the player assigned to this ship should be allowed to control it
	if !is_multiplayer_authority(): return
	
	var target_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	ship_direction = update_direction(ship_direction, target_direction).normalized()
	
	if Input.is_action_pressed("move"):
		velocity += ship_direction * ACCELRATION * delta
		if velocity.length() > MAX_SPEED:
			velocity = velocity.normalized() * MAX_SPEED
	else:
		if not is_drifting:
			if velocity.length() < TRESHOLD:
				velocity = Vector2.ZERO
			else:
				velocity -= velocity.normalized() * DECELRATION * delta
	
	rotation = ship_direction.angle()
	var collision = move_and_collide(velocity)
	_handle_collisions(collision)
	
	if Input.is_action_pressed("fire"):
		weapon.fire(velocity)
	
	if Input.is_action_just_pressed("drift"):
		is_drifting = not is_drifting
		drift_changed.emit(is_drifting)




# LESSONS:
#  the ship should only handle movement, inputs and collisions?
