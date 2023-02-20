extends KinematicBody2D

var speed: int = 350
var angular_speed: int = PI
onready var animated_sprite: AnimatedSprite = $AnimatedSprite

enum BellaState {
	GROUNDED,
	JUMPING
}

var current_state = BellaState.GROUNDED
var velocity: Vector2 = Vector2.ZERO
var screen_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

func clamp_to_screen(someposition: Vector2):
	someposition.x = clamp(someposition.x, 20, screen_size.x-20)
	someposition.y = clamp(someposition.y, 100, screen_size.y-100)
	return someposition

func process_grounded(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity -= Vector2.RIGHT
		animated_sprite.play("walkingleft")
	elif Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT
		animated_sprite.play("walkingright")
	elif Input.is_action_pressed("ui_up"):
		velocity = Vector2.UP
		current_state = BellaState.JUMPING
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("default")
		animated_sprite.stop()
	position += (speed * velocity) * delta
	position = clamp_to_screen(position)

func process_jumping(delta):
	animated_sprite.play("jumping")
	speed -= 3 	# gravity
	position += (speed * velocity) * delta
	position = clamp_to_screen(position)
	if (position.y >= (screen_size.y-100)):
		speed = 350
		current_state = BellaState.GROUNDED

func _process(delta):
	if (current_state == BellaState.GROUNDED):
		process_grounded(delta)
	elif (current_state == BellaState.JUMPING):
		process_jumping(delta)
	
