extends CharacterBody2D

### SPRITE NODES ###
@onready var sprite_node = $Sprite2D
@onready var animation_node = $AnimationPlayer
@onready var initial_pos_node = get_tree().get_first_node_in_group("initial_pos")

### CANVAS LAYERS ###
@onready var heart_layer_node = $HeartLayer
@onready var cooldown_bar_node = %CooldownBar
@onready var coin_count_node = %CoinCount
@onready var key_count_node = %KeyCount
@onready var red_bar_node = $CanvasLayer/RedBar

### ATTACK NODES ###
@onready var shoot_point_node = $ShootPoint
@onready var potions_parent_node = get_tree().get_first_node_in_group("potions_parent")
@onready var attack_cooldown_node = $AttackCooldown

### OTHER NODES ###
@onready var coyote_timer_node = $CoyoteTimer
@onready var dark_lighting_node = $DarkLighting
@onready var respawn_cooldown_node = $RespawnCooldown

### BASIC MOVEMENT VARIABLES ###
@export var speed := 95.0
@export var acceleration := 100.0
var on_ladder := false

### DYNAMIC JUMP VARIABLES ###
@export var jump_max_height := 35.0
@export var jump_time_to_peak := 0.3
@export var jump_time_to_descent := 0.2
@onready var jump_velocity := (-2.0 * jump_max_height) / jump_time_to_peak
@onready var jump_gravity := (2.0 * jump_max_height) / (jump_time_to_peak ** 2)
@onready var fall_gravity := (2.0 * jump_max_height) / (jump_time_to_descent ** 2)

### COYOTE TIME VARIABLES ###
@export var coyote_time := 0.075
var coyote_active := false
var can_coyote := false

### HEALTH VARIABLES ###
@export var lives := 3
@onready var health = lives

### ATTACK VARIABLES ###
@export var potion : Resource
var can_attack := true
var shoot_dir := 1

### COIN VARIABLES ###
var coins := 0 #don't directly change this
var saved_coins := 0
var unsaved_coins := 0

### KEY VARIABLES ###
var keys := 0 #don't directly change this
var saved_keys := 0
var unsaved_keys := 0

### OTHER VARIABLES ###
var paused := false
var hurt_anim := false

### SIGNALS ###
signal lever_on_signal
signal lever_off_signal

### BUILT IN FUNCTIONS ###
func _ready():
	### CONNECT SIGNALS ###
	global.connect("pause_signal", _on_global_pause)
	global.connect("unpause_signal", _on_global_unpause)
	### SET VISIBILITIES ###
	dark_lighting_node.visible = false
	red_bar_node.visible = false
	### SET INITIAL VALUES ###
	cooldown_bar_node.max_value = attack_cooldown_node.wait_time
	cooldown_bar_node.value = cooldown_bar_node.max_value
	coyote_timer_node.wait_time = coyote_time

func _physics_process(delta):
	if !paused: #nothing happens when paused
		movement(delta)
		animation()
		attack()
		update_coins_keys()
		move_and_slide() #DON'T DELETE THIS

### CUSTOM FUNCTIONS ###
func movement(delta : float):
	### GRAVITY
	if !on_ladder:
		if velocity.y < 0: #jumping
			velocity.y += jump_gravity * delta
		else: #falling
			velocity.y += fall_gravity * delta
	
	### HORIZONTAL MOVEMENT ###
	var horizontal_dir = Input.get_axis("left", "right")
	if horizontal_dir == 0: #not moving
		velocity.x = move_toward(velocity.x, 0, acceleration)
	else: #moving
		velocity.x = move_toward(velocity.x, speed * horizontal_dir, acceleration)
	
	### FACE DIRECTIONS ###
	if velocity.x > 0: #facing right
		sprite_node.flip_h = false
		shoot_point_node.position.x = abs(shoot_point_node.position.x)
		shoot_dir = 1
	elif velocity.x < 0: #facing left
		sprite_node.flip_h = true
		shoot_point_node.position.x = -abs(shoot_point_node.position.x)
		shoot_dir = -1
	
	### JUMP ### 
	if Input.is_action_just_pressed("jump") and !on_ladder:
		if is_on_floor() or coyote_active:
			velocity.y = jump_velocity
			coyote_active = false
	
	### DYNAMIC JUMP ###
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y /= 2
	
	### COYOTE JUMP ###
	if !is_on_floor() and can_coyote and !coyote_active:
		coyote_active = true
		can_coyote = false
		coyote_timer_node.start()
	if is_on_floor():
		can_coyote = true
	
	### LADDER MOVEMENT ###
	if on_ladder:
		if Input.is_action_pressed("ladder_up"):
			velocity.y = -speed
		elif Input.is_action_pressed("ladder_down"):
			velocity.y = speed
		else:
			velocity.y = 0

func animation():
	if !hurt_anim: #only runs when player isn't hurt
		if !is_on_floor():
			animation_node.play("jump")
		elif velocity.x == 0:
			animation_node.play("idle")
		else:
			animation_node.play("run")

func attack():
	### ATTACK ###
	if Input.is_action_just_pressed("attack") and can_attack:
		potions_parent_node.shoot(shoot_dir)
		attack_cooldown_node.start()
		can_attack = false
	
	### COOLDOWN BAR ###
	cooldown_bar_node.value = attack_cooldown_node.time_left
	if attack_cooldown_node.time_left == 0:
		cooldown_bar_node.value = cooldown_bar_node.max_value
	
	### RED BAR VISIBILITY ###
	if !global.light_active:
		red_bar_node.visible = true
	else:
		red_bar_node.visible = false

func update_coins_keys():
	coins = unsaved_coins + saved_coins
	coin_count_node.text = "%02d" % coins
	keys = unsaved_keys + saved_keys
	key_count_node.text= "%02d" % keys

func save_coins_keys():
	saved_coins += unsaved_coins
	unsaved_coins = 0
	saved_keys += unsaved_keys
	unsaved_keys = 0

func respawn():
	### GLOBAL RESPAWN ###
	global.respawn()
	### RESET VARIABLES ###
	health = lives
	unsaved_coins = 0
	unsaved_keys = 0
	hurt_anim = false
	
	### RESET GLOBAL POSITION ###
	if global.active_checkpoint == null:
		global_position = initial_pos_node.global_position
	else:
		global_position = global.active_checkpoint.global_position
		global_position.y += 6

### AREA2D FUNCTIONS###
func _on_hurt_box_area_entered(area):
	if area.is_in_group("enemy"):
		hurt_anim = true
		health -= 1
		if health != 0: #not dead
			animation_node.play("hurt")
		else: #dead
			animation_node.play("die")
			respawn_cooldown_node.start()

func _on_coin_detection_area_entered(area):
	if area.is_in_group("coin"):
		if area.current_status == 0 and !global.light_active and !area.collected: #0 = status.hidden
			area.transparent()

func _on_coin_collection_area_entered(area):
	if area.is_in_group("coin"):
		if area.current_status == 2: #status.regular
			area.hidden()
			area.collected = true
			unsaved_coins += 1

### TIMEOUT FUNCTIONS ###
func _on_coyote_timer_timeout():
	coyote_active = false

func _on_attack_cooldown_timeout():
	can_attack = true

func _on_respawn_cooldown_timeout():
	respawn()

### CUSTOM SIGNAL FUNCTIONS ###
func _on_global_pause(): #connected from global signal
	paused = true
	if !hurt_anim:
		animation_node.stop()

func _on_global_unpause(): #connected from global signal
	paused = false

### OTHER FUNCTIONS ###
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hurt":
		hurt_anim = false

