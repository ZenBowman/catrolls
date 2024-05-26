extends Node2D

var timer: float = 0.0
var coyotespeed = 100.0
onready var kitten = $Snowy
onready var kittenBB = $Snowy/CollisionShape2D
onready var coyote1 = $Coyote1
onready var coyote1ProgressBar = $Coyote1/Coyote1/ProgressBar
onready var coyote2 = $Coyote2
onready var coyoteTrigger = $CoyoteTrigger
enum SceneState {
	STARTED_SCENE,
	POOPED,
	COYOTE_FIGHT,
}

var state = SceneState.STARTED_SCENE

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _on_snowy_attack():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color("ff0000")
	pass # Replace with function body.

func process_coyotefight(delta):
	coyote1.position.x = coyote1.position.move_toward(kitten.position, delta * coyotespeed).x

func process_pooped(delta):
	if (coyoteTrigger.get_overlapping_bodies().find(kitten) != -1):
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


func _on_Snowy_snowy_attack():
	coyote1ProgressBar.value -= 1
	var r = range_lerp(coyote1ProgressBar.value, 10, 100, 1, 0)
	var g = range_lerp(coyote1ProgressBar.value, 10, 100, 0, 1)
	
	print("Snowy attacked me!")
	pass # Replace with function body.
