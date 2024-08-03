extends Node

@onready var darks = get_tree().get_nodes_in_group("dark")
@onready var lights = get_tree().get_nodes_in_group("light")

var light_active := true

func _ready():
	light_on()

func _input(event):
	if event.is_action_pressed("d1"):
		if light_active:
			light_off()
		else:
			light_on()

func light_on():
	light_active = true
	for i in darks:
		i.visible = false
	for j in lights:
		j.visible = true

func light_off():
	light_active = false
	for i in darks:
		i.visible = true
	for j in lights:
		j.visible = false
