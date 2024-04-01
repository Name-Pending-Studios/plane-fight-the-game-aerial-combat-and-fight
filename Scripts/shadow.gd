extends Node2D

@export var object : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	position = object.position + Vector2(-3,3)
	rotation = object.rotation
	$Sprite2D.modulate.a = .3
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_instance_valid(object): queue_free()
	if "health" in object and object.health<=0: queue_free()
	visible = true
	position = object.position + Vector2(-3,3)
	rotation = object.rotation
