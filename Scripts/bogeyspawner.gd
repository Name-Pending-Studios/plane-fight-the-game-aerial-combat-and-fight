extends Node2D

# scene exports
@export var BasicBogey : PackedScene

# constants

# prog
var wave := 0 as int
var maxwavecooldown := 120 as int
var wavecooldown := maxwavecooldown
var difficulty := 1 as int
var bogeys := [null]

# dimensions
var maxx : float
var minx : float
var length : float
var maxy : float
var miny : float
var height : float


# Called when the node enters the scene tree for the first time.
func _ready():
	maxx = 240#get_viewport().get_visible_rect().end[0]
	maxy = 180#get_viewport().get_visible_rect().end[1]
	minx = -240#get_viewport().get_visible_rect().position[0]
	miny = -180#get_viewport().get_visible_rect().position[1]
	length = maxx - minx
	height = maxy - miny

	bogeys = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if nobogeys():
		bogeys = []
	updatedifficulty()
	updatewave()

func updatedifficulty():
	if bogeys == []:
		if wave>=3:
			wave = 0
			difficulty+=1
			if difficulty%3==0: maxwavecooldown+=60

func updatewave():
	if wavecooldown<=0 and wave<3:
		wave+=1
		wavecooldown = maxwavecooldown
		populate()
	elif wavecooldown>0: wavecooldown-=1

func nobogeys():
	for b in bogeys:
		if is_instance_valid(b):
			return false
	return true

func populate():
	for i in range(difficulty):
		spawnbogey(BasicBogey)

func spawnbogey(blueprint):
	bogeys.append(blueprint.instantiate())
	add_child(bogeys[-1])
	bogeys[-1].position = getrandomedgeposition()
	bogeys[-1].MAX_SPEED = (randi()%300)/100. + 1.5 as float
	bogeys[-1].MAX_BULLET_COOL_DOWN = (randi() % (250 - 150)) + 150

func getrandomedgeposition():
	var redge := randi() % 4
	match redge: 
		0: return Vector2(minx, (randi() % (height as int)) + miny)		# left
		1: return Vector2((randi() % int(length)) + minx, miny)			# top
		2: return Vector2(maxx, (randi() % (height as int)) + miny)		# right
		3: return Vector2((randi() % int(length)) + minx, maxy)			# bottom
