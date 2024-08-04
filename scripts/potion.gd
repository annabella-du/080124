extends CharacterBody2D

@export var speed := 120.0
var dir := -1

func _physics_process(delta):
	velocity.x = speed * dir
	var collision = move_and_collide(Vector2(speed * dir * delta, 0))
	if collision:
		print(collision.get_collider_id())

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.hurt()

func _on_body_entered(body):
	if body.collision_layer == 0:
		print(1)
