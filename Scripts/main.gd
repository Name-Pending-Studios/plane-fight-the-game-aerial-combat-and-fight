extends Node

@export var Player : PackedScene
@export var BasicBogey : PackedScene
var player : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("instantiating")
	player = Player.instantiate()
	add_child(player)
	player.position = Vector2(0,0)

	var bogey = BasicBogey.instantiate()
	add_child(bogey)
	bogey.position = Vector2(240,randi()%360-180)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
