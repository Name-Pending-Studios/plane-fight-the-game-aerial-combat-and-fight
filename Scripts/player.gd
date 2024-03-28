extends Node2D

@export var Bullet : PackedScene

# graphics
var MainJet : Sprite2D
var ReverseJet : Sprite2D
var LeftJet : Sprite2D
var RightJet : Sprite2D
var ReverseLeftJet : Sprite2D
var ReverseRightJet : Sprite2D
var Death : AnimatedSprite2D
var states : Array

# physics
var angularvelocity : float
var velocity : float

# constants
var MAX_VELOCITY := 4.5 as float
var MAX_ANGULAR_VELOCITY := .15 as float
var ACCELERATION := .2 as float
var ANGULAR_ACCELERATION := .03 as float

# Called when the node enters the scene tree for the first time.
func _ready():
	# graphics
	MainJet = $mainjet as Sprite2D
	ReverseJet = $reversejet as Sprite2D
	LeftJet = $leftjet as Sprite2D
	RightJet = $rightjet as Sprite2D
	ReverseLeftJet = $reverseleftjet as Sprite2D
	ReverseRightJet = $reverserightjet as Sprite2D
	Death = $death as AnimatedSprite2D
	velocity = 0.
	angularvelocity = 0.
	states=[]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updatesprites()

func _physics_process(delta):
	states = [] # reset states
	control() 	# handle input
	physics()	# manipulate physics

func updatesprites():
	if "driving" in states: 
		MainJet.visible = true
	else: MainJet.visible = false

	if "reversing" in states: ReverseJet.visible = true
	else: ReverseJet.visible = false

	if "left" in states: 
		if "reversing" not in states: RightJet.visible = true
		else: ReverseLeftJet.visible = true
	else: 
		RightJet.visible = false
		ReverseLeftJet.visible = false

	if "right" in states: 
		if "reversing" not in states: LeftJet.visible = true
		else: ReverseRightJet.visible = true
	else: 
		LeftJet.visible = false
		ReverseRightJet.visible = false


func control():
	if Input.is_action_pressed("drive"):
		states.append("driving")
		if velocity < MAX_VELOCITY:
			velocity += ACCELERATION
		else:
			velocity = MAX_VELOCITY

	if Input.is_action_pressed("reverse"):
		states.append("reversing")
		if velocity > -1*MAX_VELOCITY:
			velocity -= ACCELERATION
		else:
			velocity = -1*MAX_VELOCITY

	if Input.is_action_pressed("leftboost"):
		states.append("left")
		if angularvelocity > -1*MAX_ANGULAR_VELOCITY:
			angularvelocity -= ANGULAR_ACCELERATION
		else:
			angularvelocity = -1*MAX_ANGULAR_VELOCITY
	
	if Input.is_action_pressed("rightboost"):
		states.append("right")
		if angularvelocity < MAX_ANGULAR_VELOCITY:
			angularvelocity += ANGULAR_ACCELERATION
		else:
			angularvelocity = MAX_ANGULAR_VELOCITY

	if Input.is_action_pressed("shoot"):
		print("shot")
	


func physics():
	# position
	position = position + getvelocityvector()
	velocity *= .93

	# rotation
	rotation += angularvelocity
	angularvelocity*=.75

func getvelocityvector():
	return Vector2(velocity*cos(rotation-PI/2),velocity*sin(rotation-PI/2))