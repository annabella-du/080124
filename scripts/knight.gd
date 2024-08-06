extends CharacterBody2D

### GLOBAL ###
@onready var global = get_node("/root/global")

### SPRITE NODES ###
@onready var sprite_node = $Sprite2D
@onready var alarm_red_node = $AlarmRed
@onready var alarm_yellow_node = $AlarmYellow
@onready var animation_node = $AnimationPlayer

### AREA2D NODES ###
@onready var sword_node = $Sword
@onready var detection_area_node = $DetectionArea
@onready var attack_area_node = $AttackArea

### OTHER NODES ###
@onready var light_node = $PointLight2D
@onready var patrol_timer_node = $PatrolTimer

### ATTACK VARIABLES ###
var player = null
@export var chase_speed := 60.0
var attacking := false

### PATROL VARIABLES ###
@export var patrol_pause_length := 1.2
var left_patrol : float
var right_patrol : float
var patrol_dir = 1
var patrol_paused := false
var patrol_pause_started := false
@export var patrol_speed := 40.0

### ALARM VARIABLES ###
var red_on := false
var yellow_on := false

### OTHER VARIABLES
var paused := false #global paused
var hurt := false

### BUILT IN FUNCTIONS ###
func _ready():
	### CONNECT SIGNALS###
	global.connect("pause_signal", _on_global_pause)
	global.connect("unpause_signal", _on_global_unpause)
	### SET VISIBILITIES ###
	alarm_red_node.visible = false
	alarm_yellow_node.visible = false
	### SET INITIAL VALUES ###
	patrol_timer_node.wait_time = patrol_pause_length

func _physics_process(_delta):
	if !paused and !hurt:
		movement()
		animation()
		attack()
		move_and_slide() #DON'T DELETE THIS

### CUSTOM FUNCTIONS ###
func movement():
	if attacking:
		velocity.x = 0
	
	elif player != null: #player is detected; restrict movement to patrol area
		if global_position.x <= left_patrol or global_position.x >= right_patrol: 
			player = null
		elif player.global_position.x > global_position.x: #facing right
			velocity.x = chase_speed
		else: #facing left
			velocity.x = -chase_speed
	
	else: #patroling
		### CHANGE PATROL DIRECTION ###
		if global_position.x <= left_patrol and !patrol_pause_started:
			patrol_paused = true
			patrol_pause_started = true
			patrol_timer_node.start()
			patrol_dir = 1
		elif global_position.x >= right_patrol and !patrol_pause_started:
			patrol_paused = true
			patrol_pause_started = true
			patrol_timer_node.start()
			patrol_dir = -1
		
		### MOVEMENT ###
		if patrol_paused:
			velocity.x = 0
		else:
			patrol_pause_started = false
			velocity.x = patrol_dir * patrol_speed
	
	### FACE DIRECTIONS ###
	if velocity.x > 0:
		face_right()
	elif velocity.x < 0:
		face_left()

func face_right():
	### SPRITE ###
	sprite_node.flip_h = false
	### SWORD ###
	sword_node.scale.x = 1
	sword_node.position.x = abs(sword_node.position.x)
	### AREAS ###
	detection_area_node.scale.x = 1
	attack_area_node.scale.x = 1
	### LIGHT ###
	light_node.position.x = abs(light_node.position.x)

func face_left():
	### SPRITE ###
	sprite_node.flip_h = true
	### SWORD ###
	sword_node.scale.x = -1
	sword_node.position.x = -abs(sword_node.position.x)
	### AREAS ###
	detection_area_node.scale.x = -1
	attack_area_node.scale.x = -1
	### LIGHT ###
	light_node.position.x = -abs(light_node.position.x)

func animation():
	if velocity.x == 0:
		animation_node.play("idle")
	else:
		animation_node.play("run")

func attack():
	if sword_node.can_swing and attacking:
		if sprite_node.flip_h: #facing left
			sword_node.swing("left")
		else: #facing right
			sword_node.swing("right")

func hurt_func(): #called by enemy_hurtbox hurt() which is called by potions 
	hurt = true
	if alarm_red_node.visible:
		red_on = true
		alarm_red_node.visible = false
	if alarm_yellow_node.visible:
		yellow_on = true
		alarm_yellow_node.visible = false
	animation_node.play("hurt")

### AREA2D FUNCTIONS ###
func _on_detection_area_area_entered(area):
	if area.is_in_group("player"):
		player = area
		if !hurt:
			alarm_yellow_node.visible = true
		else:
			yellow_on = true

func _on_detection_area_area_exited(area):
	if area.is_in_group("player"):
		if yellow_on:
			yellow_on = false
		alarm_yellow_node.visible = false
		player = null

func _on_attack_area_area_entered(area):
	if area.is_in_group("player"):
		if !hurt:
			alarm_red_node.visible = true
			attacking = true
		else:
			red_on = true

func _on_attack_area_area_exited(area):
	if area.is_in_group("player"):
		if red_on:
			red_on = false
		alarm_red_node.visible = false
		attacking = false
		sword_node.start = true

### CUSTOM SIGNAL FUNCTIONS ###
func _on_global_pause():
	paused = true
	animation_node.stop()

func _on_global_unpause():
	paused = false

### OTHER FUNCTIONS ###
func _on_patrol_timer_timeout():
	patrol_paused = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hurt":
		hurt = false
		if red_on:
			red_on = false
			attacking = true
			alarm_red_node.visible = true
		if yellow_on:
			yellow_on = false
			alarm_yellow_node.visible = true
