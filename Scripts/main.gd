extends Node

@export var Player : PackedScene
var player : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("instantiating")
	player = Player.instantiate()
	add_child(player)
	player.position = Vector2(0,0)
	print(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
