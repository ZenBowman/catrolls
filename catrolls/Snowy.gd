extends KinematicBody2D

var speed: int = 350
var gravityspeed: int = 0
var angular_speed: int = PI
onready var animated_sprite: AnimatedSprite = $AnimatedSprite

enum BellaState {
	GROUNDED,
	JUMPING
}

var current_state = BellaState.JUMPING
var velocity: Vector2 = Vector2.ZERO
var screen_size: Vector2
var timer = null

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

func every_second():
	pass
	#print(position.y)

func clamp_to_screen(someposition: Vector2):
	someposition.x = clamp(someposition.x, 0, screen_size.x-20)
	someposition.y = clamp(someposition.y, -1000, 50)
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
		#animated_sprite.play("walkingleft")
	elif Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT
		#animated_sprite.play("walkingright")
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("default")
		animated_sprite.stop()
	position += (speed * velocity) * delta
	position = clamp_to_screen(position)

func process_jumping(delta):
	#animated_sprite.play("jumping")
	gravityspeed += 3 	# gravity
	position += ((gravityspeed * Vector2.DOWN) + (speed * velocity)) * delta
	position = clamp_to_screen(position)
	if (position.y >= 50):
		speed = 350
		gravityspeed = 0
		current_state = BellaState.GROUNDED

func _process(delta):
	if (current_state == BellaState.GROUNDED):
		process_grounded(delta)
	elif (current_state == BellaState.JUMPING):
		process_jumping(delta)
