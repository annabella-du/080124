extends Area2D

### NODES ###
@onready var global = get_node("/root/global")
@onready var player_node = get_tree().get_first_node_in_group("player")
@onready var animation_node = $AnimationPlayer

### VARIABLES ###
var can_interact = false
var open = false
var saved = false #changed to true only with global function

### BUILT IN FUNCTIONS ###
func _ready():
	global.connect("respawn_signal", _on_global_respawn)

func _physics_process(_delta):
	if can_interact and Input.is_action_just_pressed("interact"):
		open = true
		animation_node.play("open")
		player_node.unsaved_keys += 1

### CUSTOM FUNCTIONS ###
func respawn():
	animation_node.play("close")
	open = false

### AREA2D FUNCTIONS ###
func _on_body_entered(body):
	if body.name == "Player":
		can_interact = true

func _on_body_exited(body):
	if body.name == "Player":
		can_interact = false

### CUSTOM SIGNAL FUNCTIONS ###
func _on_global_respawn():
	respawn()
