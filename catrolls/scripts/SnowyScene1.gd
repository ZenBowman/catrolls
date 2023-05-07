extends 	Node2D

onready var cat: KinematicBody2D = $Snowy
onready var door: Area2D = $Door
onready var obstacle1: Area2D = $obstacle1
onready var obstacle2: Area2D = $obstacle2
onready var obstacle3: Area2D = $obstacle3

onready var obstacles = [obstacle1, obstacle2, obstacle3]

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
	check_collisions()
	var obstaclepos = obstacle1.find_node("CollisionShape2D").position
	$HeadsUpDisplay/CatPosition.text = "Cat position: " + str(cat.position.x).pad_decimals(2) + ", " + str(cat.position.y).pad_decimals(2)
	$HeadsUpDisplay/ObstaclePosition.text = "Obstacle position: " + str(obstaclepos.x).pad_decimals(2) + ", " + str(obstaclepos.y).pad_decimals(2)
	
func check_collisions():
	for obstacle in obstacles:
		if (obstacle.get_overlapping_bodies().find(cat) != -1):
			cat.call("collided", obstacle)

func _on_Button_pressed():
	get_tree().change_scene("res://ChooseYourCharacter.tscn")
