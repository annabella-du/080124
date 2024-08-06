extends Node2D

### NODES ###
@onready var global = get_node("/root/global")
@onready var animation_player = $AnimationPlayer
@onready var activate_light = $ActivateLight

### BUILT IN FUNCTIONS ###
func _ready():
	activate_light.visible = false

func _input(event):
	if event.is_action_pressed("interact") and activate_light.visible:
		if global.light_active:
			global.light_off()
		else:
			global.light_on()

### CUSTOM FUNCTIONS ###
func on():
	animation_player.play("on")

func off():
	animation_player.play("off")

### AREA2D FUNCTIONS ###
func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		activate_light.visible = true

func _on_area_2d_area_exited(area):
	if area.is_in_group("player"):
		activate_light.visible = false
