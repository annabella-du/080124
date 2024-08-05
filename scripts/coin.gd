extends Area2D

@onready var global = get_node("/root/global")
@export var regular_texture : Texture2D 
@export var transparent_texture : Texture2D
@onready var sprite = $Sprite2D

enum status {hidden, transparent, regular}
var current_status : status = status.hidden
var collected = false

func _ready():
	hidden()

func _physics_process(_delta):
	if current_status == status.transparent and global.light_active:
		regular()
	elif current_status == status.regular and !global.light_active:
		transparent()

func hidden():
	sprite.visible = false
	current_status = status.hidden

func transparent():
	if !collected:
		sprite.texture = transparent_texture
		sprite.visible = true
		current_status = status.transparent

func regular():
	if !collected:
		sprite.texture = regular_texture
		sprite.visible = true
		current_status = status.regular

func add_global():
	global.unsaved_coins.append(self)
