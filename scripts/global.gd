extends Node

@onready var darks = get_tree().get_nodes_in_group("dark")
@onready var lights = get_tree().get_nodes_in_group("light")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var levers = get_tree().get_nodes_in_group("lever")

var light_active := true
var paused := false

signal pause
signal unpause

func _input(event):
	if event.is_action_pressed("pause") and !player.dead:
		if !paused:
			pause.emit()
			paused = true
		else:
			unpause.emit()
			paused = false

func light_on():
	light_active = true
	player.can_attack = true
	for i in darks:
		i.visible = false
	for j in lights:
		j.visible = true
	for k in levers:
		k.on()

func light_off():
	light_active = false
	player.can_attack = false
	for i in darks:
		i.visible = true
	for j in lights:
		j.visible = false
	for k in levers:
		k.off()

func pause_func():
	pause.emit()
