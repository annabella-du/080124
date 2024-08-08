extends Area2D

"""
To-do:
	connect to player dissapear animation (add player appear animation too)
"""

### NODES ###
@onready var player_node = get_tree().get_first_node_in_group("player")
@onready var animation_node = $AnimationPlayer
@onready var activate_light_node = $ActivateLight
@onready var label = $Label

### VARIABLES ###
@export var coins_to_exit := 10
var can_exit := false

func _ready():
	animation_node.play("closed")
	activate_light_node.visible = false
	label.visible = false

func _input(event):
	if event.is_action_pressed("interact") and can_exit:
		print("game over")

func _on_body_entered(body):
	if body.name == "Player":
		activate_light_node.visible = true
		if player_node.coins >= coins_to_exit:
			can_exit = true
			label.text = "interact to exit"
		else:
			label.text = "%d coins to exit" % coins_to_exit
		label.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		can_exit = false
		activate_light_node.visible = false
		label.visible = false
