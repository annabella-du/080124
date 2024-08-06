extends Area2D

### VARIABLES ###
@export var speed := 160.0
var dir := -1

### BUILT IN FUNCTIONS ###
func _physics_process(delta):
	global_position.x += speed * dir * delta

### AREA2D FUNCTIONS ###
func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.get_parent().hurt_func()
		queue_free()
	elif area.is_in_group("wall"):
		queue_free()
