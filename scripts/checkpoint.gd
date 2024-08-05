extends Area2D

@onready var global = get_node("/root/global")
@onready var animation_player = $AnimationPlayer
@onready var activate_light = $ActivateLight

var can_activate = false
var active = false

func _ready():
	activate_light.visible = false

func _input(event):
	if event.is_action_pressed("interact") and can_activate:
		activate()

func activate():
	animation_player.play("active")
	if global.checkpoint != null:
		global.checkpoint.deactivate()
	global.checkpoint = self
	global.save_coins()
	active = true

func deactivate():
	animation_player.play("inactive")
	active = false

func _on_area_entered(area):
	if area.is_in_group("player"):
		activate_light.visible = true
		if !active:
			can_activate = true

func _on_area_exited(area):
	if area.is_in_group("player"):
		activate_light.visible = false
		can_activate = false
