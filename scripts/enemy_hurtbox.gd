extends Area2D

@onready var knight = get_parent()

func _input(_event):
	#if event.is_action_pressed("d2"):
		#hurt()
	pass

func hurt():
	if !knight.hurt:
		knight.hurt_func()
