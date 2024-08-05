extends Node2D

@export var regular_texture : Texture2D 
@export var transparent_texture : Texture2D
@onready var sprite = $Sprite2D

var can_pickup := false

func _ready():
	hidden()

func hidden():
	sprite.visible = false
	can_pickup = false

func regular():
	sprite.texture = regular_texture
	can_pickup = true

func transparent():
	sprite.texture = transparent_texture
	can_pickup = false
