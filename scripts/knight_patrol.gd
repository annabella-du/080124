extends Node2D

@onready var knight = $Knight
@onready var left_patrol = $LeftPatrol
@onready var right_patrol = $RightPatrol
@onready var left_anim = $LeftPatrol/Torch
@onready var right_anim = $RightPatrol/Torch

var paused := false

func _ready():
	knight.left_patrol = left_patrol.global_position.x
	knight.right_patrol = right_patrol.global_position.x
	global.connect("pause", _on_global_pause)
	global.connect("unpause", _on_global_unpause)

func _on_global_pause():
	paused = true
	left_anim.pause()
	right_anim.pause()

func _on_global_unpause():
	paused = false
	left_anim.play()
	right_anim.play()
