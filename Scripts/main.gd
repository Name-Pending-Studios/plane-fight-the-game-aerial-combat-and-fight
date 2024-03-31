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

	"""var bogey = BasicBogey.instantiate()
	add_child(bogey)
	bogey.position = Vector2(240,randi()%360-180)
	bogey.MAX_SPEED = (randi()%350)/100. + 1.5 as float
	bogey.MAX_BULLET_COOL_DOWN = (randi() % (250 - 150)) + 150"""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
