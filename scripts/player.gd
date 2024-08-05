extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var coyote_timer = $CoyoteTimer
@onready var animation_player = $AnimationPlayer
@onready var heart_layer = $HeartLayer
@onready var shoot_point = $ShootPoint
@onready var potions_parent = get_tree().get_first_node_in_group("potions_parent")
@onready var attack_cooldown = $AttackCooldown
@onready var cooldown_bar = %ProgressBar
@onready var dark_lighting = $DarkLighting

@export var potion : Resource
@export var health := 3
var can_hurt := true
@export var speed := 95.0
@export var acceleration := 100.0

@export_category("Dynamic Jump")
@export var jump_max_height := 35.0
@export var jump_time_to_peak := 0.3
@export var jump_time_to_descent := 0.2
@onready var jump_velocity := (-2.0 * jump_max_height) / jump_time_to_peak
@onready var jump_gravity := (2.0 * jump_max_height) / (jump_time_to_peak ** 2)
@onready var fall_gravity := (2.0 * jump_max_height) / (jump_time_to_descent ** 2)

@export_category("Coyote Time")
@export var coyote_time := 0.075
var coyote_active := false
var can_coyote := false

var can_attack := true
var hurt_anim := false
var paused := false
var dead := false
var shoot_dir := 1

signal lever_on
signal lever_off

func _ready():
	can_attack = true
	coyote_timer.wait_time = coyote_time
	global.connect("pause", _on_global_pause)
	global.connect("unpause", _on_global_unpause)
	heart_layer.health = health
	cooldown_bar.max_value = attack_cooldown.wait_time
	cooldown_bar.value = cooldown_bar.max_value
	dark_lighting.visible = false

func _physics_process(delta):
	if Input.is_action_just_pressed("attack") and can_attack:
		potions_parent.shoot(shoot_dir)
		attack_cooldown.start()
		can_attack = false
	if !paused:
		movement(delta)
		animation()
		cooldown_bar.value = attack_cooldown.time_left
		if attack_cooldown.time_left == 0:
			cooldown_bar.value = cooldown_bar.max_value	
		move_and_slide()

func movement(delta : float):
	#gravity
	if velocity.y < 0: #jumping
		velocity.y += jump_gravity * delta
	else: #falling
		velocity.y += fall_gravity * delta
	
	#horizontal movement
	var horizontal_dir = Input.get_axis("left", "right")
	if horizontal_dir == 0: #not moving
		velocity.x = move_toward(velocity.x, 0, acceleration)
	else: #moving
		velocity.x = move_toward(velocity.x, speed * horizontal_dir, acceleration)
	
	#face movement direction
	if velocity.x > 0: #facing right
		sprite.flip_h = false
		shoot_point.position.x = abs(shoot_point.position.x)
		shoot_dir = 1
		#if staff.can_swing:
			#staff.scale.x = 1 
			#staff.position.x = abs(staff.position.x)
	elif velocity.x < 0: #facing left
		sprite.flip_h = true
		shoot_point.position.x = -abs(shoot_point.position.x)
		shoot_dir = -1
		#if staff.can_swing:
			#staff.scale.x = -1
			#staff.position.x = -abs(staff.position.x)
	
	#jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyote_active:
			velocity.y = jump_velocity
			coyote_active = false
	
	#dynamic jump
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y /= 2
	
	#coyote time
	if !is_on_floor() and can_coyote and !coyote_active:
		coyote_active = true
		can_coyote = false
		coyote_timer.start()
	if is_on_floor():
		can_coyote = true

#won't run
func swing():
	if Input.is_action_just_pressed("swing"):
		if sprite.flip_h: #facing left
			pass
			#staff.swing("left")
		else: #facing right
			pass
			#staff.swing("right")
func staff_disable():
	pass
	#staff.visible = false

func animation():
	if !hurt_anim:
		if !is_on_floor():
			animation_player.play("jump")
		elif velocity.x == 0:
			animation_player.play("idle")
		else:
			animation_player.play("run")

func _on_coyote_timer_timeout():
	coyote_active = false

func _on_hurt_box_area_entered(area):
	if area.is_in_group("enemy"):
		hurt_anim = true
		health -= 1
		heart_layer.health -= 1
		if health != 0:
			can_hurt = false
			animation_player.play("hurt")
		else:
			global.pause_func()
			dead = true
			animation_player.play("die")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hurt":
		can_hurt = true
		hurt_anim = false
	elif anim_name == "die":
		print("game over")

func _on_global_pause():
	paused = true
	if !hurt_anim:
		animation_player.stop()

func _on_global_unpause():
	paused = false

func _on_attack_cooldown_timeout():
	can_attack = true
