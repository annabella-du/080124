extends Node2D

### NODES ###
@onready var knight_node = $Knight
@onready var left_patrol_node = $LeftPatrol
@onready var right_patrol_node = $RightPatrol
@onready var left_anim_node = $LeftPatrol/Torch
@onready var right_anim_node = $RightPatrol/Torch

### VARIABLES ###
var paused := false #used to pause animations

### BUILT IN FUNCTIONS ###
func _ready():
	### CONNECT SIGNALS ###
	global.connect("pause_signal", _on_global_pause)
	global.connect("unpause_signal", _on_global_unpause)
	### SET INITIAL VALUES ###
	knight_node.left_patrol = left_patrol_node.global_position.x
	knight_node.right_patrol = right_patrol_node.global_position.x

### CUSTOM SIGNAL FUNCTIONS ###
func _on_global_pause():
	paused = true
	left_anim_node.pause()
	right_anim_node.pause()

func _on_global_unpause():
	paused = false
	left_anim_node.play()
	right_anim_node.play()
