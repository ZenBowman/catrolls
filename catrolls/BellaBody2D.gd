extends KinematicBody2D

var speed = 350
var angular_speed = PI

onready var animated_sprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Make Bella rotate every frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity -= Vector2.RIGHT
		animated_sprite.play("walkingleft")
	elif Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT
		animated_sprite.play("walkingright")
	else:
		animated_sprite.play("default")
		animated_sprite.stop()
	position += (speed * velocity) * delta
