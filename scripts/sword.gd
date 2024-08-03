extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var collision = $CollisionShape2D
@onready var cooldown = $CooldownTimer

@export var attack_cooldown := 0.8

var can_swing := true

func _ready():
	cooldown.wait_time = attack_cooldown
	disable()

func swing(dir : String):
	if can_swing:
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
		cooldown.start()
		disable()

func _on_cooldown_timer_timeout():
	can_swing = true
