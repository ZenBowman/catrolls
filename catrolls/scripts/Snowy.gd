extends KinematicBody2D

var speed: int = 502
var gravityspeed: int = 0
var angular_speed: int = PI
var groomtimer: float = 0.0
var on_obstacle: Area2D = null
onready var animated_sprite: AnimatedSprite = $AnimatedSprite

enum BellaState {
	GROUNDED,
	JUMPING,
	GROOMING
}

var current_state = BellaState.JUMPING
var velocity: Vector2 = Vector2.ZERO
var screen_size: Vector2
var timer = null

func collided(obstacle: Area2D):
	if (BellaState.JUMPING):
		if position.y <= obstacle.position.y:
			change_state_grounded()
			on_obstacle = obstacle
		else:
			gravityspeed += 200
	

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	timer = Timer.new()
	add_child(timer)

	timer.connect("timeout", self, "every_second")
	timer.set_wait_time(5.0)
	timer.set_one_shot(false) # Make sure it loops
	timer.start()
	
	velocity = Vector2.DOWN
	animated_sprite.play("default")

func every_second():
	pass
	#print(position.y)

func clamp_to_screen(someposition: Vector2):
	someposition.x = clamp(someposition.x, 0, screen_size.x-20)
	someposition.y = clamp(someposition.y, -1600, 50)
	return someposition

func process_grounded(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		if Input.is_action_pressed("ui_right"):
			velocity = (3*Vector2.UP) + Vector2.RIGHT
			speed = 150
		elif Input.is_action_pressed("ui_left"):
			velocity = (3*Vector2.UP) + Vector2.LEFT
			speed = 150
		else:
			velocity = Vector2.UP
		current_state = BellaState.JUMPING
	elif Input.is_action_pressed("ui_left"):
		velocity -= Vector2.RIGHT
		animated_sprite.play("runningleft")
	elif Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT
		animated_sprite.play("runningright")
	elif Input.is_action_pressed("ui_accept"):
		groomtimer = 0.0
		current_state = BellaState.GROOMING
		animated_sprite.play("grooming")
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("default")
		animated_sprite.stop()
	position += (speed * velocity) * delta
	if (on_obstacle != null):
		# Check if we have fallen off the obstacle
		if (on_obstacle.get_overlapping_areas().find(self) == -1):
			velocity = Vector2.ZERO
			current_state = BellaState.JUMPING
			on_obstacle = null
	position = clamp_to_screen(position)

func change_state_grounded():
	speed = 500
	gravityspeed = 0
	current_state = BellaState.GROUNDED

func process_jumping(delta):
	animated_sprite.play("jumping")
	gravityspeed += 3 	# gravity
	position += ((gravityspeed * Vector2.DOWN) + (speed * velocity)) * delta
	position = clamp_to_screen(position)
	if (position.y >= 50):
		change_state_grounded()	

func process_grooming(delta):
	groomtimer += delta	
	if (groomtimer > 2.0):
		animated_sprite.play("default")
		current_state = BellaState.GROUNDED
		groomtimer = 0.0

func _process(delta):
	if (current_state == BellaState.GROUNDED):
		process_grounded(delta)
	elif (current_state == BellaState.JUMPING):
		process_jumping(delta)
	elif (current_state == BellaState.GROOMING):
		process_grooming(delta)
