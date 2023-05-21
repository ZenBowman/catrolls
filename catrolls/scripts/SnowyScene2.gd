extends Node2D

var timer: float = 0.0
onready var static_colony_members = [
	$Scene2Colony/Bellastandingtransparent, $Scene2Colony/KenyaStanding, 
	$Scene2Colony/KikaStanding, $Scene2Colony/OreoStanding, 
	$Scene2Colony/TomStanding
	]
	
onready var animated_colony_members = [$Scene2Colony/KatieStanding,]
onready var cat = $Snowy

enum SceneState {
	STARTED_SCENE,
	DIALOG1,
	SNOWY_DIALOG_1_SELECT,
	DIALOG2,
	COLONY_WALKS_RIGHT
}

var state = SceneState.STARTED_SCENE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func process_colony_walking(delta):
	for m in static_colony_members:
		m.position += Vector2.RIGHT * delta * 100	
	for m in animated_colony_members:
		m.position += Vector2.RIGHT * delta * 100			
		m.play("walkingright")
	if abs(cat.position.x - get_viewport_rect().size.x) < 100:
		get_tree().change_scene("res://SnowyScene3.tscn")
		

func change_state(newstate):
	state = newstate
	timer = 0.0
	print("Changed state to " + str(newstate))

func process_snowy_dialog1_select(delta):
	$Dialog/SnowyDialog1Select.show()

func process_started_scene(delta):
	timer += delta
	if timer >= 2.0:
		$Dialog/Dialog1.show()
		change_state(SceneState.DIALOG1)
		
func process_dialog_1(delta):
	timer += delta
	if timer >= 6.0:
		$Dialog/Dialog1.hide()
		change_state(SceneState.SNOWY_DIALOG_1_SELECT)
	print(timer)

func process_dialog2(delta):
	timer += delta
	if timer <= 3.0:
		$Dialog/OhOkay.show()
	elif timer <= 8.0:
		$Dialog/OhOkay.hide()
		$Dialog/GoingToFightCoyotes.show()
	else:
		$Dialog/OhOkay.hide()
		$Dialog/GoingToFightCoyotes.hide()
		change_state(SceneState.COLONY_WALKS_RIGHT)


func _process(delta):
	if state == SceneState.STARTED_SCENE:
		process_started_scene(delta)
	elif state == SceneState.DIALOG1:
		process_dialog_1(delta)
	elif state == SceneState.SNOWY_DIALOG_1_SELECT:
		process_snowy_dialog1_select(delta)
	elif state == SceneState.DIALOG2:
		process_dialog2(delta)
	elif state == SceneState.COLONY_WALKS_RIGHT:
		process_colony_walking(delta)


func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://ChooseYourCharacter.tscn")


func dialog1selected():
	$Dialog/SnowyDialog1Select.hide()
	change_state(SceneState.DIALOG2)

func _on_Button2_pressed():
	dialog1selected()


func _on_Button_pressed():
	dialog1selected()


func _on_Button3_pressed():
	dialog1selected()
