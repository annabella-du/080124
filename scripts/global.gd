extends Node

### PLAYER NODE ###
@onready var player = get_tree().get_first_node_in_group("player")

### ARRAY OF NODES IN GROUPS ###
@onready var darks = get_tree().get_nodes_in_group("dark")
@onready var lights = get_tree().get_nodes_in_group("light")
@onready var levers = get_tree().get_nodes_in_group("lever")

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
	if event.is_action_pressed("pause") and !player.dead:
		if !paused:
			pause_signal.emit()
			paused = true
		else:
			unpause_signal.emit()
			paused = false

### LIGHTING FUNCTIONS ###
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

### EMIT SIGNAL FUNCTIONS ###
func died():
	respawn_signal.emit()

func pause_func():
	pause_signal.emit()
