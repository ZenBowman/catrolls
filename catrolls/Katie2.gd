extends KinematicBody2D

var speed = 350
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var animated_sprite = $AnimatedSprite
onready var left_button = $Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	var velocity = Vector2.ZERO
	if left_button.ACTION_MODE_BUTTON_PRESS:
		velocity -= Vector2.RIGHT
		animated_sprite.play("katiewalkingright")
	elif Input.is_key_pressed(KEY_K):
		velocity += Vector2.RIGHT
		animated_sprite.play("katiewalkingright")
	else:
		animated_sprite.play("default")
		animated_sprite.stop()
	position += (speed * velocity) * delta
