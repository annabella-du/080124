extends Area2D

### NODES ###
@onready var animation_node = $AnimationPlayer
@onready var collision_node = $CollisionShape2D
@onready var cooldown_node = $CooldownTimer

### ATTACK VARIABLES ###
@export var attack_cooldown_length := 0.8
@export var start_cooldown_length := 0.3
var can_swing := true
var start := true

### BUILT IN FUNCTIONS ###
func _ready():
	disable()

### CUSTOM FUNCTIONS ###
func swing(dir : String):
	if can_swing:
		if start:
			can_swing = false
			cooldown_node.wait_time = start_cooldown_length
			cooldown_node.start()
			start = false
		else:
			enable()
			if dir == "right":
				animation_node.play("swing_right")
			elif dir == "left":
				animation_node.play("swing_left")
			can_swing = false

func enable():
	visible = true
	collision_node.disabled = false

func disable():
	visible = false
	collision_node.disabled = true

### OTHER FUNCTIONS ###
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "swing_right" or anim_name == "swing_left":
		cooldown_node.wait_time = attack_cooldown_length
		cooldown_node.start()
		disable()

func _on_cooldown_timer_timeout():
	can_swing = true
