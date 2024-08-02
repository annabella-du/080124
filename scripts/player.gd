extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var coyote_timer = $CoyoteTimer
@onready var animation = $AnimationPlayer
@onready var staff = $Staff

@export_category("Basic Movement")
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

func _ready():
	coyote_timer.wait_time = coyote_time

func _physics_process(delta):
	movement(delta)
	swing()
	animations()
	
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
		if staff.can_swing:
			staff.scale.x = 1 
			staff.position.x = abs(staff.position.x)
	elif velocity.x < 0: #facing left
		sprite.flip_h = true
		if staff.can_swing:
			staff.scale.x = -1
			staff.position.x = -abs(staff.position.x)
	
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

func swing():
	if Input.is_action_just_pressed("swing"):
		if sprite.flip_h: #facing left
			staff.swing("left")
		else: #facing right
			staff.swing("right")

func animations():
	if !is_on_floor():
		animation.play("jump")
	elif velocity.x == 0:
		animation.play("idle")
	else:
		animation.play("run")

func _on_coyote_timer_timeout():
	coyote_active = false

func staff_disable():
	staff.visible = false
