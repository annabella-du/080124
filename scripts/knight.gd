extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var detection_area = $DetectionArea
@onready var attack_area = $AttackArea
@onready var light = $PointLight2D
@onready var animation_player = $AnimationPlayer
@onready var sword = $Sword

@export var pause_length := 1.2
@onready var patrol_timer = $PatrolTimer
var left_patrol : float
var right_patrol : float
var patrol_dir = 1
var patrol_paused := false
var pause_started := false

@export var chase_speed := 60.0
@export var patrol_speed := 40.0

var player = null
var attacking := false

func _ready():
	patrol_timer.wait_time = pause_length

func _physics_process(_delta):
	movement()
	animation()
	attack()
	
	move_and_slide()

func face_right():
	sprite.flip_h = false
	sword.scale.x = 1
	sword.position.x = abs(sword.position.x)
	detection_area.scale.x = 1
	attack_area.scale.x = 1
	light.position.x = abs(light.position.x)

func face_left():
	sprite.flip_h = true
	sword.scale.x = -1
	sword.position.x = -abs(sword.position.x)
	detection_area.scale.x = -1
	attack_area.scale.x = -1
	light.position.x = -abs(light.position.x)

func movement():
	if attacking:
		velocity.x = 0
	elif player != null: #player is detected
		print(1)
		#restrict movement to patrol area
		if global_position.x <= left_patrol or global_position.x >= right_patrol: 
			player = null
		elif player.global_position.x > global_position.x: #facing right
			velocity.x = chase_speed
		else: #facing left
			velocity.x = -chase_speed
	else: #patroling
		#change position if position gets to patrol
		if global_position.x <= left_patrol and !pause_started:
			patrol_paused = true
			pause_started = true
			patrol_timer.start()
			patrol_dir = 1
		elif global_position.x >= right_patrol and !pause_started:
			patrol_paused = true
			pause_started = true
			patrol_timer.start()
			patrol_dir = -1
		if patrol_paused:
			velocity.x = 0
		else:
			pause_started = false
			velocity.x = patrol_dir * patrol_speed
	
	if velocity.x > 0:
		face_right()
	elif velocity.x < 0:
		face_left()

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
	if area.is_in_group("player"):
		attacking = false
		sword.start = true

func _on_patrol_timer_timeout():
	patrol_paused = false
