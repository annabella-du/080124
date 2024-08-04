extends Node

@onready var darks = get_tree().get_nodes_in_group("dark")
@onready var lights = get_tree().get_nodes_in_group("light")
@onready var player = get_tree().get_first_node_in_group("player")

var light_active := true
var paused := false

signal pause
signal unpause

func pause_func():
	pause.emit()

func _ready():
	light_on()

func _input(event):
	if event.is_action_pressed("pause") and !player.dead:
		if !paused:
			pause.emit()
			paused = true
		else:
			unpause.emit()
			paused = false
	
	if event.is_action_pressed("d1"):
		if light_active:
			light_off()
		else:
			light_on()

func light_on():
	light_active = true
	player.can_attack = false
	for i in darks:
		i.visible = false
	for j in lights:
		j.visible = true

func light_off():
	light_active = false
	player.can_attack = true
	for i in darks:
		i.visible = true
	for j in lights:
		j.visible = false
