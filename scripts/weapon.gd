extends Node2D
class_name Weapon

@onready var timer = $ReloadTimer

@export var BulletScene: PackedScene

var parent_name: String

func _ready() -> void:
	var parent = get_parent()
	if parent:
		parent_name = parent.name

func fire(ship_velocity: Vector2) -> void:
	var bullet = BulletScene.instantiate()
	bullet.initial_velocity = ship_velocity
	bullet.direction = Vector2.from_angle(global_rotation).normalized()
	bullet.rotation = bullet.direction.angle()
	bullet.global_position = global_position
	bullet.parent_name = parent_name
	get_tree().root.add_child(bullet)

# Lessons:
#  This will need to be structured better in the future using 3 items:
#   1. Weapons Manager node: handles who shoots, total energy usage and total knockback
#   2. Weapon node: takes a projectile scene and projectile properties as input
#        It is responsible for spawning the projectile and setting it's properties
#   3. Projectile node: There will be multiple nodes of this type to account for different 
#        firing patters and creative uses for firing
