extends Node2D

@export var potion : Resource
@onready var shoot_point = get_tree().get_first_node_in_group("shoot_point")

func shoot(dir : int):
	var new_potion = potion.instantiate()
	new_potion.global_position = shoot_point.global_position
	new_potion.dir = dir
	add_child(new_potion)
