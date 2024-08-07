extends Area2D

### NODES ###
@onready var player_node = get_tree().get_first_node_in_group("player")
@onready var animation_node = $AnimationPlayer
@onready var activate_light_node = $ActivateLight

### VARIABLES ###
enum color {red, green, blue}
@export var chest_color : color
var can_interact = false
var opened = false
var saved = false #changed to true only with global function

### BUILT IN FUNCTIONS ###
func _ready():
	activate_light_node.visible = false

func _physics_process(_delta):
	if can_interact and Input.is_action_just_pressed("interact") and !saved:
		opened = true
		activate_light_node.visible = false
		animation_node.play("open")
		player_node.pickup_key(chest_color)

### CUSTOM FUNCTIONS ###
func respawn():
	animation_node.play("close")
	opened = false

### AREA2D FUNCTIONS ###
func _on_body_entered(body):
	if body.name == "Player":
		if !opened:
			activate_light_node.visible = true
			can_interact = true

func _on_body_exited(body):
	if body.name == "Player":
		activate_light_node.visible = false
		can_interact = false
