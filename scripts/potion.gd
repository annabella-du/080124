extends Area2D

@export var speed := 20.0
var dir

func _physics_process(delta):
	position.x += speed * dir * delta

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.hurt()
