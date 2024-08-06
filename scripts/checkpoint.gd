extends Area2D

### NODES ###
@onready var global = get_node("/root/global")
@onready var player_node = get_tree().get_first_node_in_group("player")
@onready var sprite_node = $Sprite2D
@onready var animation_node = $AnimationPlayer
@onready var activate_light_node = $ActivateLight

### TEXTURES ###
@export var unused_flag_texture : Texture2D
@export var used_flag_texture : Texture2D

### VARIABLES ###
var can_activate = false
var active = false
var used := false

### BUILT IN FUNCTIONS ###
func _ready():
	global.connect("respawn_signal", _on_global_respawn)
	sprite_node.texture = unused_flag_texture
	activate_light_node.visible = false

func _input(event):
	if event.is_action_pressed("interact") and can_activate:
		activate()

### CUSTOM FUNCTIONS ###
func activate():
	animation_node.play("active")
	if !used:
		used = true
		sprite_node.texture = used_flag_texture
		player_node.health = player_node.lives
	if global.active_checkpoint != null:
		global.active_checkpoint.deactivate()
	global.active_checkpoint = self
	global.save()
	active = true

func deactivate():
	animation_node.play("inactive")
	active = false

### AREA2D FUNCTIONS ###
func _on_area_entered(area):
	if area.is_in_group("player"):
		activate_light_node.visible = true
		if !active:
			can_activate = true

func _on_area_exited(area):
	if area.is_in_group("player"):
		activate_light_node.visible = false
		can_activate = false

### CUSTOM SIGNAL FUNCTIONS ###
func _on_global_respawn():
	used = false
	sprite_node.texture = unused_flag_texture
