extends Node2D

var timer: float = 0.0
var coyotespeed = 100.0

onready var kitten = $Snowy
onready var kittenArea = $Snowy/Area2D
onready var kittenBB = $Snowy/Area2D/CollisionShape2D

onready var coyote1 = $Coyote1
onready var coyote1ProgressBar = $Coyote1/Coyote1/ProgressBar
onready var coyote1Collision = $Coyote1/Area2D

onready var coyote2 = $Coyote2
onready var coyoteTrigger = $CoyoteTrigger
onready var coyote2ProgressBar = $Coyote2/Coyote2/ProgressBar

signal coyote1_dead

enum SceneState {
	STARTED_SCENE,
	POOPED,
	COYOTE_FIGHT,
	COYOTE2_FIGHT
}

var state = SceneState.STARTED_SCENE

func _on_snowy_attack():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color("ff0000")
	pass # Replace with function body.

func target_kitten_position():
	return Vector2(kitten.position.x + 100, kitten.position.y)

func process_coyotefight(delta):
	coyote1.position.x = coyote1.position.move_toward(target_kitten_position(), delta * coyotespeed).x

func process_coyote2fight(delta):
	coyote2.position.x = coyote2.position.move_toward(kitten.position, delta * coyotespeed).x

func process_pooped(delta):
	if (coyoteTrigger.get_overlapping_bodies().find(kitten) != -1):
		print("starting fight")
		state = SceneState.COYOTE_FIGHT

func process_started_scene(delta):
	timer += delta
	if timer >= 2.0:
		$Magicatpoop.transform.x = $Snowy.transform.x
		$Magicatpoop.transform.y = $Snowy.transform.y
		$Magicatpoop.scale *= 0.05
		
		$Magicatpoop.show()
		state = SceneState.POOPED

func _process(delta):
	if state == SceneState.STARTED_SCENE:
		process_started_scene(delta)
	elif state == SceneState.POOPED:
		process_pooped(delta)
	elif state == SceneState.COYOTE_FIGHT:
		process_coyotefight(delta)
	elif state == SceneState.COYOTE2_FIGHT:
		process_coyote2fight(delta)


func _on_Snowy_snowy_attack():
	if (coyote1Collision.overlaps_area(kittenArea)):
		coyote1ProgressBar.value -= 1
		var r = range_lerp(coyote1ProgressBar.value, 10, 100, 1, 0)
		var g = range_lerp(coyote1ProgressBar.value, 10, 100, 0, 1)
	if (coyote1ProgressBar.value == 0):
		state = SceneState.COYOTE2_FIGHT
		emit_signal("coyote1_dead")


func _on_SnowyScene3_coyote1_dead():
	pass # Replace with function body.
