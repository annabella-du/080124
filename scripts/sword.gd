extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var collision = $CollisionShape2D
@onready var cooldown = $CooldownTimer

@export var attack_cooldown := 0.8
@export var start_cooldown := 0.3

var can_swing := true
var start := true
var paused := false

func _ready():
	disable()
	global.connect("pause", _on_global_pause)
	global.connect("unpause", _on_global_unpause)

func swing(dir : String):
	if can_swing:
		if start:
			can_swing = false
			cooldown.wait_time = start_cooldown
			cooldown.start()
			start = false
		else:
			enable()
			if dir == "right":
				animation_player.play("swing_right")
			elif dir == "left":
				animation_player.play("swing_left")
			can_swing = false

func disable():
	visible = false
	collision.disabled = true

func enable():
	visible = true
	collision.disabled = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "swing_right" or anim_name == "swing_left":
		cooldown.wait_time = attack_cooldown
		cooldown.start()
		disable()

func _on_cooldown_timer_timeout():
	can_swing = true

func _on_global_pause():
	paused = true

func _on_global_unpause():
	paused = false
