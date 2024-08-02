extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var collision = $CollisionShape2D

var can_swing := true

func _ready():
	disable()

func swing(dir : String):
	if can_swing:
		enable()
		if dir == "right":
			animation_player.play("swing_right")
		elif dir == "left":
			animation_player.play("swing_left")
		can_swing = false

func _on_animation_player_player_animation_player_finished(anim_name):
	if anim_name == "swing_right" or anim_name == "swing_left":
		can_swing = true 
		disable()

func disable():
	visible = false
	collision.disabled = true

func enable():
	visible = true
	collision.disabled = false
