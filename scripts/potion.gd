extends Area2D

@export var speed := 160.0
var dir := -1

func _physics_process(delta):
	global_position.x += speed * dir * delta

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.hurt()
		queue_free()
	elif area.is_in_group("wall"):
		queue_free()
