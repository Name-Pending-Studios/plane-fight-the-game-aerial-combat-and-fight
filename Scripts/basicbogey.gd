extends Node2D

# exports and constants
@export var Bullet : PackedScene
@export var MAX_SPEED := 5 as float

var MAX_ANGULAR_VELOCITY := .15 as float
var ANGULAR_ACCELERATION := .03 as float
var ACCELERATION := .2 as float

# physics
var angularvelocity := 0 as float
var speed := 0 as float

# stats
var health := 100 as float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#get_node("../Player")==null

func _physics_process(delta):
	control() 	# manipulate acceleration (randomness)
	physics()	# manipulate location
	#cooldowns() # manage cooldowns

func control():
	if desireddirection()==0:
		if angularvelocity > -1*MAX_ANGULAR_VELOCITY: angularvelocity-=ANGULAR_ACCELERATION
		else: angularvelocity = MAX_ANGULAR_VELOCITY*-1
	else:
		if angularvelocity < MAX_ANGULAR_VELOCITY: angularvelocity+=ANGULAR_ACCELERATION
		else: angularvelocity = MAX_ANGULAR_VELOCITY

	if speed < MAX_SPEED: speed+=ACCELERATION
	else: speed = MAX_SPEED

func physics():
	rotation+=angularvelocity
	position+=speed*getforwardvector()

func desireddirection(): # 0 is counterclockwise 1 is clockwise
	var player = get_node_or_null("../Player")
	if player!=null:
		# i really don't know how this works, i forgor linear algebra. but it does! work
		if Vector2(cos(rotation-PI),sin(rotation-PI)).dot((position - player.position).normalized()) < 0: 
			return 0
		else: return 1
	else:
		if Vector2(cos(rotation+PI),sin(rotation+PI)).dot((position - Vector2(1000,1000)).normalized()) < 0: 
			return 0
		else: return 1

func getforwardvector():
	return Vector2(cos(rotation-PI/2),sin(rotation-PI/2))