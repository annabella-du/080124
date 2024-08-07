extends Area2D

"""
To-do:
	detect player, activate light
	display # coins needed to continue
	connect to player dissapear animation (add player appear animation too)
"""

### NODES ###
@onready var animation_node = $AnimationPlayer
@onready var activate_light_node = $ActivateLight

### VARIABLES ###
var can_interact := false

func _ready():
	animation_node.play("closed")
	activate_light_node.visible = false

func _on_body_entered(body):
	if body.name == "Player":
		can_interact = true
		activate_light_node.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		can_interact = false
		activate_light_node.visible = false
