extends Node2D

### NODES ###
@onready var shoot_point = get_tree().get_first_node_in_group("shoot_point")

### VARIABLES ###
@export var potion : Resource

### CUSTOM FUNCTIONS ###
func shoot(dir : int):
	var new_potion = potion.instantiate()
	new_potion.global_position = shoot_point.global_position
	new_potion.dir = dir
	add_child(new_potion)
