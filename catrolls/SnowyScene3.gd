extends Node2D

var timer: float = 0.0
onready var cat = $Snowy

enum SceneState {
	STARTED_SCENE,
	POOPED,
}

var state = SceneState.STARTED_SCENE

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func process_started_scene(delta):
	timer += delta
	if timer >= 5.0:
		$Magicatpoop.transform.x = $Snowy.transform.x
		$Magicatpoop.transform.y = $Snowy.transform.y
		$Magicatpoop.scale *= 0.1
		
		$Magicatpoop.show()

func _process(delta):
	if state == SceneState.STARTED_SCENE:
		process_started_scene(delta)
