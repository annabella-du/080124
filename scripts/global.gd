extends Node

### PLAYER NODE ###
@onready var player_node = get_tree().get_first_node_in_group("player")

### ARRAY OF NODES IN GROUPS ###
@onready var dark_nodes = get_tree().get_nodes_in_group("dark")
@onready var light_nodes = get_tree().get_nodes_in_group("light")
@onready var lever_nodes = get_tree().get_nodes_in_group("lever")

### VARIABLES ###
var light_active := true
var paused := false
var active_checkpoint : Area2D

### CUSTOM SIGNALS ###
signal pause_signal
signal unpause_signal
signal respawn_signal

### BUILT IN FUNCTIONS ###
func _input(event):
	### PAUSE AND UNPAUSE ###
	if event.is_action_pressed("pause") and !player_node.dead:
		if !paused:
			pause_signal.emit()
			paused = true
		else:
			unpause_signal.emit()
			paused = false

### LIGHTING FUNCTIONS ###
func light_on():
	light_active = true
	player_node.can_attack = true
	for dark in dark_nodes:
		dark.visible = false
	for light in light_nodes:
		light.visible = true
	for lever in lever_nodes:
		lever.on()

func light_off():
	light_active = false
	player_node.can_attack = false
	for dark in dark_nodes:
		dark.visible = true
	for light in light_nodes:
		light.visible = false
	for lever in lever_nodes:
		lever.off()

### EMIT SIGNAL FUNCTIONS ###
func died():
	respawn_signal.emit()

func pause_func():
	pause_signal.emit()
