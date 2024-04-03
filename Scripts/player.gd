extends Node2D

@export var Bullet : PackedScene
@export var Shadow : PackedScene

# stats
var health := 100 as float

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
var MAX_VELOCITY := 5 as float
var MAX_ANGULAR_VELOCITY := .15 as float
var ACCELERATION := .25 as float
var ANGULAR_ACCELERATION := .03 as float
var XBORDER := 240
var YBORDER := 180
var BULLET_COOL_DOWN := 12
var MAX_HEALTH := 100 as float

# cooldowns
var bulletcooldown := 0
var hitcooldown := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# signals
	$Area2D.area_entered.connect(_on_area_entered)

	# graphics
	MainJet = $mainjet as Sprite2D
	ReverseJet = $reversejet as Sprite2D
	LeftJet = $leftjet as Sprite2D
	RightJet = $rightjet as Sprite2D
	ReverseLeftJet = $reverseleftjet as Sprite2D
	ReverseRightJet = $reverserightjet as Sprite2D
	Death = $death as AnimatedSprite2D
	var s = Shadow.instantiate()
	s.object = self
	add_sibling(s)
	velocity = 0.
	angularvelocity = 0.
	states=[]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updatesprites()

func _physics_process(delta):
	for s in ["driving","reversing","left","right"]: if s in states: states.erase(s)
	control() 	# handle input
	physics()	# manipulate physics
	cooldowns() # manage cooldowns

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

func _on_area_entered(area):
	if area.is_in_group("bogeyprojectile"):
		health -= area.get_parent().damage
		hit()

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
		shoot()
	


func physics():
	# position
	position = position + getvelocityvector()
	velocity *= .95

	# rotation
	rotation += angularvelocity
	angularvelocity*=.75

	# handling borders
	if position.x > XBORDER: position.x = XBORDER
	elif position.x < -1*XBORDER: position.x = -1*XBORDER
	if position.y > YBORDER: position.y = YBORDER
	elif position.y < -1*YBORDER: position.y = -1*YBORDER

func cooldowns():
	if bulletcooldown!=0: bulletcooldown-=1
	if hitcooldown>=0: hitcooldown-=1
	else: modulate.v = 1

func getvelocityvector():
	return velocity*getforwardvector()

func shoot():
	if bulletcooldown!=0: return
	var bullet := Bullet.instantiate() as Node2D
	add_sibling(bullet)
	bullet.position = position+getforwardvector()
	bullet.rotation = rotation

	bulletcooldown=BULLET_COOL_DOWN

func getforwardvector():
	return Vector2(cos(rotation-PI/2),sin(rotation-PI/2))

func hit():
	hitcooldown = 10
	modulate.v = 15
	print(health)