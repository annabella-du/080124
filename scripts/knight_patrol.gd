extends Node2D

@onready var knight = $Knight
@onready var left_patrol = $LeftPatrol
@onready var right_patrol = $RightPatrol

func _ready():
	knight.left_patrol = left_patrol.global_position.x
	knight.right_patrol = right_patrol.global_position.x
