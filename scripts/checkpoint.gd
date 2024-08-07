extends Area2D

### NODES ###
@onready var global = get_node("/root/global")
@onready var player_node = get_tree().get_first_node_in_group("player")
@onready var sprite_node = $Sprite2D
@onready var animation_node = $AnimationPlayer
@onready var activate_light_node = $ActivateLight

### VARIABLES ###
var can_activate = false
var active = false
var used := false

### BUILT IN FUNCTIONS ###
func _ready():
	global.connect("respawn_signal", _on_global_respawn)
	activate_light_node.visible = false

func _input(event):
	if event.is_action_pressed("interact") and can_activate:
		activate()

### CUSTOM FUNCTIONS ###
func activate():
	active = true
	animation_node.play("active")
	activate_light_node.visible = false
	### HEALING PLAYER ###
	if !used:
		used = true
		player_node.health = player_node.lives
	### GLOBAL ###
	if global.active_checkpoint != null:
		global.active_checkpoint.deactivate()
	global.active_checkpoint = self
	global.save()

func deactivate():
	animation_node.play("inactive")
	active = false

### AREA2D FUNCTIONS ###
func _on_area_entered(area):
	if area.is_in_group("player"):
		if !active:
			activate_light_node.visible = true
			can_activate = true

func _on_area_exited(area):
	if area.is_in_group("player"):
		activate_light_node.visible = false
		can_activate = false

### CUSTOM SIGNAL FUNCTIONS ###
func _on_global_respawn():
	used = false
