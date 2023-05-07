extends Node2D

onready var cat: KinematicBody2D = $Snowy
onready var door: Area2D = $Door

var deltasum: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	print(door.to_string())

func check_if_goal_reached():
	if (door.get_overlapping_bodies().find(cat) != -1):
		get_tree().change_scene("res://Scene1Complete.tscn")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_if_goal_reached()

func _on_Button_pressed():
	get_tree().change_scene("res://ChooseYourCharacter.tscn")
