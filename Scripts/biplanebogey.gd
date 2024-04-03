extends Node2D

# exports and constants
@export var Bullet : PackedScene
@export var Shadow : PackedScene
@export var MAX_SPEED := (randi()%300)/100. + 2 as float
@export var MAX_BULLET_COOL_DOWN := (randi() % (250 - 150)) + 200 as int as int
@export var MIN_BULLET_COOL_DOWN := 50 as int

var MAX_ANGULAR_VELOCITY := .09 as float
var ANGULAR_ACCELERATION := .03 as float
var ACCELERATION := .2 as float
var X_BORDER := 240
var Y_BORDER := 180

# physics
var angularvelocity := 0 as float
var speed := 0 as float

# stats
@export var health := 200 as float

# graphics
var states : Array

# cooldowns
var bulletcooldown := MAX_BULLET_COOL_DOWN*1.5 as int
var hitcooldown := 0 as int

# Called when the node enters the scene tree for the first time.
func _ready():
	states = []
	var s = Shadow.instantiate()
	s.object = self
	add_sibling(s)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if "dying" in states: 
		return
	control() 	# manipulate acceleration (randomness)
	physics()	# manipulate location
	cooldowns() # manage cooldowns

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

	# handling borders
	if position.x > X_BORDER: position.x = X_BORDER
	elif position.x < -1*X_BORDER: position.x = -1*X_BORDER
	if position.y > Y_BORDER: position.y = Y_BORDER
	elif position.y < -1*Y_BORDER: position.y = -1*Y_BORDER

func cooldowns():
	if bulletcooldown <= 0:
		shoot()
	else: bulletcooldown-=1
	if hitcooldown <= 0: modulate.v = 1
	else: hitcooldown -= 1

func desireddirection(): # 0 is counterclockwise 1 is clockwise
	var player = get_node("/root/Main/Player")
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

func _on_area_entered(area:Area2D):
	if area.is_in_group("playerprojectile"):
		health -= area.get_parent().damage
		hit()

func hit():
	if "dying" in states: return
	if health <= 0 and "dying" not in states:
		$jet.visible = false
		$Sprite2D.visible = false
		$anim.visible = true
		$anim.play("death")
		$Area2D.queue_free()
		states.append("dying")
	modulate.v = 15
	hitcooldown = 10

func _on_animation_looped():
	if "dying" in states:
		queue_free()

func shoot():
	var bullet := Bullet.instantiate() as Node2D
	add_sibling(bullet)
	bullet.damage = 20
	bullet.position = position+getforwardvector()
	bullet.rotation = rotation

	if "shooting" in states: 
		bulletcooldown = (randi() % (MAX_BULLET_COOL_DOWN - MIN_BULLET_COOL_DOWN)) + MIN_BULLET_COOL_DOWN
		states.erase("shooting")
	else:
		bulletcooldown = 20
		states.append("shooting")