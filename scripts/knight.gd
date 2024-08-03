extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var detection_area = $DetectionArea
@onready var attack_area = $AttackArea
@onready var light = $PointLight2D
@onready var animation_player = $AnimationPlayer
@onready var sword = $Sword

@export var speed := 60.0

var player = null
var attacking := false

func _physics_process(_delta):
	movement()
	animation()
	attack()
	
	move_and_slide()

func movement():
	if attacking:
		velocity.x = 0
	elif player != null:
		if player.global_position.x > global_position.x: #facing right
			sprite.flip_h = false
			sword.scale.x = 1
			sword.position.x = abs(sword.position.x)
			detection_area.scale.x = 1
			attack_area.scale.x = 1
			light.position.x = abs(light.position.x)
			velocity.x = speed
		else: #facing left
			sprite.flip_h = true
			sword.scale.x = -1
			sword.position.x = -abs(sword.position.x)
			detection_area.scale.x = -1
			attack_area.scale.x = -1
			light.position.x = -abs(light.position.x)
			velocity.x = -speed
	else:
		velocity.x = 0

func animation():
	if velocity.x == 0:
		animation_player.play("idle")
	else:
		animation_player.play("run")

func attack():
	if sword.can_swing and attacking:
		if sprite.flip_h: #facing left
			sword.swing("left")
		else: #facing right
			sword.swing("right")

func _on_detection_area_area_entered(area):
	if area.is_in_group("player"):
		player = area

func _on_detection_area_area_exited(area):
	if area.is_in_group("player"):
		player = null

func _on_attack_area_area_entered(area):
	if area.is_in_group("player"):
		attacking = true
		

func _on_attack_area_area_exited(area):
	attacking = false
