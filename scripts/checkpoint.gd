extends Area2D

### NODES ###
@onready var global = get_node("/root/global")
@onready var animation_player = $AnimationPlayer
@onready var activate_light = $ActivateLight

### VARIABLES ###
var can_activate = false
var active = false

### BUILT IN FUNCTIONS ###
func _ready():
	activate_light.visible = false

func _input(event):
	if event.is_action_pressed("interact") and can_activate:
		activate()

### CUSTOM FUNCTIONS ###
func activate():
	animation_player.play("active")
	if global.active_checkpoint != null:
		global.active_checkpoint.deactivate()
	global.active_checkpoint = self
	active = true

func deactivate():
	animation_player.play("inactive")
	active = false

### AREA2D FUNCTIONS ###
func _on_area_entered(area):
	if area.is_in_group("player"):
		activate_light.visible = true
		if !active:
			can_activate = true

func _on_area_exited(area):
	if area.is_in_group("player"):
		activate_light.visible = false
		can_activate = false
