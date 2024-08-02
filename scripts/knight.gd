extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var detection_area = $DetectionArea
@onready var animation_player = $AnimationPlayer

@export var speed := 60.0

var player = null

func _physics_process(_delta):
	if player != null:
		if player.global_position.x > global_position.x: #player is to the right of knight
			sprite.flip_h = false
			detection_area.scale.x = 1
			velocity.x = speed
		else: #player is to the left of knight
			sprite.flip_h = true
			detection_area.scale.x = -1
			velocity.x = -speed
	else:
		velocity.x = 0
	
	if velocity.x == 0:
		animation_player.play("idle")
	else:
		animation_player.play("run")
	
	move_and_slide()

func _on_detection_area_area_entered(area):
	if area.is_in_group("player"):
		player = area

func _on_detection_area_area_exited(area):
	if area.is_in_group("player"):
		player = null
