extends Node2D

@export var asteroid_scene: PackedScene
@export var SEED := 12345
@export var n_asteroids := 20
@export var x_min := 0
@export var x_max := 1000
@export var y_min := 0
@export var y_max := 800

var asteroids = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	seed(SEED)
	for i in range(n_asteroids):
		# Create a new Sprite2D node dynamically
		var asteroid = asteroid_scene.instantiate()
		asteroid.position.x = randi_range(x_min, x_max) 
		asteroid.position.y = randi_range(y_min, y_max)
		add_child(asteroid) # Add it to the current node
		asteroids.append(asteroid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
