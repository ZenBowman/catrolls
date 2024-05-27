extends AnimatedSprite

var timer: float = 0.0

enum CoyoteState {
	NORMAL,
	ATTACKING,
	DEAD
}

var state = CoyoteState.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if state == CoyoteState.NORMAL:
		timer += delta
		if (timer > 5.0):
			state = CoyoteState.ATTACKING
			play("attack")
			timer = 0.0
	elif state == CoyoteState.ATTACKING:
		timer += delta
		if (timer > 1.0):
			state = CoyoteState.NORMAL
			play("default")
			timer = 0.0

func _on_SnowyScene3_coyote1_dead():
	play("dead")
	state = CoyoteState.DEAD

