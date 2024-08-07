extends StaticBody2D

### NODES ###
@onready var player_node = get_tree().get_first_node_in_group("player")
@onready var sprite_node = $Sprite2D
@onready var collision_node = $CollisionShape2D
@onready var activate_light_node = $ActivateLight

### VARIABLES ###
enum color {red, green, blue}
@export var gate_color : color
var can_interact := false
var opened := false
var saved := false

func _ready():
	activate_light_node.visible = false

func _physics_process(_delta):
	if can_interact and Input.is_action_just_pressed("interact") and !saved:
		match gate_color:
			0: #red
				if player_node.red_key == true:
					player_node.open_gate(0)
					open()
			1: #green
				if player_node.green_key == true:
					player_node.open_gate(1)
					open()
			2: #blue
				if player_node.blue_key == true:
					player_node.open_gate(2)
					open()

func open():
	opened = true
	sprite_node.visible = false
	collision_node.disabled = true
	activate_light_node.visible = false

func respawn():
	opened = false
	sprite_node.visible = true
	collision_node.disabled = false

func _on_detect_player_body_entered(body):
	if body.name == "Player":
		if !opened:
			activate_light_node.visible = true
			can_interact = true

func _on_detect_player_body_exited(body):
	if body.name == "Player":
		activate_light_node.visible = false
		can_interact = false
