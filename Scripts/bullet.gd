extends Node2D

# constants
var speed := 7.5 as float

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.area_entered.connect(_on_area_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	position = position + Vector2(speed*cos(rotation-PI/2),speed*sin(rotation-PI/2)) # move forward

func _on_area_entered(area):
	queue_free()
